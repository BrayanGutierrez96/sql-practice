--Tienes que gestionar una base de datos para un sistema de gestión de cursos en línea. La base de datos debe contener información sobre cursos, estudiantes e inscripciones. 
--La relación entre los cursos y los estudiantes esDE MUCHOS A MUCHOS,
--YA QUE UN ESTUDIANTE PUEDEestar inscrito en varios cursos y un curso puede tener varios estudiantes.
DROP TABLE IF EXISTS INSCRIPCIONES;

DROP TABLE IF EXISTS CURSOS;

DROP TABLE IF EXISTS ESTUDIANTES;

CREATE TABLE ESTUDIANTES (
	ESTUDIANTE_ID SERIAL PRIMARY KEY,
	ESTUDIANTE_NOMBRE VARCHAR(50) NOT NULL,
	ESTUDIANTE_EDAD INT CHECK (ESTUDIANTE_EDAD > 0),
	ESTUDIANTE_CORREO VARCHAR(50) NOT NULL
);

CREATE TABLE CURSOS (
	CURSO_ID SERIAL PRIMARY KEY,
	CURSO_FECHA DATE DEFAULT NOW(),
	CURSO_NOMBRE VARCHAR(50) NOT NULL
);

CREATE TABLE INSCRIPCIONES (
	INCRIPCION_ID SERIAL PRIMARY KEY,
	ESTUDIANTE_ID INT,
	CURSO_ID INT,
	INSCRIPCION_FECHA DATE DEFAULT NOW(),
	FOREIGN KEY (ESTUDIANTE_ID) REFERENCES ESTUDIANTES (ESTUDIANTE_ID),
	FOREIGN KEY (CURSO_ID) REFERENCES CURSOS (CURSO_ID)
);

INSERT INTO
	ESTUDIANTES (
		ESTUDIANTE_NOMBRE,
		ESTUDIANTE_EDAD,
		ESTUDIANTE_CORREO
	)
VALUES
	('Juan Pérez', 15, 'juan.perez@example.com'),
	('María Gómez', 15, 'maria.gomez@example.com'),
	('Carlos López', 15, 'carlos.lopez@example.com'),
	('Ana Torres', 14, 'ana.torres@example.com'),
	('Luis Ramírez', 15, 'luis.ramirez@example.com'),
	('Lucía Fernández', 16, 'lucia@example.com'),
	('Miguel Herrera', 17, 'miguel@example.com'),
	('Laura Morales', 15, 'laura@example.com');

SELECT
	*
FROM
	ESTUDIANTES;

INSERT INTO
	CURSOS (CURSO_NOMBRE, CURSO_FECHA)
VALUES
	('Introducción a la Programación', '2023-01-15'),
	('Bases de Datos Avanzadas', '2023-02-20'),
	('Desarrollo Web con JavaScript', '2023-03-10'),
	('Machine Learning', '2023-04-05'),
	('Big Data y Análisis de Datos', '2023-05-12'),
	('Inteligencia Artificial', '2023-06-15'),
	('Ciberseguridad', '2023-07-10'),
	('Redes de Computadoras', '2023-08-01');

SELECT
	*
FROM
	CURSOS;

INSERT INTO
	INSCRIPCIONES (ESTUDIANTE_ID, CURSO_ID, INSCRIPCION_FECHA)
VALUES
	(1, 1, '2023-01-10'),
	(2, 1, '2023-01-12'),
	(3, 2, '2023-02-18'),
	(4, 3, '2023-03-08'),
	(5, 4, '2023-04-01'),
	(1, 3, '2023-03-05'),
	(2, 4, '2023-04-03'),
	(3, 5, '2023-05-08'),
	(4, 2, '2023-02-15'),
	(6, 1, '2023-01-15'),
	(7, 6, '2023-06-12'),
	(8, 7, '2023-07-08'),
	(5, 8, '2023-07-30'),
	(1, 7, '2023-07-09'),
	(2, 5, '2023-05-10');

SELECT
	*
FROM
	INSCRIPCIONES;

--Obtener una lista de todos los cursos y los estudiantes inscritos en ellos.
SELECT
	CURSOS.CURSO_NOMBRE,
	E.ESTUDIANTE_NOMBRE
FROM
	CURSOS
	JOIN INSCRIPCIONES I ON I.CURSO_ID = CURSOS.CURSO_ID
	JOIN ESTUDIANTES E ON E.ESTUDIANTE_ID = I.ESTUDIANTE_ID
	--Encontrar todos los cursos en los que un estudiante específico está inscrito.
SELECT
	ES.ESTUDIANTE_NOMBRE,
	CUR.CURSO_NOMBRE
FROM
	ESTUDIANTES AS ES
	JOIN INSCRIPCIONES AS INS ON INS.ESTUDIANTE_ID = ES.ESTUDIANTE_ID
	JOIN CURSOS AS CUR ON INS.CURSO_ID = CUR.CURSO_ID
WHERE
	ES.ESTUDIANTE_NOMBRE = 'Luis Ramírez';

--Contar el número de cursos en el sistema.
SELECT
	COUNT(*) AS "TOTAL CURSOS"
FROM
	CURSOS
	--Encontrar todos los estudiantes inscritos en un curso específico
SELECT
	CURSOS.CURSO_NOMBRE,
	EST.ESTUDIANTE_NOMBRE
FROM
	CURSOS
	JOIN INSCRIPCIONES INS ON INS.CURSO_ID = CURSOS.CURSO_ID
	JOIN ESTUDIANTES EST ON EST.ESTUDIANTE_ID = INS.ESTUDIANTE_ID
WHERE
	CURSOS.CURSO_NOMBRE = 'Introducción a la Programación'