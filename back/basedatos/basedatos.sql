-- DROP DATABASE IF EXISTS proyecto_itsp;
-- CREATE DATABASE proyecto_itsp CHARACTER SET utf16 COLLATE utf16_spanish_ci;
-- USE proyecto_itsp;

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
    id_grupo INT UNSIGNED NULL, -- puede quedar NULL si se borra el grupo
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
    id_adscrito INT UNSIGNED NULL, -- puede quedar NULL si se borra adscrito
    grado INT UNSIGNED NOT NULL, -- Ejemplo: 1 - Primero, 2 - Segundo, 3 - Tercero
    nombre VARCHAR(5) -- Ejemplo: MD, MA, etc.
);

-- Representa la relacion de Profesor (Enseña) Materia
DROP TABLE IF EXISTS Clases;
CREATE TABLE Clases (
	id_clase INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_profesor INT UNSIGNED NULL, -- puede quedar NULL si se borra profesor
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
    id_profesor INT UNSIGNED NULL, -- puede quedar NULL si se borra profesor
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
    id_espacio INT UNSIGNED NULL -- puede quedar NULL si se borra espacio
);

-- -- -- -- RESTRICCIONES DE CLAVES FORANEAS

-- ============================
-- USUARIOS BASE
-- ============================

ALTER TABLE Alumnos 
  -- Si se borra el usuario base, también se borra el alumno
  ADD CONSTRAINT fk__alumnos_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
  -- Si se borra el grupo, el alumno no se borra, simplemente queda sin grupo (NULL)
  ADD CONSTRAINT fk__alumnos_grupos FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE SET NULL;

ALTER TABLE Adscritos 
  -- Si se borra el usuario base, también se borra el adscrito
  ADD CONSTRAINT fk__adscritos_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;

ALTER TABLE Profesores 
  -- Si se borra el usuario base, también se borra el profesor
  ADD CONSTRAINT fk__profesores_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE;

-- ============================
-- GRUPOS
-- ============================

ALTER TABLE Grupos 
  -- Si se borra el adscrito, el grupo sigue existiendo pero sin adscrito asignado
  ADD CONSTRAINT fk__grupos_adscritos FOREIGN KEY (id_adscrito) REFERENCES Adscritos(id_adscrito) ON DELETE SET NULL;

-- ============================
-- HORAS
-- ============================

ALTER TABLE Horas 
  -- Si se borra el periodo, se eliminan las horas asociadas
  ADD CONSTRAINT fk__horas_periodos FOREIGN KEY (id_periodo) REFERENCES Periodos(id_periodo) ON DELETE CASCADE,
  -- Si se borra el día, se eliminan las horas asociadas
  ADD CONSTRAINT fk__horas_dias FOREIGN KEY (id_dia) REFERENCES Dias(id_dia) ON DELETE CASCADE;

-- ============================
-- MODULOS (Relación Grupo ↔ Hora)
-- ============================

ALTER TABLE Modulos 
  -- Si se borra el periodo, se eliminan los módulos relacionados
  ADD CONSTRAINT fk__modulos_periodos FOREIGN KEY (id_periodo) REFERENCES Periodos(id_periodo) ON DELETE CASCADE,
  -- Si se borra el día, se eliminan los módulos relacionados
  ADD CONSTRAINT fk__modulos_dias FOREIGN KEY (id_dia) REFERENCES Dias(id_dia) ON DELETE CASCADE;

-- ============================
-- CLASES (Profesor ↔ Materia)
-- ============================

ALTER TABLE Clases 
  -- Si se borra el profesor, la clase sigue existiendo pero sin profesor asignado
  ADD CONSTRAINT fk__clases_profesores FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor) ON DELETE SET NULL,
  -- Si se borra la materia, se eliminan todas las clases de esa materia
  ADD CONSTRAINT fk__clases_materias FOREIGN KEY (id_materia) REFERENCES Materias(id_materia) ON DELETE CASCADE;

-- ============================
-- ESPACIOS
-- ============================

ALTER TABLE Espacios 
  -- Si se borra un tipo de espacio, también se eliminan todos los espacios de ese tipo
  ADD CONSTRAINT fk__espacios_tipos FOREIGN KEY (id_tipo) REFERENCES TiposEspacios(id_tipo) ON DELETE CASCADE;

-- ============================
-- RESERVAS DE ESPACIOS
-- ============================

ALTER TABLE ReservasDeEspacios 
  -- Si se borra el profesor, la reserva queda registrada pero sin profesor (NULL)
  ADD CONSTRAINT fk__reservas_profesores FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor) ON DELETE SET NULL,
  -- Si se borra el espacio, también se eliminan las reservas asociadas
  ADD CONSTRAINT fk__reservas_espacios FOREIGN KEY (id_espacio) REFERENCES Espacios(id_espacio) ON DELETE CASCADE;

-- ============================
-- RECURSOS
-- ============================

ALTER TABLE RecursosExternos 
  -- Si se borra el recurso base, también se borra el recurso externo
  ADD CONSTRAINT fk__recursosExternos_recursos FOREIGN KEY (id_recurso) REFERENCES Recursos(id_recurso) ON DELETE CASCADE;

ALTER TABLE RecursosInternos 
  -- Si se borra el recurso base, también se borra el recurso interno
  ADD CONSTRAINT fk__recursosInternos_recursos FOREIGN KEY (id_recurso) REFERENCES Recursos(id_recurso) ON DELETE CASCADE,
  -- Si se borra el espacio, el recurso interno sigue existiendo pero sin espacio asignado
  ADD CONSTRAINT fk__recursosInternos_espacios FOREIGN KEY (id_espacio) REFERENCES Espacios(id_espacio) ON DELETE SET NULL;


-- -- -- -- DATOS
INSERT INTO TiposEspacios (nombre) VALUES 
	('Aula'), 
	('Salon'), 
	('Salon de Conferencias'),
	('Laboratorio de Quimica'),
	('Laboratorio de Fisica'),
	('Laboratorio de Mantenimiento');
