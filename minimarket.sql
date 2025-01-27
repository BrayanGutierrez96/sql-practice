--Tienes que gestionar una base de datos para un sistema de ventas en línea. La base de datos debe contener información sobre clientes, productos, órdenes y detalles de las órdenes. Cada orden puede contener varios productos y un producto puede estar en varias órdenes.
--Crea las tablas necesarias para almacenar la información sobre los clientes, los productos, las órdenes y los detalles de las órdenes.
--Inserta algunos datos de ejemplo en las tablas.
--Escribe consultas para:
--Obtener una lista de todas las órdenes con los detalles de los productos y los clientes.
--Encontrar todas las órdenes realizadas por un cliente específico.
--Contar el número de productos en una orden específica.
--Calcular el total de una orden específica (precio total de los productos en la orden).
--Encontrar los productos más vendidos (productos que aparecen en el mayor número de órdenes).
DROP TABLE IF EXISTS DETALLE_ORDEN;

DROP TABLE IF EXISTS ORDENES;

DROP TABLE IF EXISTS PRODUCTOS;

DROP TABLE IF EXISTS CLIENTES;

CREATE TABLE CLIENTES (
	CLIENTE_ID SERIAL PRIMARY KEY,
	CLIENTE_NOMBRE VARCHAR(50) DEFAULT 'CONSUMIDOR',
	CLIENTE_CC INT DEFAULT 22222,
	CLIENTE_CORREO VARCHAR(50)
);

CREATE TABLE PRODUCTOS (
	PRODUCTO_ID SERIAL PRIMARY KEY,
	PRODUCTO_NOMBRE VARCHAR(50) NOT NULL,
	PRODUCTO_PRECIO NUMERIC CHECK (PRODUCTO_PRECIO > 0),
	PRODUCTO_CANTIDAD SMALLINT CHECK (PRODUCTO_CANTIDAD > 0)
);

CREATE TABLE ORDENES (
	ORDEN_ID SERIAL PRIMARY KEY,
	CLIENTE_ID INT REFERENCES CLIENTES (CLIENTE_ID),
	ORDEN_FECHA DATE DEFAULT NOW()
);

CREATE TABLE DETALLE_ORDEN (
	DETALLE_ORDEN SERIAL PRIMARY KEY,
	ORDEN_ID INT REFERENCES ORDENES (ORDEN_ID),
	PRODUCTO_ID INT REFERENCES PRODUCTOS (PRODUCTO_ID),
	DETALLE_ORDEN_CANTIDAD INT NOT NULL
);

INSERT INTO
	CLIENTES (CLIENTE_NOMBRE, CLIENTE_CORREO)
VALUES
	--	('Juan Pérez', 'juan.perez@example.com',10253478 ),
	--	('María Gómez', 'maria.gomez@example.com', 1017246957),--
	--	('Carlos López', 'carlos.lopez@example.com',706994580);--
	('Ana Torres', 'ana.torres@example.com'),
	('Luis Ramírez', 'luis.ramirez@example.com');

SELECT
	*
FROM
	CLIENTES;

INSERT INTO
	PRODUCTOS (
		PRODUCTO_NOMBRE,
		PRODUCTO_PRECIO,
		PRODUCTO_CANTIDAD
	)
VALUES
	('Laptop', 800.00, 5),
	('Smartphone', 500.00, 15),
	('Tablet', 300.00, 3),
	('Monitor', 150.00, 24),
	('Teclado', 50.00, 50);

SELECT
	*
FROM
	PRODUCTOS
ORDER BY
	PRODUCTO_CANTIDAD DESC;

INSERT INTO
	ORDENES (CLIENTE_ID, ORDEN_FECHA)
VALUES
	(1, '2023-01-10'),
	(2, '2023-01-15'),
	(3, '2023-02-20'),
	(4, '2023-03-10'),
	(5, '2023-04-05');

SELECT
	*
FROM
	ORDENES;

INSERT INTO
	DETALLE_ORDEN (ORDEN_ID, PRODUCTO_ID, DETALLE_ORDEN_CANTIDAD)
