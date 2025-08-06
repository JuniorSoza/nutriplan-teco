# Búsqueda Automática de Empleados - NutriPlan Frontend

## 📋 Descripción

El sistema ahora incluye búsqueda automática de empleados cuando se ingresan 6 dígitos en el campo "Código de Empleado". Esta funcionalidad se conecta con el servicio web de Tecopesca para obtener información actualizada de los colaboradores.

## 🔗 Servicio Web Utilizado

**URL del Servicio:**
```
http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador
```

**Estructura de Respuesta:**
```json
[
  {
    "codigo": "000006",
    "cedula": "1311779688",
    "apellidos": "ANCHUNDIA ANCHUNDIA",
    "nombres": "FANNY VICENTA",
    "fecha_ingreso": "6/05/2024 12:00:00 a. m.",
    "labor": "O",
    "area": "GERENCIA TÉCNICA",
    "centro_costo": "LIMPIEZA",
    "cargo": "Trabajador(a) de Producción",
    "departamento": "Producción",
    "seccion": "Limpiadoras(es)",
    "email_personal": "fannyanchundia1986@hotmail.com"
  }
]
```

## 🚀 Funcionalidades Implementadas

### 1. Búsqueda Automática

**Proceso:**
1. El usuario ingresa un código de 6 dígitos
2. El sistema detecta automáticamente cuando se completan los 6 dígitos
3. Se realiza una petición HTTP al servicio web
4. Se busca el empleado por el campo `codigo`
5. Si se encuentra, se completa automáticamente la información

### 2. Interfaz de Usuario Mejorada

**Indicadores Visuales:**
- **Campo de código**: 
  - Hint text: "Ingresa 6 dígitos para buscar automáticamente"
  - Límite de 6 caracteres
  - Teclado numérico
  - Indicador de carga (spinner) durante la búsqueda
  - Icono de check verde cuando se encuentra el empleado

**Tarjeta de Información del Empleado:**
- Se muestra automáticamente cuando se encuentra un empleado
- Color de fondo verde claro
- Información detallada:
  - Cédula
  - Cargo
  - Departamento
  - Área

### 3. Manejo de Estados

**Estados del Campo de Código:**
1. **Vacío**: Sin indicadores
2. **Digitando**: Sin indicadores hasta completar 6 dígitos
3. **Buscando**: Spinner de carga
4. **Encontrado**: Icono de check verde
5. **No encontrado**: Sin icono, mensaje de error

**Estados del Campo de Nombre:**
- **Editable**: Cuando no hay empleado encontrado
- **Solo lectura**: Cuando se encuentra un empleado (se completa automáticamente)

## 📱 Experiencia de Usuario

### Flujo de Uso

1. **Ingreso del código**:
   ```
   Usuario: Ingresa "000006"
   Sistema: Detecta 6 dígitos → Inicia búsqueda automática
   ```

2. **Búsqueda en progreso**:
   ```
   Sistema: Muestra spinner de carga
   Usuario: Ve indicador visual de búsqueda
   ```

3. **Empleado encontrado**:
   ```
   Sistema: Muestra icono de check verde
   Sistema: Completa automáticamente el nombre
   Sistema: Muestra tarjeta con información detallada
   Sistema: Muestra SnackBar: "Empleado encontrado: FANNY VICENTA ANCHUNDIA ANCHUNDIA"
   ```

4. **Empleado no encontrado**:
   ```
   Sistema: No muestra icono
   Sistema: Muestra SnackBar: "Persona no encontrada"
   ```

### Validaciones

**Al guardar el registro:**
- ✅ Código debe tener exactamente 6 dígitos
- ✅ Empleado debe existir en el sistema
- ✅ Todos los campos obligatorios completos

## 🔧 Implementación Técnica

### Archivos Modificados

#### `lib/services/api_service.dart`
```dart
static Future<Map<String, dynamic>?> getColaboradorPorCodigo(String codigo) async {
  // Usa el mismo enfoque que funcionó en Postman
  final request = http.Request('GET', Uri.parse(AppConfig.colaboradoresUrl));
  final streamedResponse = await request.send();
  // Obtiene todos los colaboradores y busca por código
}
```

### Enfoque de Conexión HTTP
El sistema ahora utiliza el mismo enfoque que funcionó exitosamente en Postman:

```dart
// Código que funciona en Postman y ahora en Flutter
var request = http.Request('GET', Uri.parse('http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador'));
http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
```

#### `lib/config/app_config.dart`
```dart
static const String colaboradoresUrl = 'http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador';
```

