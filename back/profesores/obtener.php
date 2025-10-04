<?php
session_start();
include_once '../db.php';
include_once '../sql.php';
include_once '../respuestas.php';
include_once '../usuarios.php';

if($_SERVER['REQUEST_METHOD'] !== "POST")
{
    http_response_code(500);
    die();
}
$con = conectarBd();

$ci = $_POST['ci'] ?? null;
$id = $_POST['id'] ?? null;
$nombre = $_POST['nombre'] ?? null;
$resultado = null;

if(isset($id))
{
    $sql = "SELECT * FROM Profesores, Solicitantes, Usuarios WHERE id_profesor = ? AND Usuarios.id_usuario = Solicitantes.id_usuario AND Solicitantes.id_solicitante = Profesores.id_solicitante";
    $resultado = SQL::valueQuery($con, $sql, "s", $id);
}
elseif(isset($ci))
{
    $sql = "SELECT * FROM Profesores, Solicitantes, Usuarios WHERE ci = ? AND Usuarios.id_usuario = Solicitantes.id_usuario AND Solicitantes.id_solicitante = Profesores.id_solicitante";
    $resultado = SQL::valueQuery($con, $sql, "s", $ci);
}
elseif(isset($nombre))
{
    $sql = "SELECT * 
            FROM Profesores 
            JOIN Solicitantes ON Profesores.id_solicitante = Solicitantes.id_solicitante
            JOIN Usuarios ON Solicitantes.id_usuario = Usuarios.id_usuario
            WHERE CONCAT(Usuarios.nombre, ' ', Usuarios.apellido) LIKE ?";
    
    $param = "%$nombre%";
    $resultado = SQL::valueQuery($con, $sql, "s", $param);
}
else
{
    enviarRespuesta(UnError::identificacion_invalida("Profesor"));
}

if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}

if($resultado->num_rows === 0)
{
    $error = UnError::not_found("Profesor");
    $error->mensaje = "No se ha encontrado ningun profesor con los datos proporcionados.";
    enviarRespuesta($error);
}

enviarRespuesta($resultado->fetch_array(MYSQLI_ASSOC));
?>