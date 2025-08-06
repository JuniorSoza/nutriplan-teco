# Endpoints de Reportes de Facturas

Este documento describe los endpoints disponibles para generar reportes de facturas en el sistema NutriPlan.

## Base URL
```
http://localhost:3000/api/reportes-facturas
```

## Endpoints Disponibles

### 1. Reporte por Rango de Fechas

**Endpoint:** `GET /rango-fechas`

**Descripción:** Genera un reporte completo de facturas dentro de un rango de fechas específico.

**Parámetros de Query:**
- `fechaInicio` (requerido): Fecha de inicio en formato YYYY-MM-DD
- `fechaFin` (requerido): Fecha de fin en formato YYYY-MM-DD
- `formato` (opcional): Formato de respuesta
  - `json` (por defecto): Respuesta JSON completa
  - `excel`: Datos preparados para exportación a Excel
  - `resumen`: Solo resumen y estadísticas
  - `csv`: **Texto plano en formato CSV** (nuevo)

**Ejemplo de Request:**
```
GET /api/reportes-facturas/rango-fechas?fechaInicio=2025-05-19&fechaFin=2025-05-23&formato=csv
```

**Respuesta para formato JSON (por defecto):**
```json
{
  "success": true,
  "message": "Reporte generado exitosamente",
  "data": {
    "facturas": [
      {
        "fac_cab_codigo": 1,
        "emp_codigo": "123456",
        "emp_nombres": "LUCAS SANTANA",
        "emp_apellidos": "GENESIS MISHELLE",
        "emp_cedula": "1234567890",
        "emp_correo": "lucas@example.com",
        "fac_cab_fecha": "2025-05-19T10:30:00.000Z",
        "emp_centro_costo": "CC001",
        "emp_departamento": "PRODUCCION",
        "emp_labor": "OPERADOR",
        "fac_cab_cantidad": 1,
        "fac_cab_descuento": 0.00,
        "fac_cab_precio_empleado": 1.65,
        "producto_prd_codigo": 1,
        "producto_nombre": "Almuerzo"
      }
    ],
    "resumen": {
      "totalFacturas": 150,
      "totalCantidad": 150,
      "totalPrecio": 247.50,
      "totalDescuento": 0.00,
      "promedioPrecio": 1.65,
      "empleadosUnicos": 45,
      "productosUnicos": 5
    },
    "estadisticasPorDia": [
      {
        "fecha": "2025-05-19",
        "totalFacturas": 30,
        "totalCantidad": 30,
        "totalPrecio": 49.50
      }
    ],
    "estadisticasPorEmpleado": [
      {
        "emp_codigo": "123456",
        "emp_nombres": "LUCAS SANTANA",
        "emp_apellidos": "GENESIS MISHELLE",
        "totalFacturas": 5,
        "totalCantidad": 5,
        "totalPrecio": 8.25
      }
    ],
    "estadisticasPorProducto": [
      {
        "producto_prd_codigo": 1,
        "producto_nombre": "Almuerzo",
        "totalFacturas": 60,
        "totalCantidad": 60,
        "totalPrecio": 99.00
      }
    ]
  }
}
```

**Respuesta para formato CSV (texto plano):**
```
Content-Type: text/csv
Content-Disposition: attachment; filename="reporte_facturas_2025-05-19_2025-05-23.csv"

Código Factura,Código Empleado,Nombres,Apellidos,Cédula,Correo,Fecha,Centro de Costo,Departamento,Labor,Cantidad,Descuento,Precio Empleado,Código Producto,Nombre Producto
1,123456,"LUCAS SANTANA","GENESIS MISHELLE",1234567890,lucas@example.com,2025-05-19T10:30:00.000Z,CC001,PRODUCCION,OPERADOR,1,0.00,1.65,1,"Almuerzo"
2,123457,"MARIA JOSE","GONZALEZ LOPEZ",1234567891,maria@example.com,2025-05-19T11:15:00.000Z,CC002,ADMINISTRACION,ANALISTA,1,0.00,1.65,2,"Desayuno"
```

