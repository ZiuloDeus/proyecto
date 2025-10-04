<?php
class ErrorSql
{
    public TipoErrorSql $codigoError; // Ejemplo: CodigoErrorSql::duplicate_entry
    public mixed $dato;         // Ejemplo: 'ci'
    public string $mensaje;     // Ejemplo: 'Error: La cedula de identidad ya esta registrada'

    public function __construct(TipoErrorSql $codigoError, mixed $dato, ?string $mensaje = null)
    {
        $this->codigoError = $codigoError;
        $this->dato = $dato;
        $this->mensaje = $mensaje;
    }

    public static function cambiar_mensaje_si(mixed $errorSql, TipoErrorSql $condicion, string $mensaje) : void
    {
        if(!($errorSql instanceof ErrorSql)) return;
        if($errorSql->codigoError !== $condicion) return;

        $errorSql->mensaje = $mensaje;
    }


    public static function prepare() : ErrorSql
    {
        return new self(TipoErrorSql::prepare, null, "Un error ha ocurrido en la preparacion de la consulta.");
    }

    public static function bind_param() : ErrorSql
    {
        return new self(TipoErrorSql::bind_param, null, "Un error ha ocurrido en la vinculacion de datos de la consulta.");
    }

    public static function send_long_data() : ErrorSql
    {
        return new self(TipoErrorSql::send_long_data, null, "Un error ha ocurrido en el envio de datos para la vinculacion de la consulta.");
    }

    public static function execute() : ErrorSql
    {
        return new self(TipoErrorSql::execute, null, "Un error ha ocurrido en la ejecucion de la consulta.");
    }

    public static function result() : ErrorSql
    {
        return new self(TipoErrorSql::result, null, "Un error ha ocurrido al recibir los datos de la consulta, pero esta se ha ejecutado correctamente.");
    }

    public static function duplicate_entry(string $nombreColumna, string $valor) : ErrorSql
    {
        return new self(TipoErrorSql::duplicate_entry, ["columna" => $nombreColumna, "valor" => $valor], "La consulta probocara que '". $nombreColumna. "' no sea unica, el valor repetido es '". $valor. "'.");
    }
}

enum TipoErrorSql : string
{
    case prepare            = "prepare";
    case bind_param         = "bind_param";
    case send_long_data     = "send_long_data";
    case execute            = "execute";
    case result             = "result";
    case duplicate_entry    = "duplicate_entry";
}
?>