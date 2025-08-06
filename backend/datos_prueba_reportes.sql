-- Datos de prueba para el sistema de reportes
-- Insertar productos de prueba
INSERT INTO producto (prd_codigo, prd_nombre, prd_precio, prd_estado) VALUES
(1, 'Desayuno', 1.65, 'A'),
(2, 'Almuerzo', 2.50, 'A'),
(3, 'Merienda', 1.25, 'A'),
(4, 'Refrigerio', 0.85, 'A'),
(5, 'Extras', 3.00, 'A');

-- Insertar facturas de prueba para diferentes fechas
INSERT INTO factura_cabecera (
    fac_cab_codigo, emp_codigo, emp_nombres, emp_apellidos, emp_cedula, emp_correo,
    fac_cab_fecha, emp_centro_costo, emp_departamento, emp_labor,
    fac_cab_cantidad, fac_cab_descuento, fac_cab_precio_empleado, producto_prd_codigo
) VALUES
-- Facturas para el día de hoy
(1, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', NOW(), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 1.65, 1),
(2, '234567', 'MARIA GONZALEZ', 'JOSE LUIS', '2345678901', 'maria@example.com', NOW(), 'CC002', 'ADMINISTRACION', 'AUXILIAR', 1, 0.00, 2.50, 2),
(3, '345678', 'CARLOS RODRIGUEZ', 'ANA LUCIA', '3456789012', 'carlos@example.com', NOW(), 'CC001', 'PRODUCCION', 'SUPERVISOR', 1, 0.00, 1.25, 3),

-- Facturas para ayer
(4, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 1 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 2.50, 2),
(5, '456789', 'PEDRO MARTINEZ', 'SOFIA ELENA', '4567890123', 'pedro@example.com', DATE_SUB(NOW(), INTERVAL 1 DAY), 'CC003', 'LOGISTICA', 'CONDUCTOR', 1, 0.00, 1.65, 1),
(6, '567890', 'ANA LOPEZ', 'JUAN CARLOS', '5678901234', 'ana@example.com', DATE_SUB(NOW(), INTERVAL 1 DAY), 'CC002', 'ADMINISTRACION', 'SECRETARIA', 1, 0.00, 0.85, 4),

-- Facturas para hace 2 días
(7, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 2 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 3.00, 5),
(8, '678901', 'ROSA HERRERA', 'MIGUEL ANGEL', '6789012345', 'rosa@example.com', DATE_SUB(NOW(), INTERVAL 2 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 1.25, 3),
(9, '789012', 'JORGE DIAZ', 'CARMEN ROSA', '7890123456', 'jorge@example.com', DATE_SUB(NOW(), INTERVAL 2 DAY), 'CC003', 'LOGISTICA', 'AUXILIAR', 1, 0.00, 2.50, 2),

-- Facturas para hace 3 días
(10, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 3 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 1.65, 1),
(11, '890123', 'SANDRA MORALES', 'ROBERTO JOSE', '8901234567', 'sandra@example.com', DATE_SUB(NOW(), INTERVAL 3 DAY), 'CC002', 'ADMINISTRACION', 'CONTADOR', 1, 0.00, 2.50, 2),
(12, '901234', 'FERNANDO CASTRO', 'ELENA MARIA', '9012345678', 'fernando@example.com', DATE_SUB(NOW(), INTERVAL 3 DAY), 'CC001', 'PRODUCCION', 'SUPERVISOR', 1, 0.00, 0.85, 4),

-- Facturas para hace 4 días
(13, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 4 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 3.00, 5),
(14, '012345', 'DIANA RUIZ', 'ANTONIO MANUEL', '0123456789', 'diana@example.com', DATE_SUB(NOW(), INTERVAL 4 DAY), 'CC003', 'LOGISTICA', 'CONDUCTOR', 1, 0.00, 1.25, 3),
(15, '111111', 'LUIS VARGAS', 'PATRICIA ANA', '1111111111', 'luis@example.com', DATE_SUB(NOW(), INTERVAL 4 DAY), 'CC002', 'ADMINISTRACION', 'AUXILIAR', 1, 0.00, 1.65, 1),

-- Facturas para hace 5 días
(16, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 5 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 2.50, 2),
(17, '222222', 'GLORIA MENDOZA', 'FRANCISCO JOSE', '2222222222', 'gloria@example.com', DATE_SUB(NOW(), INTERVAL 5 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 0.85, 4),
(18, '333333', 'HECTOR SILVA', 'ISABEL CARMEN', '3333333333', 'hector@example.com', DATE_SUB(NOW(), INTERVAL 5 DAY), 'CC003', 'LOGISTICA', 'AUXILIAR', 1, 0.00, 3.00, 5),

-- Facturas para hace 6 días
(19, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 6 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 1.25, 3),
(20, '444444', 'NELSON TORRES', 'MARGARITA LUZ', '4444444444', 'nelson@example.com', DATE_SUB(NOW(), INTERVAL 6 DAY), 'CC002', 'ADMINISTRACION', 'SECRETARIA', 1, 0.00, 1.65, 1),
(21, '555555', 'CLAUDIA NAVARRO', 'EDUARDO LUIS', '5555555555', 'claudia@example.com', DATE_SUB(NOW(), INTERVAL 6 DAY), 'CC001', 'PRODUCCION', 'SUPERVISOR', 1, 0.00, 2.50, 2),

-- Facturas para hace 7 días
(22, '123456', 'LUCAS SANTANA', 'GENESIS MISHELLE', '1234567890', 'lucas@example.com', DATE_SUB(NOW(), INTERVAL 7 DAY), 'CC001', 'PRODUCCION', 'OPERADOR', 1, 0.00, 0.85, 4),
(23, '666666', 'RICARDO JIMENEZ', 'ADRIANA SOFIA', '6666666666', 'ricardo@example.com', DATE_SUB(NOW(), INTERVAL 7 DAY), 'CC003', 'LOGISTICA', 'CONDUCTOR', 1, 0.00, 3.00, 5),
(24, '777777', 'MONICA PEREZ', 'GABRIEL ANTONIO', '7777777777', 'monica@example.com', DATE_SUB(NOW(), INTERVAL 7 DAY), 'CC002', 'ADMINISTRACION', 'CONTADOR', 1, 0.00, 1.25, 3);

-- Verificar que los datos se insertaron correctamente
SELECT 'Datos de prueba insertados correctamente' as mensaje;
SELECT COUNT(*) as total_facturas FROM factura_cabecera;
SELECT COUNT(*) as total_productos FROM producto; 