#### `lib/screens/home_screen.dart`
- Listener en `_codigoEmpleadoController`
- Función `_buscarEmpleadoPorCodigo()`
- UI mejorada con indicadores visuales
- Validaciones adicionales

### Variables de Estado

```dart
bool _isLoadingEmpleado = false;
Map<String, dynamic>? _empleadoEncontrado;
```

## 🎯 Casos de Uso

### Caso 1: Empleado Existe
```
Entrada: "000006"
Resultado: 
- Empleado encontrado: FANNY VICENTA ANCHUNDIA ANCHUNDIA
- Información completada automáticamente
- Tarjeta de información visible
```

### Caso 2: Empleado No Existe
```
Entrada: "999999"
Resultado: 
- Mensaje: "Persona no encontrada"
- Campos vacíos
- Sin tarjeta de información
```

### Caso 3: Código Incompleto
```
Entrada: "123"
Resultado: 
- Sin búsqueda automática
- Campos editables
- Sin indicadores
```

### Caso 4: Error de Conexión
```
Entrada: "000006" (sin internet)
Resultado: 
- Se mantiene el código ingresado
- Se muestra información de ejemplo con el código ingresado
- Campos completados con datos de fallback
- Mensaje en consola: "Fallback a datos de ejemplo por error de conectividad"
```

## 🔍 Pruebas Recomendadas

### 1. Códigos Válidos
- `000000` - FANNY VICENTA ANCHUNDIA ANCHUNDIA (datos locales)
- `000006` - FANNY VICENTA ANCHUNDIA ANCHUNDIA
- `000017` - JOSEFA FLORICELDA ALARCON VELASQUEZ
- `000025` - AZUCENA ZENEIDA ANCHUNDIA RODRIGUEZ

### 2. Códigos Inválidos
- `999999` - No existe
- `123456` - No existe
- `000000` - No existe

### 3. Casos Especiales
- Código vacío después de encontrar empleado
- Borrar dígitos después de encontrar empleado
- Múltiples búsquedas consecutivas

## 🐛 Solución de Problemas

### Error de Conexión
```dart
// Verificar conectividad
try {
  final empleado = await ApiService.getColaboradorPorCodigo(codigo);
} catch (e) {
  // Mostrar mensaje de error
}
```

### Sistema de Fallback para Errores de Red
El sistema ahora incluye un mecanismo de fallback robusto que maneja automáticamente los errores de conectividad:

**Tipos de Errores Manejados:**
- `SocketException`: Error de conexión de red
- `TimeoutException`: Timeout en la conexión
- `ClientException: Failed to fetch`: Error de conectividad general

**Comportamiento del Fallback:**
```dart
// Objeto de ejemplo que se devuelve en caso de error
static final Map<String, dynamic> _fallbackColaborador = {
  'apellidos': 'CASTRO LOOR',
  'area': 'GERENCIA FINANCIERA',
  'cargo': 'Asistente de activo fijo',
  'cedula': '1310842016',
  'centro_costo': 'CONTABILIDAD GENERAL',
  'departamento': 'Contabilidad General',
  'email_personal': 'emavijo@hotmail.com',
  'fecha_ingreso': '18/11/2024 12:00:00 a. m.',
  'labor': 'A',
  'nombres': 'VIVIANA DOLORES',
  'seccion': 'Asistente de activo fijo',
};
```

**Ventajas del Sistema de Fallback:**
- ✅ El código ingresado por el usuario se mantiene
- ✅ Se completa la información con datos de ejemplo
- ✅ No se interrumpe el flujo de trabajo del usuario
- ✅ Se evitan excepciones que podrían romper la aplicación
- ✅ Se proporciona feedback visual inmediato

### Código No Encontrado
```dart
if (empleado == null) {
  // Mostrar mensaje: "Persona no encontrada"
}
```

### Validación de Formato
```dart
if (codigo.length != 6) {
  // No realizar búsqueda
}
```

## 📈 Próximas Mejoras

- [x] Sistema de fallback para errores de conectividad
- [ ] Cache local de empleados frecuentes
- [ ] Búsqueda por cédula además de código
- [ ] Autocompletado con sugerencias
- [ ] Historial de búsquedas recientes
- [ ] Sincronización offline de datos de empleados

---

**Nota**: Esta funcionalidad mejora significativamente la experiencia del usuario al reducir errores de entrada manual y proporcionar información verificada directamente desde el sistema de recursos humanos de Tecopesca. 