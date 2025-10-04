<?php
include_once 'db.php';
include_once 'sql.php';
include_once 'respuestas.php';

/**
 * Registra un usuario.
 * @return int|Error El id del usuario registrado o un error.
 */
function registrarUsuario($con, $ci, $nombre, $apellido, $contrasena, $email) : int|UnError
{
    $contrasenaHash = password_hash($contrasena, PASSWORD_BCRYPT);

    $sql = "INSERT INTO Usuarios (ci, nombre, apellido, contrasena, email) VALUES (?, ?, ?, ?, ?)";
    $resultado = SQL::actionQuery($con, $sql, "sssss", $ci, $nombre, $apellido, $contrasenaHash, $email);

    if($resultado instanceof UnError)
    {
        if($resultado->tipoError == TipoError::duplicate_entry)
        {
            switch($resultado->origen['columna'])
            {
                case 'ci': $resultado->mensaje = "Ya hay un usuario registrado con la cedula ". $ci. "."; break;
                default: break;
            }
        }
    }

    return $con->insert_id;
}

/**
 * Registra un usuario y su version solicitante.
 * @return int|Error El id del solicitante registrado o un error.
 */
function registrarUsuarioSolicitante($con, $ci, $nombre, $apellido, $contrasena, $email) : int|UnError
{
    $resultado = registrarUsuario($con, $ci, $nombre, $apellido, $contrasena, $email);
    if($resultado instanceof UnError)
    {
        return $resultado;
    }
    $idUsuario = $resultado;

    $sql = "INSERT INTO Solicitantes (id_usuario) VALUES (?)";
    $resultado = SQL::actionQuery($con, $sql, "i", $idUsuario);
    return $con->insert_id;
}
?>