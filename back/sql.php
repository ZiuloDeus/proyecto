<?php
include_once 'db_errors.php';

abstract class SQL
{
	private static function replaceBlobsValuesWithNull(string $types, array $values) : array
	{
		$_values = [];
		$_types = str_split($types);
		for($i = 0; $i < count($values); ++$i)
		{
			$type = $_types[$i];
			$value = $values[$i]; 
			$_values[] = $type === 'b' ? null : $value;
		}

		return $_values;
	}

	private static function getBlobEntries(string $types, array $values) : array
	{
		$_values = [];
		$_types = str_split($types);
		for($i = 0; $i < count($values); ++$i)
		{
			$type = $_types[$i];
			if($type !== 'b') continue;

			$value = $values[$i];
			$_values[$i] = $value;
		}

		return $_values;
	}

	public static function query(mysqli $con, string $query, string $types, ...$values) : mysqli_stmt|UnError
	{
		$stmt = $con->prepare($query);
		if(!$stmt) return UnError::prepare();

		$unblobedValues = self::replaceBlobsValuesWithNull($types, $values);
		if(!$stmt->bind_param($types, ...$unblobedValues)) return UnError::bind_param();

		$blobEntries = self::getBlobEntries($types, $values);
		foreach($blobEntries as $blobIndex => $blob)
		{
			if(!$stmt->send_long_data($blobIndex, $blob)) return UnError::send_long_data();
		}

		if(!$stmt->execute())
		{
			if($stmt->errno == 1062) // Atributo unico repetido.
			{
				if(preg_match("/Duplicate entry '(.*?)' for key '(.*?)'/", $stmt->error, $matches))
				$valorRepetido = $matches[1];
				$nombreColumnaRepetida = $matches[2];

				return UnError::duplicate_entry($nombreColumnaRepetida, $valorRepetido);
			}

			return UnError::execute();
		}
		return $stmt;
	}

	public static function valueQuery(mysqli $con, string $query, string $types, ...$values) : mysqli_result|UnError
	{
		$stmt = self::query($con, $query, $types, ...$values);
		if(!($stmt instanceof mysqli_stmt)) return $stmt;

		$result = $stmt->get_result();
		if(!$result) return UnError::result();

		return $result;
	}

	public static function actionQuery(mysqli $con, string $query, string $types, ...$values) : true|UnError
	{
		$stmt = self::query($con, $query, $types, ...$values);
		if(!($stmt instanceof mysqli_stmt)) return $stmt;

		return true;
	}
}
?>