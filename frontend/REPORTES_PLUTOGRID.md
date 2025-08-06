# Sistema de Reportes con PlutoGrid - NutriPlan Frontend

Este documento describe la implementación del sistema de reportes en el frontend de NutriPlan utilizando PlutoGrid para la visualización de datos y funcionalidades de exportación a Excel y PDF.

## Características Implementadas

### 1. **Visualización de Datos con PlutoGrid**
- Tabla interactiva y responsiva para mostrar datos de facturas
- Columnas configurables con tipos de datos apropiados
- Ordenamiento y filtrado automático
- Interfaz moderna y profesional

### 2. **Tipos de Reportes Disponibles**
- **Reporte por Rango de Fechas**: Genera reportes de facturas dentro de un período específico
- **Reporte por Empleado**: Genera reportes de facturas para un empleado específico

### 3. **Funcionalidades de Exportación**
- **Exportación a Excel**: Genera archivos .xlsx con formato profesional
- **Exportación a PDF**: Genera archivos .pdf con tablas formateadas
- Nomenclatura automática de archivos con timestamp

## Archivos Creados/Modificados

### 1. **`lib/services/reportes_service.dart`**
Servicio para manejar las llamadas a los endpoints de reportes del backend.

**Funciones principales:**
- `obtenerReporteRangoFechas()`: Obtiene reportes por rango de fechas
- `obtenerReporteEmpleado()`: Obtiene reportes por empleado específico

### 2. **`lib/services/export_service.dart`**
Servicio para manejar las exportaciones a Excel y PDF.

**Funciones principales:**
- `exportarAExcel()`: Exporta datos a formato Excel (.xlsx)
- `exportarAPDF()`: Exporta datos a formato PDF
- `convertirDatosFacturas()`: Convierte datos de facturas al formato requerido
- `obtenerColumnas()`: Define las columnas para la tabla

### 3. **`lib/widgets/reports_widget.dart`**
Widget principal que implementa la interfaz de usuario para reportes.

**Características:**
- Selector de tipo de reporte
- Campos de fecha con date picker
- Campo de código de empleado
- Tabla PlutoGrid para visualización
- Botones de exportación
- Indicadores de carga y estado

## Dependencias Agregadas

```yaml
dependencies:
  # PlutoGrid for data tables
  pluto_grid: ^7.0.2
  
  # Excel export
  excel: ^2.1.0
  
  # PDF export
  pdf: ^3.10.7
  path_provider: ^2.1.2
  
  # File picker for saving files
  file_picker: ^6.1.1
  
  # Date picker
  intl: ^0.18.1
```

## Uso del Sistema de Reportes

### 1. **Generar Reporte por Rango de Fechas**
1. Seleccionar "Reporte por Rango de Fechas" en el dropdown
2. Seleccionar fecha de inicio y fin usando los date pickers
3. Hacer clic en "Generar Reporte"
4. Los datos se mostrarán en la tabla PlutoGrid
5. Usar los botones "Excel" o "PDF" para exportar

### 2. **Generar Reporte por Empleado**
1. Seleccionar "Reporte por Empleado" en el dropdown
2. Ingresar el código del empleado
3. Opcionalmente seleccionar fechas de inicio y fin
4. Hacer clic en "Generar Reporte"
5. Los datos se mostrarán en la tabla PlutoGrid
6. Usar los botones "Excel" o "PDF" para exportar

### 3. **Exportar Datos**
- **Excel**: Genera un archivo .xlsx con encabezados formateados y datos organizados
- **PDF**: Genera un archivo .pdf con tabla formateada, título y información adicional

## Estructura de Datos

### Columnas de la Tabla
1. Código Factura
2. Código Empleado
3. Nombres
4. Apellidos
5. Cédula
6. Correo
7. Fecha
8. Centro de Costo
9. Departamento
10. Labor
11. Cantidad
12. Descuento
13. Precio Empleado
14. Código Producto
15. Nombre Producto

### Formato de Exportación
Los datos se exportan manteniendo la estructura original de la base de datos, con las siguientes características:

**Excel:**
- Encabezados con formato profesional
- Ancho de columnas optimizado
- Datos organizados en filas y columnas

**PDF:**
- Título del reporte
- Tabla con bordes y formato
- Información adicional (total de registros, fecha de generación)
- Orientación horizontal para mejor visualización

## Integración con Backend

### Endpoints Utilizados
- `GET /api/reportes-facturas/rango-fechas`: Para reportes por rango de fechas
- `GET /api/reportes-facturas/empleado/:codigo`: Para reportes por empleado

### Parámetros de Consulta
- `fechaInicio`: Fecha de inicio (YYYY-MM-DD)
- `fechaFin`: Fecha de fin (YYYY-MM-DD)
- `formato`: Formato de respuesta (json, excel, resumen, csv)

## Características Técnicas

### PlutoGrid Configuration
```dart
PlutoGridConfiguration(
  columnSize: PlutoGridColumnSizeConfig(
    autoSizeMode: PlutoAutoSizeMode.scale,
  ),
  style: PlutoGridStyleConfig(
    gridBorderColor: Colors.grey,
    gridBackgroundColor: Colors.white,
    rowHeight: 50,
  ),
)
```

### Manejo de Estados
- Indicador de carga durante la generación de reportes
- Mensajes de éxito y error con SnackBar
- Validación de campos requeridos
- Manejo de errores de conexión

### Responsive Design
- La tabla se adapta al tamaño de la pantalla
- Columnas con ancho configurable
- Interfaz optimizada para diferentes dispositivos

## Ventajas de la Implementación

1. **Interfaz Moderna**: PlutoGrid proporciona una experiencia de usuario profesional
2. **Funcionalidad Completa**: Visualización, filtrado, ordenamiento y exportación
3. **Flexibilidad**: Múltiples formatos de exportación
4. **Escalabilidad**: Fácil agregar nuevos tipos de reportes
5. **Mantenibilidad**: Código modular y bien estructurado

## Próximas Mejoras Sugeridas

1. **Filtros Avanzados**: Agregar filtros por departamento, centro de costo, etc.
2. **Gráficos**: Integrar gráficos para análisis visual de datos
3. **Reportes Programados**: Permitir programar reportes automáticos
4. **Plantillas**: Crear plantillas personalizables para exportación
5. **Compartir**: Funcionalidad para compartir reportes por email

## Notas de Instalación

Para que el sistema funcione correctamente, asegúrate de:

1. Tener todas las dependencias instaladas (`flutter pub get`)
2. Que el backend esté ejecutándose en `http://localhost:3000`
3. Que la base de datos tenga datos de prueba para los reportes
4. Tener permisos de escritura para guardar archivos exportados

## Solución de Problemas

### Error de Dependencias
Si hay conflictos de versiones, actualiza las dependencias según las recomendaciones de Flutter.

### Error de Conexión
Verifica que el backend esté ejecutándose y accesible desde el frontend.

### Error de Exportación
Asegúrate de tener permisos de escritura en el directorio de descargas.

### Datos Vacíos
Verifica que existan datos en la base de datos para el rango de fechas o empleado especificado. 