# Integración con Backend - Guardado de Facturas

## 📋 Descripción

El sistema frontend ahora está integrado con el backend para guardar registros de facturas en tiempo real. Cuando el usuario presiona "Guardar Registro", los datos se envían al endpoint `/api/facturas` del backend.

## 🔗 Endpoint Utilizado

**URL del Backend:**
```
http://localhost:3000/api/facturas
```

**Método:** `POST`

**Headers:**
```
Content-Type: application/json
Accept: application/json
```

## 📊 Estructura de Datos Enviados

### Datos de la Factura
```json
{
  "fac_cab_codigo": 1705312200000,
  "emp_codigo": "000006",
  "emp_apellidos": "ANCHUNDIA ANCHUNDIA",
  "emp_cedula": "1311779688",
  "emp_correo": "fannyanchundia1986@hotmail.com",
  "emp_nombres": "FANNY VICENTA",
  "fac_cab_fecha": "2024-01-15T10:30:00.000Z",
  "emp_centro_costo": "LIMPIEZA",
  "emp_departamento": "Producción",
  "emp_labor": "O",
  "fac_cab_cantidad": 1,
  "fac_cab_descuento": 0,
  "fac_cab_precio_empleado": 1,
  "producto_prd_codigo": 1,
  "producto_nombre": "DESAYUNO"
}
```

## 🚀 Flujo de Guardado

### 1. Validaciones Previas
- ✅ Todos los campos obligatorios completos
- ✅ Código de empleado con exactamente 6 dígitos
- ✅ Empleado encontrado en el sistema
- ✅ Cantidad válida (número mayor a 0)

### 2. Preparación de Datos
- Se recopilan todos los datos del formulario
- Se incluyen los datos completos del empleado
- Se agrega timestamp de registro
- Se valida formato de datos

### 3. Envío al Backend
- Se envía petición POST al endpoint
- Se incluyen headers apropiados
- Se maneja timeout y errores de red

### 4. Respuesta y Feedback
- **Éxito (200/201)**: Mensaje verde de confirmación
- **Error**: Mensaje rojo con detalles del error
- **Limpieza**: Formulario se resetea automáticamente

## 🔧 Implementación Técnica

### Archivos Modificados

#### `lib/services/api_service.dart`
```dart
// Crear factura
static Future<Map<String, dynamic>> crearFactura(
  Map<String, dynamic> factura,
) async {
  // Envía datos al endpoint /api/facturas
  // Maneja respuestas y errores
}

// Obtener últimas facturas
static Future<List<Map<String, dynamic>>> getUltimasFacturas() async {
  // Obtiene las últimas 3 facturas ordenadas por fecha
}

// Eliminar factura
static Future<bool> eliminarFactura(String facturaId) async {
  // Elimina factura por ID usando DELETE /api/facturas/{id}
}
```

#### `lib/screens/home_screen.dart`
```dart
// Guardar registro
Future<void> _guardarRegistro() async {
  // Validaciones
  // Preparación de datos
  // Envío al backend
  // Manejo de respuesta
  // Recarga últimas facturas
}

// Cargar últimas facturas
Future<void> _cargarUltimasFacturas() async {
  // Carga y muestra las últimas 3 facturas
}

// Eliminar factura
Future<void> _eliminarFactura(String facturaId) async {
  // Confirmación y eliminación de factura
}
```

### Variables de Estado
```dart
bool _isLoadingEmpleado = false; // Controla indicador de carga
```

## 🎯 Casos de Uso

### Caso 1: Guardado Exitoso
```
Usuario: Completa formulario → Presiona "Guardar Registro"
Sistema: Valida datos → Envía al backend → Muestra confirmación → Actualiza lista
Resultado: ✅ "Registro guardado exitosamente: Desayuno" + Lista actualizada
```

### Caso 2: Error de Validación
```
Usuario: Formulario incompleto → Presiona "Guardar Registro"
Sistema: Detecta campos vacíos
Resultado: ⚠️ "Por favor completa todos los campos"
```

