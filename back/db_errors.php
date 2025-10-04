<?php
class UnError
{
    public bool $success = false;
    public TipoError $tipoError; // Ejemplo: TipoErrorSql::duplicate_entry
    public mixed $origen;         // Ejemplo: 'ci'
    public string $mensaje;     // Ejemplo: 'Error: La cedula de identidad ya esta registrada'

    public function __construct(TipoError $tipoError, mixed $origen, ?string $mensaje = null)
    {
        $this->tipoError = $tipoError;
        $this->origen = $origen;
        $this->mensaje = $mensaje;
    }

    public static function prepare() : UnError
    {
        return new UnError(TipoError::prepare, null, "Un error ha ocurrido en la preparacion de la consulta.");
    }

    public static function bind_param() : UnError
    {
        return new UnError(TipoError::bind_param, null, "Un error ha ocurrido en la vinculacion de datos de la consulta.");
    }

    public static function send_long_data() : UnError
    {
        return new UnError(TipoError::send_long_data, null, "Un error ha ocurrido en el envio de datos para la vinculacion de la consulta.");
    }

    public static function execute() : UnError
    {
        return new UnError(TipoError::execute, null, "Un error ha ocurrido en la ejecucion de la consulta.");
    }

    public static function result() : UnError
    {
        return new UnError(TipoError::result, null, "Un error ha ocurrido al recibir los datos de la consulta, pero esta se ha ejecutado correctamente.");
    }

    public static function duplicate_entry(string $nombreColumna, string $valor) : UnError
    {
        return new UnError(TipoError::duplicate_entry, ["columna" => $nombreColumna, "valor" => $valor], "La consulta provocara que '". $nombreColumna. "' no sea unica, el valor repetido es '". $valor. "'.");
    }

    public static function not_found(string $queEntidadNoSeEncontro) : UnError
    {
        return new UnError(TipoError::not_found, ["que" => $queEntidadNoSeEncontro], "No se ha encontrado ningun registro en la tabla '". $queEntidadNoSeEncontro. "'.");
    }

    public static function identificacion_invalida(string $queEntidadNoSeEncontro) : UnError
    {
        return new UnError(TipoError::not_found, ["que" => $queEntidadNoSeEncontro], "La identificacion proporcionada para '". $queEntidadNoSeEncontro. "' no es valida.");
    }

    public static function contrasena_incorrecta() : UnError
    {
        return new UnError(TipoError::contrasena_incorrecta, null, "La contrasena es incorrecta.");
    }
}

enum TipoError : string
{
    case prepare = "prepare";
    case bind_param = "bind_param";
    case send_long_data = "send_long_data";
    case execute = "execute";
    case result = "result";
    case duplicate_entry = "duplicate_entry";
    case not_found = "not_found";
    case identificacion_invalida = "identificacion_invalida";
    case contrasena_incorrecta = "contrasena_incorrecta";
}
?>