--base de datos
CREATE DATABASE teco_new;
USE teco_new;


-- Tabla: NOTIFICACION
CREATE TABLE notificacion (
    id BIGINT PRIMARY KEY,
    mensaje VARCHAR(255)
);

-- Tabla: BIOMETRICO
CREATE TABLE biometrico (
    bio_tarjeta VARCHAR(255) PRIMARY KEY,
    bio_huella VARCHAR(255)
);


-- Tabla: PRODUCTO
CREATE TABLE producto (
    prd_codigo INT PRIMARY KEY,
    prd_descripcion VARCHAR(255),
    prd_imagen VARCHAR(255),
    prd_nombre VARCHAR(255),    
    prd_ubicacion VARCHAR(255)
);

-- Tabla: FACTURA CABECERA
CREATE TABLE factura_cabecera (
    fac_cab_codigo INT,
    emp_codigo VARCHAR(255),
    emp_apellidos VARCHAR(255),
    emp_cedula VARCHAR(255),
    emp_correo VARCHAR(255),
    emp_nombres VARCHAR(255),
    fac_cab_fecha DATETIME(6),    
    emp_centro_costo VARCHAR(255),
    emp_departamento VARCHAR(255),
    emp_labor VARCHAR(255),
    fac_cab_cantidad INT NOT NULL,
    fac_cab_descuento DOUBLE DEFAULT 0,    
    fac_cab_precio_empleado DOUBLE,
    producto_prd_codigo INT, 
    FOREIGN KEY (producto_prd_codigo) REFERENCES producto(prd_codigo),
    INDEX (producto_prd_codigo)
);


-- Tabla: REPORTE
CREATE TABLE reporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_codigo VARCHAR(255),
    empleado VARCHAR(255),
    fecha DATETIME(6),
    tipo VARCHAR(255),
    factura INT,
    cantidad INT,
    centro_costo VARCHAR(255),
    departamento VARCHAR(255),
    descuento DOUBLE,
    labor VARCHAR(255),
    nombres VARCHAR(255),
    precio_empleado DOUBLE,
    codigo VARCHAR(255)
);