### Caso 3: Error de Conexión
```
Usuario: Sin internet → Presiona "Guardar Registro"
Sistema: Intenta conectar → Falla
Resultado: ❌ "Error al guardar registro: Error de conexión"
```

### Caso 4: Eliminación de Factura
```
Usuario: Presiona botón eliminar → Confirma eliminación
Sistema: Envía DELETE al backend → Actualiza lista
Resultado: ✅ "Factura eliminada exitosamente" + Lista actualizada
```

### Caso 5: Visualización de Últimos Registros
```
Usuario: Abre sección "Productos"
Sistema: Carga automáticamente las últimas 3 facturas
Resultado: Lista de registros recientes con opciones de eliminación
```

## 📱 Experiencia de Usuario

### Indicadores Visuales
- **Botón normal**: "Guardar Registro"
- **Guardando**: "Guardando..." + Spinner
- **Deshabilitado**: Durante el proceso de guardado
- **Lista de facturas**: Carga automática con indicador de progreso
- **Botón eliminar**: Icono de papelera roja en cada factura

### Mensajes de Feedback
- **Verde**: Éxito en el guardado/eliminación
- **Naranja**: Errores de validación
- **Rojo**: Errores de conexión o servidor

### Limpieza Automática
- Formulario se resetea después del guardado exitoso
- Campos se limpian automáticamente
- Estado del empleado se resetea
- Lista de facturas se actualiza automáticamente

### Funcionalidades Adicionales
- **Confirmación de eliminación**: Dialog de confirmación antes de eliminar
- **Actualización manual**: Botón de refresh para recargar la lista
- **Información detallada**: Cada factura muestra empleado, producto, cantidad y fecha
- **Ordenamiento**: Las facturas se muestran ordenadas por fecha (más recientes primero)

## 🔍 Logging y Debugging

### Logs del Frontend
```
📋 Datos de factura a enviar: {codigo_empleado: 000006, ...}
📤 Enviando factura al backend: {"codigo_empleado":"000006",...}
📡 Status Code: 201
📡 Response Body: {"id": 123, "message": "Factura creada"}
✅ Factura creada exitosamente: {id: 123, message: Factura creada}
```

### Logs de Error
```
❌ Error HTTP: 500
❌ Error Body: {"error": "Error interno del servidor"}
❌ Error de conexión al crear factura: SocketException
```

## 🐛 Solución de Problemas

### Error 400 - Campos Requeridos
```dart
// El backend requiere estos campos específicos:
// - fac_cab_codigo: Código único de la factura (número)
// - emp_codigo: Código del empleado (6 dígitos)
// - emp_apellidos: Apellidos del empleado
// - emp_cedula: Cédula del empleado
// - emp_correo: Correo electrónico del empleado
// - emp_nombres: Nombres del empleado
// - fac_cab_fecha: Fecha de la factura (ISO string)
// - emp_centro_costo: Centro de costo del empleado
// - emp_departamento: Departamento del empleado
// - emp_labor: Labor del empleado
// - fac_cab_cantidad: Cantidad del producto
// - fac_cab_descuento: Descuento aplicado
// - fac_cab_precio_empleado: Precio para el empleado
// - producto_prd_codigo: Código del producto
// - producto_nombre: Nombre del producto
```

### Error 500 - Servidor
```dart
// Verificar que el backend esté corriendo
// Verificar estructura de datos enviados
// Revisar logs del backend
```

### Error de Conexión
```dart
// Verificar URL del backend
// Verificar conectividad de red
// Verificar firewall/proxy
```

### Error de Validación
```dart
// Verificar que todos los campos estén completos
// Verificar formato de datos
// Verificar que el empleado exista
```

## 📈 Próximas Mejoras

- [x] Historial de facturas enviadas (implementado)
- [x] Eliminación de facturas (implementado)
- [ ] Cache local de facturas enviadas
- [ ] Reintento automático en caso de error
- [ ] Sincronización offline
- [ ] Validación en tiempo real
- [ ] Confirmación antes de enviar

---

**Nota**: Esta integración permite un flujo completo desde la búsqueda de empleados hasta el guardado de facturas, proporcionando una experiencia de usuario fluida y feedback inmediato sobre el estado de las operaciones. 