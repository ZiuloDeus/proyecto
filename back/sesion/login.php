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

$ci = $_POST['ci'];
$contrasena = $_POST['contrasena'];

// Obtener datos del usuario en sesion
$sql = "SELECT * FROM Usuarios WHERE ci = ?";
$resultado = SQL::valueQuery($con, $sql, "s", $ci);
if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}
if($resultado->num_rows === 0)
{
    $error = UnError::not_found("Usuario");
    $error->mensaje = "No se ha encontrado ningun usuario con la cedula ".$ci.".";
    enviarRespuesta($error);
}
$usuario = $resultado->fetch_assoc();
if(!password_verify($contrasena, $usuario['contrasena']))
{
    $error = UnError::contrasena_incorrecta();
    enviarRespuesta($error);
}

$_SESSION['id_usuario'] = $usuario['id_usuario'];
$_SESSION['ci'] = $usuario['ci'];
$_SESSION['nombre'] = $usuario['nombre'];
$_SESSION['apellido'] = $usuario['apellido'];
$_SESSION['email'] = $usuario['email'];
$_SESSION['rol'] = 'visitante';

// Si el usuario es un solicitante, Obtener su id_solicitante en sesion
$sql = "SELECT * FROM Solicitantes WHERE id_usuario = ?";
$resultado = SQL::valueQuery($con, $sql, "i", $usuario['id_usuario']);
if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}
if($resultado->num_rows > 0)
{
    $solicitante = $resultado->fetch_assoc();
    $_SESSION['id_solicitante'] = $solicitante['id_solicitante'];
}

// Si el usuario es un profesor, Obtener su id_profesor en sesion
$sql = "SELECT * FROM Profesores, Solicitantes WHERE Profesores.id_solicitante = Solicitantes.id_solicitante AND Solicitantes.id_usuario = ?";
$resultado = SQL::valueQuery($con, $sql, "i", $usuario['id_usuario']);
if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}
if($resultado->num_rows > 0)
{
    $profesor = $resultado->fetch_assoc();
    $_SESSION['id_profesor'] = $profesor['id_profesor'];
    $_SESSION['rol'] = 'profesor';
}

// Si el usuario es un adscrito, guardar su id_adscrito en sesion
$sql = "SELECT * FROM Adscritos WHERE Adscritos.id_usuario = ?";
$resultado = SQL::valueQuery($con, $sql, "i", $usuario['id_usuario']);
if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}
if($resultado->num_rows > 0)
{
    $profesor = $resultado->fetch_assoc();
    $_SESSION['id_adscrito'] = $profesor['id_adscrito'];
    $_SESSION['rol'] = 'adscrito';
}

enviarRespuesta(["usuario" => $usuario, "rol" => $_SESSION['rol']]);
?>