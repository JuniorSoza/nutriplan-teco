# Guía de Uso - Sistema de Reportes NutriPlan

Esta guía te ayudará a usar el sistema de reportes implementado con PlutoGrid en el frontend de NutriPlan.

## 🚀 Configuración Inicial

### 1. **Preparar la Base de Datos**
Antes de usar los reportes, asegúrate de tener datos de prueba en la base de datos:

```sql
-- Ejecutar el archivo de datos de prueba
source backend/datos_prueba_reportes.sql
```

### 2. **Verificar el Backend**
Asegúrate de que el backend esté ejecutándose:

```bash
cd backend
npm start
```

El servidor debe estar corriendo en `http://localhost:3000`

### 3. **Verificar el Frontend**
Asegúrate de que el frontend esté compilado:

```bash
cd frontend
flutter pub get
flutter run
```

## 📊 Cómo Usar el Sistema de Reportes

### **Paso 1: Acceder a los Reportes**
1. Abre la aplicación NutriPlan
2. En el menú lateral, haz clic en **"Generar Reportes"**
3. Se abrirá la interfaz de reportes con PlutoGrid

### **Paso 2: Generar Reporte por Rango de Fechas**

#### Opción A: Reporte por Rango de Fechas
1. En el dropdown "Tipo de Reporte", selecciona **"Reporte por Rango de Fechas"**
2. Haz clic en el campo "Fecha de Inicio" y selecciona una fecha
3. Haz clic en el campo "Fecha de Fin" y selecciona una fecha
4. Haz clic en **"Generar Reporte"**
5. Los datos aparecerán en la tabla PlutoGrid

#### Opción B: Reporte por Empleado
1. En el dropdown "Tipo de Reporte", selecciona **"Reporte por Empleado"**
2. En el campo "Código de Empleado", ingresa un código (ej: `123456`)
3. Opcionalmente, selecciona fechas de inicio y fin
4. Haz clic en **"Generar Reporte"**
5. Los datos del empleado aparecerán en la tabla

### **Paso 3: Exportar los Datos**

Una vez que tengas datos en la tabla, puedes exportarlos:

#### Exportar a Excel
1. Haz clic en el botón **"Excel"** (verde)
2. Se abrirá un diálogo para guardar el archivo
3. Elige la ubicación y guarda el archivo `.xlsx`

#### Exportar a PDF
1. Haz clic en el botón **"PDF"** (rojo)
2. Se abrirá un diálogo para guardar el archivo
3. Elige la ubicación y guarda el archivo `.pdf`

## 📋 Datos de Prueba Disponibles

### **Empleados de Prueba**
- **Código 123456**: LUCAS SANTANA GENESIS MISHELLE (tiene facturas en los últimos 7 días)
- **Código 234567**: MARIA GONZALEZ JOSE LUIS
- **Código 345678**: CARLOS RODRIGUEZ ANA LUCIA
- Y otros códigos: 456789, 567890, 678901, etc.

### **Productos Disponibles**
- **Código 1**: Desayuno ($1.65)
- **Código 2**: Almuerzo ($2.50)
- **Código 3**: Merienda ($1.25)
- **Código 4**: Refrigerio ($0.85)
- **Código 5**: Extras ($3.00)

### **Rangos de Fechas Recomendados**
- **Últimos 7 días**: Para ver datos recientes
- **Últimos 30 días**: Para un reporte más amplio
- **Rango específico**: Para análisis de períodos específicos

## 🔍 Características de la Tabla PlutoGrid

### **Funcionalidades Disponibles**
- **Ordenamiento**: Haz clic en los encabezados de columna para ordenar
- **Filtrado**: Usa los filtros en la parte superior de la tabla
- **Búsqueda**: Busca datos específicos en las columnas
- **Redimensionamiento**: Ajusta el ancho de las columnas arrastrando

### **Columnas Disponibles**
1. **Código Factura**: Identificador único de la factura
2. **Código Empleado**: Código del empleado
3. **Nombres**: Nombres del empleado
4. **Apellidos**: Apellidos del empleado
5. **Cédula**: Número de cédula
6. **Correo**: Correo electrónico
7. **Fecha**: Fecha y hora de la factura
8. **Centro de Costo**: Centro de costo del empleado
9. **Departamento**: Departamento del empleado
10. **Labor**: Cargo o labor del empleado
11. **Cantidad**: Cantidad de productos
12. **Descuento**: Descuento aplicado
13. **Precio Empleado**: Precio pagado por el empleado
14. **Código Producto**: Código del producto
15. **Nombre Producto**: Nombre del producto

## 📤 Formatos de Exportación

### **Excel (.xlsx)**
- Encabezados formateados profesionalmente
- Datos organizados en filas y columnas
- Ancho de columnas optimizado
- Compatible con Microsoft Excel y Google Sheets

### **PDF**
- Título del reporte incluido
- Tabla con bordes y formato profesional
- Información adicional (total de registros, fecha de generación)
- Orientación horizontal para mejor visualización

## 🛠️ Solución de Problemas

### **Problema: No aparecen datos**
**Solución:**
1. Verifica que el backend esté ejecutándose
2. Asegúrate de que la base de datos tenga datos
3. Ejecuta el script de datos de prueba
4. Verifica la conexión a la base de datos

### **Problema: Error al generar reporte**
**Solución:**
1. Verifica que las fechas sean válidas
2. Asegúrate de que el código de empleado exista
3. Revisa los logs del backend para errores específicos

### **Problema: Error al exportar**
**Solución:**
1. Asegúrate de tener permisos de escritura
2. Verifica que haya datos en la tabla
3. Cierra otros archivos Excel/PDF que puedan estar abiertos

### **Problema: La tabla no se muestra**
**Solución:**
1. Verifica que las dependencias estén instaladas (`flutter pub get`)
2. Reinicia la aplicación Flutter
3. Verifica que no haya errores de compilación

## 📱 Compatibilidad

### **Dispositivos Soportados**
- ✅ **Desktop**: Windows, macOS, Linux
- ✅ **Web**: Navegadores modernos
- ⚠️ **Móvil**: Funcional pero optimizado para pantallas grandes

### **Navegadores Web**
- ✅ Chrome (recomendado)
- ✅ Firefox
- ✅ Safari
- ✅ Edge

## 🔧 Configuración Avanzada

### **Personalizar Columnas**
Para modificar las columnas mostradas, edita el archivo:
```
frontend/lib/widgets/reports_widget.dart
```

Busca la función `_getColumns()` y modifica las columnas según tus necesidades.

### **Personalizar Exportación**
Para modificar el formato de exportación, edita:
```
frontend/lib/services/export_service.dart
```

### **Agregar Nuevos Tipos de Reporte**
Para agregar nuevos tipos de reporte:
1. Modifica el dropdown en `reports_widget.dart`
2. Agrega la lógica en `_generarReporte()`
3. Crea el endpoint correspondiente en el backend

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs del backend y frontend
2. Verifica la documentación técnica
3. Asegúrate de que todas las dependencias estén actualizadas

---

**¡El sistema de reportes está listo para usar!** 🎉 