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
$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$contrasena = $_POST['contrasena'];
$email = $_POST['email']; 

$resultado = registrarUsuarioSolicitante($con, $ci, $nombre, $apellido, $contrasena, $email);
if($resultado instanceof UnError)
{
    enviarRespuesta($resultado);
}
$idSolicitante = $resultado;

$sql = "INSERT INTO Profesores (id_solicitante) VALUES (?)";
$resultado = SQL::actionQuery($con, $sql, "i", $idSolicitante);
enviarRespuesta($resultado);
?>