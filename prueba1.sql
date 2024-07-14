CREATE TABLE productos(
	nombre VARCHAR(50) NOT NULL,
	descripcion TEXT,
	precio FLOAT NOT NULL,
	cantidad INT,
	id_producto SERIAL PRIMARY KEY,
	id_usuario int,
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

INSERT INTO productos(nombre, precio, cantidad, id_usuario)
	VALUES(
	'Piano',
	45.50,
	1,
	3
	);

DELETE FROM productos
	WHERE id_producto = 2;

SELECT * FROM productos;