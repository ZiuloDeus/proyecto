DROP DATABASE IF EXISTS proyecto_itsp;
CREATE DATABASE proyecto_itsp CHARACTER SET utf16 COLLATE utf16_spanish_ci;
USE proyecto_itsp;




-- -- -- -- TABLAS - USUARIOS
-- Datos de usuario base, compartido entre usuarios especificos
DROP TABLE IF EXISTS Usuarios;
CREATE TABLE Usuarios (
	id_usuario INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    ci VARCHAR(8) UNIQUE NOT NULL,
    apellido VARCHAR(30) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    email VARCHAR(50) NOT NULL
);

-- Usuario especifico, categorizacion de la tabla Usuario
DROP TABLE IF EXISTS Alumnos;
CREATE TABLE Alumnos (
	id_alumno INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL,
    id_grupo INT UNSIGNED NOT NULL,
    telefono_tutor VARCHAR(12) NOT NULL
);

-- Usuario especifico, categorizacion de la tabla Usuario
DROP TABLE IF EXISTS Adscritos;
CREATE TABLE Adscritos (
	id_adscrito INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL
);

-- Usuario especifico, categorizacion de la tabla Usuario
DROP TABLE IF EXISTS Profesores;
CREATE TABLE Profesores (
	id_profesor INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_usuario INT UNSIGNED NOT NULL
);

-- -- -- -- TABLAS - CLASES
-- Informacion de una materia, Ejemplo: Programacion, Ciberseguridad
DROP TABLE IF EXISTS Materias;
CREATE TABLE Materias (
	id_materia INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL
);

-- Representa un lapso de tiempo en un dia dia cualquiera, Ejemplo: Primera, Segunda, etc. 
DROP TABLE IF EXISTS Periodos;
CREATE TABLE Periodos (
	id_periodo INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    numero INT UNSIGNED UNIQUE NOT NULL,
    hora_entrada TIMESTAMP NOT NULL,
    hora_salida TIMESTAMP NOT NULL
);

-- Representa un dia de la semana, Ejemplo: Lunes, Martes, Miércoles, etc.
DROP TABLE IF EXISTS Dias;
CREATE TABLE Dias (
	id_dia INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(10) NOT NULL
);

-- Representa un periodo relacionado a un dia, Ejemplo: Lunes a primera, Lunes a segunda, Martes a primera, etc.
DROP TABLE IF EXISTS Horas;
CREATE TABLE Horas (
	id_hora INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_periodo INT UNSIGNED NOT NULL,
    id_dia INT UNSIGNED NOT NULL
);

-- Representa la relaciones entre un Grupo y una Hora. Ejemplo: 3MD a Primera, 3MD a Segunda. 
DROP TABLE IF EXISTS Modulos;
CREATE TABLE Modulos (
	id_hora INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_periodo INT UNSIGNED NOT NULL,
    id_dia INT UNSIGNED NOT NULL
);

-- Representa un grupo. Ejemplo: 3MD
DROP TABLE IF EXISTS Grupos;
CREATE TABLE Grupos (
	id_grupo INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_adscrito INT UNSIGNED NOT NULL,
    grado INT UNSIGNED NOT NULL, -- Ejemplo: 1 - Primero, 2 - Segundo, 3 - Tercero
    nombre VARCHAR(5) -- Ejemplo: MD, MA, etc.
);

-- Representa la relacion de Profesor (Enseña) Materia
DROP TABLE IF EXISTS Clases;
CREATE TABLE Clases (
	id_clase INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_profesor INT UNSIGNED NOT NULL,
    id_materia INT UNSIGNED NOT NULL
);

-- -- -- -- TABLAS - ESPACIOS
-- Representa un espacio de la institucion, Ejemplo: Aula, Salon, Laboratorio de Quimica, Laboratorio de Fisica, etc.
DROP TABLE IF EXISTS Espacios;
CREATE TABLE Espacios (
	id_espacio INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_tipo INT UNSIGNED NOT NULL, -- Ejemplo: Id de la entrada 'Salon' o 'Aula'
    numero INT UNSIGNED NULL -- Ejemplo: 1 (para Aula 1, o Salon 1)
);

-- Contiene los tipos de espacios
DROP TABLE IF EXISTS TiposEspacios;
CREATE TABLE TiposEspacios (
	id_tipo INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) UNIQUE -- Ejemplo: 'Salon' o 'Aula'
);

-- Contiene informacion de la reserva de espacios creadas por profesores
DROP TABLE IF EXISTS ReservasDeEspacios;
CREATE TABLE ReservasDeEspacios (
	id_reserva INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_profesor INT UNSIGNED NOT NULL,
    id_espacio INT UNSIGNED NOT NULL,
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- Nota, Modificar MER y MR para remplazar fk a TIMESTAMP
    fechaInicio DATETIME NOT NULL,
    fechaFinal DATETIME NOT NULL
);

-- -- -- -- TABLAS - RECURSOS
-- Tabla base la cual contiene columnas compartidas para categorizar
DROP TABLE IF EXISTS Recursos;
CREATE TABLE Recursos (
	id_recurso INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_tipo INT UNSIGNED NOT NULL,
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- Nota, Modificar MER y MR para remplazar fk a ENUM
    problema ENUM ('OK', 'AVERIADO', 'MANTENIMIENTO') NOT NULL DEFAULT 'OK'
);

DROP TABLE IF EXISTS RecursosExternos;
CREATE TABLE RecursosExternos (
	id_recurso_externo INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_recurso INT UNSIGNED NOT NULL,
    esta_disponible BOOL NOT NULL
);

DROP TABLE IF EXISTS RecursosInternos;
CREATE TABLE RecursosInternos (
	id_recurso_interno INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_recurso INT UNSIGNED NOT NULL,
    id_espacio INT UNSIGNED NULL
);



-- -- -- -- RESTRICCIONES DE CLAVES FORANEAS
ALTER TABLE Alumnos ADD CONSTRAINT fk__alumnos_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;
ALTER TABLE Adscritos ADD CONSTRAINT fk__adscritos_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;
ALTER TABLE Profesores ADD CONSTRAINT fk__profesores_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;
ALTER TABLE Profesores ADD CONSTRAINT fk__profesores_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;


-- -- -- -- DATOS
INSERT INTO TiposEspacios (nombre) VALUES 
	('Aula'), 
	('Salon'), 
	('Salon de Conferencias'),
	('Laboratorio de Quimica'),
	('Laboratorio de Fisica'),
	('Laboratorio de Mantenimiento');