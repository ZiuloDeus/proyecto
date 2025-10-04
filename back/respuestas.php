<?php
include_once 'db_errors.php';

/**
 * Envía una respuesta HTTP en formato JSON y termina la ejecución del script.
 * Si el valor es una instancia de `UnError`, se envía el error y el código de estado 500.
 * En caso contrario, se envía un código de estado 200 junto con el valor.
 * 
 * @param mixed $valor El valor a enviar en la respuesta. Puede ser cualquier tipo de dato o una instancia de `UnError`.
 */
function enviarRespuesta(mixed $valor)
{
    $isError = $valor instanceof UnError;
    http_response_code($isError ? 500 : 200);

    if($isError) echo json_encode($valor);
    else echo json_encode(['success' => true, 'valor' => $valor]);
    die();
}