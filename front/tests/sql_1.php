<?php
include_once '../../back/db.php';
include_once '../../back/sql.php';

$con = conectarBd();
$hash = password_hash("RalseiTheFluffyBoi", PASSWORD_BCRYPT);
$sql = "INSERT INTO Usuarios (ci, nombre, apellido, contrasena, email) VALUES (?, ?, ?, ?, ?)";
$result = SQL::actionQuery($con, $sql, "sssss", '12345678', 'Ralsei', 'Deltarune', $hash, 'ralsei@gmail.com');
ErrorSql::cambiar_mensaje_si($result, TipoErrorSql::duplicate_entry, "No puedes registrarte, ya existe un usuario con esta cedula.");

echo json_encode($result);
?>