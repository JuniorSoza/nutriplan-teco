-- Insert de prueba para la tabla PRODUCTO
-- Valores: desayuno, almuerzo, merienda, refrigerio, extras

USE teco_new;

INSERT INTO producto (prd_codigo, prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion) VALUES
(1, 'Producto de desayuno', '/images/desayuno.jpg', 'desayuno', 'Cafetería'),
(2, 'Producto de almuerzo', '/images/almuerzo.jpg', 'almuerzo', 'Comedor'),
(3, 'Producto de merienda', '/images/merienda.jpg', 'merienda', 'Cafetería'),
(4, 'Producto de refrigerio', '/images/refrigerio.jpg', 'refrigerio', 'Máquina'),
(5, 'Producto extra', '/images/extras.jpg', 'extras', 'Snack Bar');

-- Verificar el insert
SELECT * FROM producto; 