**Respuesta para formato Excel:**
```json
{
  "success": true,
  "message": "Datos preparados para exportación a Excel",
  "data": {
    "facturas": [
      {
        "fecha": "2025-05-19T10:30:00.000Z",
        "tipo": "Almuerzo",
        "empleado": "LUCAS SANTANA GENESIS MISHELLE",
        "codigo": "123456",
        "cantidad": 1,
        "precio": 1.65,
        "descuento": 0.00,
        "centro_costo": "CC001",
        "departamento": "PRODUCCION",
        "labor": "OPERADOR"
      }
    ],
    "resumen": { ... },
    "estadisticasPorDia": [ ... ],
    "estadisticasPorEmpleado": [ ... ],
    "estadisticasPorProducto": [ ... ]
  }
}
```

**Respuesta para formato Resumen:**
```json
{
  "success": true,
  "message": "Resumen del reporte generado exitosamente",
  "data": {
    "resumen": { ... },
    "estadisticasPorDia": [ ... ],
    "estadisticasPorEmpleado": [ ... ],
    "estadisticasPorProducto": [ ... ]
  }
}
```

### 2. Reporte por Empleado Específico

**Endpoint:** `GET /empleado/:codigo`

**Descripción:** Genera un reporte de todas las facturas de un empleado específico.

**Parámetros de Path:**
- `codigo` (requerido): Código del empleado

**Parámetros de Query:**
- `fechaInicio` (opcional): Fecha de inicio en formato YYYY-MM-DD
- `fechaFin` (opcional): Fecha de fin en formato YYYY-MM-DD

**Ejemplo de Request:**
```
GET /api/reportes-facturas/empleado/123456?fechaInicio=2025-05-19&fechaFin=2025-05-23
```

**Respuesta:**
```json
{
  "success": true,
  "message": "Reporte del empleado generado exitosamente",
  "data": {
    "empleado": {
      "codigo": "123456",
      "nombres": "LUCAS SANTANA",
      "apellidos": "GENESIS MISHELLE",
      "cedula": "1234567890",
      "correo": "lucas@example.com",
      "centro_costo": "CC001",
      "departamento": "PRODUCCION",
      "labor": "OPERADOR"
    },
    "facturas": [
      {
        "fac_cab_codigo": 1,
        "emp_codigo": "123456",
        "emp_nombres": "LUCAS SANTANA",
        "emp_apellidos": "GENESIS MISHELLE",
        "emp_cedula": "1234567890",
        "emp_correo": "lucas@example.com",
        "fac_cab_fecha": "2025-05-19T10:30:00.000Z",
        "emp_centro_costo": "CC001",
        "emp_departamento": "PRODUCCION",
        "emp_labor": "OPERADOR",
        "fac_cab_cantidad": 1,
        "fac_cab_descuento": 0.00,
        "fac_cab_precio_empleado": 1.65,
        "producto_prd_codigo": 1,
        "producto_nombre": "Almuerzo"
      }
    ],
    "resumen": {
      "totalFacturas": 5,
      "totalCantidad": 5,
      "totalPrecio": 8.25,
      "totalDescuento": 0.00,
      "promedioPrecio": 1.65
    }
  }
}
```

## Consultas SQL Utilizadas

### Consulta Principal de Facturas
```sql
SELECT 
    fc.fac_cab_codigo,
    fc.emp_codigo,
    fc.emp_nombres,
    fc.emp_apellidos,
    fc.emp_cedula,
    fc.emp_correo,
    fc.fac_cab_fecha,
    fc.emp_centro_costo,
    fc.emp_departamento,
    fc.emp_labor,
    fc.fac_cab_cantidad,
    fc.fac_cab_descuento,
    fc.fac_cab_precio_empleado,
    fc.producto_prd_codigo,
    p.prd_nombre as producto_nombre
FROM factura_cabecera fc
LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
WHERE DATE(fc.fac_cab_fecha) BETWEEN ? AND ?
ORDER BY fc.fac_cab_fecha ASC, fc.emp_nombres ASC
```