VALUES
	(1, 1, 1),
	(1, 2, 2),
	(2, 3, 1),
	(2, 4, 2),
	(3, 1, 1),
	(3, 5, 3),
	(4, 2, 1),
	(5, 3, 1),
	(5, 4, 1);

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 1;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 2
WHERE
	PRODUCTO_ID = 2;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 3;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 1;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 3
WHERE
	PRODUCTO_ID = 5;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 2;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 3;

UPDATE PRODUCTOS
SET
	PRODUCTO_CANTIDAD = PRODUCTO_CANTIDAD - 1
WHERE
	PRODUCTO_ID = 4;

SELECT
	*
FROM
	DETALLE_ORDEN
	--Obtener una lista de todas las órdenes con los detalles de los productos y los clientes.
SELECT
	CLI.CLIENTE_NOMBRE AS "NOMBRE DEL CLIENTE",
	PRO.PRODUCTO_NOMBRE AS "PRODUCTO",
	DEO.DETALLE_ORDEN_CANTIDAD AS "CANTIDAD",
	PRO.PRODUCTO_PRECIO AS PRECIO,
	PRO.PRODUCTO_PRECIO * DEO.DETALLE_ORDEN_CANTIDAD AS "TOTAL"
FROM
	ORDENES ORD
	JOIN CLIENTES AS CLI ON ORD.CLIENTE_ID = CLI.CLIENTE_ID
	JOIN DETALLE_ORDEN AS DEO ON ORD.ORDEN_ID = DEO.ORDEN_ID
	JOIN PRODUCTOS AS PRO ON DEO.PRODUCTO_ID = PRO.PRODUCTO_ID;

--Encontrar todas las órdenes realizadas por un cliente específico.
SELECT
	CLI.CLIENTE_ID AS ID,
	PRO.PRODUCTO_NOMBRE AS PRODUCTO,
	DEO.DETALLE_ORDEN_CANTIDAD AS CANTIDAD,
	PRO.PRODUCTO_PRECIO AS PRECIO,
	PRO.PRODUCTO_PRECIO * DEO.DETALLE_ORDEN_CANTIDAD AS TOTAL
FROM
	ORDENES ORD
	JOIN CLIENTES CLI ON ORD.CLIENTE_ID = CLI.CLIENTE_ID
	JOIN DETALLE_ORDEN DEO ON ORD.ORDEN_ID = DEO.ORDEN_ID
	JOIN PRODUCTOS PRO ON DEO.PRODUCTO_ID = PRO.PRODUCTO_ID
WHERE
	CLI.CLIENTE_NOMBRE LIKE 'Juan%';

--Contar el número de productos en una orden específica.
SELECT
	COUNT(*) AS TOTAL
FROM
	DETALLE_ORDEN
WHERE
	ORDEN_ID = 4;

--Calcular el total de una orden específica (precio total de los productos en la orden).
SELECT
	SUM(DEO.DETALLE_ORDEN_CANTIDAD * PRO.PRODUCTO_PRECIO) AS "TOTAL"
FROM
	ORDENES ORD
	JOIN CLIENTES CLI ON ORD.CLIENTE_ID = CLI.CLIENTE_ID
	JOIN DETALLE_ORDEN DEO ON ORD.ORDEN_ID = DEO.ORDEN_ID
	JOIN PRODUCTOS PRO ON DEO.PRODUCTO_ID = PRO.PRODUCTO_ID
WHERE
	ORD.ORDEN_ID = 2;

--Encontrar los productos más vendidos (productos que aparecen en el mayor número de órdenes).
SELECT
	ORD.ORDEN_ID AS "ORDEN ID",
	PRO.PRODUCTO_NOMBRE AS "PRODUCTO",
	DEO.DETALLE_ORDEN_CANTIDAD AS "CANTIDAD VENDIDA"
FROM
	ORDENES ORD
	JOIN CLIENTES CLI ON ORD.CLIENTE_ID = CLI.CLIENTE_ID
	JOIN DETALLE_ORDEN DEO ON ORD.ORDEN_ID = DEO.ORDEN_ID
	JOIN PRODUCTOS PRO ON DEO.PRODUCTO_ID = PRO.PRODUCTO_ID
ORDER BY
	DEO.DETALLE_ORDEN_CANTIDAD DESC
LIMIT
	3;