### Consulta de Resumen General
```sql
SELECT 
    COUNT(*) as totalFacturas,
    SUM(fac_cab_cantidad) as totalCantidad,
    SUM(fac_cab_precio_empleado) as totalPrecio,
    SUM(fac_cab_descuento) as totalDescuento,
    AVG(fac_cab_precio_empleado) as promedioPrecio,
    COUNT(DISTINCT emp_codigo) as empleadosUnicos,
    COUNT(DISTINCT producto_prd_codigo) as productosUnicos
FROM factura_cabecera
WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
```

### Consulta de Estadísticas por Día
```sql
SELECT 
    DATE(fac_cab_fecha) as fecha,
    COUNT(*) as totalFacturas,
    SUM(fac_cab_cantidad) as totalCantidad,
    SUM(fac_cab_precio_empleado) as totalPrecio
FROM factura_cabecera
WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
GROUP BY DATE(fac_cab_fecha)
ORDER BY fecha ASC
```

### Consulta de Estadísticas por Empleado
```sql
SELECT 
    emp_codigo,
    emp_nombres,
    emp_apellidos,
    COUNT(*) as totalFacturas,
    SUM(fac_cab_cantidad) as totalCantidad,
    SUM(fac_cab_precio_empleado) as totalPrecio
FROM factura_cabecera
WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
GROUP BY emp_codigo, emp_nombres, emp_apellidos
ORDER BY totalPrecio DESC
```

### Consulta de Estadísticas por Producto
```sql
SELECT 
    fc.producto_prd_codigo,
    p.prd_nombre as producto_nombre,
    COUNT(*) as totalFacturas,
    SUM(fc.fac_cab_cantidad) as totalCantidad,
    SUM(fc.fac_cab_precio_empleado) as totalPrecio
FROM factura_cabecera fc
LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
WHERE DATE(fc.fac_cab_fecha) BETWEEN ? AND ?
GROUP BY fc.producto_prd_codigo, p.prd_nombre
ORDER BY totalPrecio DESC
```

## Validaciones

### Validaciones de Fechas
- Las fechas de inicio y fin son requeridas
- Formato de fecha debe ser YYYY-MM-DD
- La fecha de inicio no puede ser mayor a la fecha de fin

### Validaciones de Empleado
- El código de empleado es requerido
- Se valida que existan facturas para el empleado especificado

## Códigos de Error

### 400 - Parámetros Inválidos
```json
{
  "success": false,
  "message": "Las fechas de inicio y fin son requeridas"
}
```

### 404 - Empleado No Encontrado
```json
{
  "success": false,
  "message": "No se encontraron facturas para este empleado"
}
```

### 500 - Error Interno del Servidor
```json
{
  "success": false,
  "message": "Error interno del servidor",
  "error": "Detalle del error"
}
```

## Integración con Swagger

Los endpoints están documentados en Swagger y disponibles en:
```
http://localhost:3000/api-docs
```

## Notas Importantes

### Formato CSV
- **NUEVO**: El formato `csv` devuelve texto plano en lugar de JSON
- Los datos se envían con `Content-Type: text/csv`
- Se incluye un header `Content-Disposition` para descarga automática
- Los campos de texto se envuelven en comillas dobles para evitar problemas con comas
- El archivo se nombra automáticamente con el rango de fechas

### Rendimiento
- Las consultas utilizan índices en las columnas de fecha y empleado
- Se implementa connection pooling para optimizar las conexiones a la base de datos
- Los resultados se ordenan para facilitar el procesamiento

### Seguridad
- Se validan todos los parámetros de entrada
- Se utilizan consultas preparadas para prevenir SQL injection
- Se manejan errores de manera segura sin exponer información sensible 