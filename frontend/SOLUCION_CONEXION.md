# Solución de Problemas de Conexión - Servicio Web Colaboradores

## 🔍 Diagnóstico del Problema

El error de conexión al servicio web `http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador` puede deberse a varios factores. Esta guía te ayudará a identificar y solucionar el problema.

## 🛠️ Herramientas de Diagnóstico Implementadas

### 1. Botón "Probar Conexión"
- **Ubicación**: Formulario de Productos
- **Función**: Prueba la conectividad al servicio web
- **Información mostrada**: 
  - Estado de la conexión
  - Número de colaboradores disponibles
  - Detalles del error (si existe)

### 2. Logs Detallados
- **Consola de Flutter**: Muestra información detallada del proceso
- **Información incluida**:
  - URL del servicio
  - Status code de respuesta
  - Headers de respuesta
  - Tamaño de la respuesta
  - Errores específicos

## 🚨 Posibles Causas y Soluciones

### 1. Problema de Red/Conectividad

**Síntomas:**
- Error de socket
- Timeout de conexión
- "No se pudo conectar al servidor"

**Soluciones:**
```bash
# Verificar conectividad básica
ping ddws.tecopesca.com

# Verificar puerto específico
telnet ddws.tecopesca.com 8042

# Verificar desde el navegador
http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador
```

### 2. Problema de CORS (Cross-Origin Resource Sharing)

**Síntomas:**
- Error 403 Forbidden
- Error de CORS en consola del navegador

**Soluciones:**
- **Contactar al administrador del servidor** para habilitar CORS
- **Configurar proxy** en el backend
- **Usar modo de desarrollo** con CORS deshabilitado

### 3. Problema de Firewall/Proxy

**Síntomas:**
- Conexión rechazada
- Timeout
- Error de red

**Soluciones:**
- **Verificar configuración de firewall** corporativo
- **Configurar proxy** si es necesario
- **Contactar al departamento de IT**

### 4. Problema de Certificados SSL

**Síntomas:**
- Error de certificado
- Conexión insegura

**Soluciones:**
```dart
// En lib/config/app_config.dart
static const String colaboradoresUrl = 'http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador';
// Cambiar a HTTPS si es necesario
```

### 5. Problema de Timeout

**Síntomas:**
- "La conexión tardó demasiado"
- Timeout después de 30 segundos

**Soluciones:**
- **Verificar velocidad de red**
- **Aumentar timeout** en el código
- **Verificar carga del servidor**

## 🔧 Configuraciones Implementadas

### Timeout Extendido
```dart
.timeout(
  const Duration(seconds: 30),
  onTimeout: () {
    throw Exception('Timeout: La conexión tardó más de 30 segundos');
  },
)
```

### Headers Mejorados
```dart
headers: {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
}
```

### Manejo de Errores Específicos
- **SocketException**: Error de red
- **TimeoutException**: Timeout de conexión
- **FormatException**: Error de JSON
- **HttpException**: Error HTTP

## 📱 Pasos para Diagnosticar

### 1. Usar el Botón "Probar Conexión"
1. Abrir la aplicación Flutter
2. Ir a "Productos"
3. Hacer clic en "Probar Conexión"
4. Revisar el mensaje resultante

### 2. Revisar Logs en Consola
```bash
flutter run --verbose
```

### 3. Verificar desde Navegador
1. Abrir navegador web
2. Ir a: `http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador`
3. Verificar si devuelve JSON válido

### 4. Probar con curl
```bash
curl -v http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador
```

## 🚀 Soluciones Alternativas

### 1. Implementar Cache Local
```dart
// Guardar datos localmente para uso offline
static Future<void> cacheColaboradores() async {
  // Implementar cache local
}
```

### 2. Usar Proxy en Backend
```javascript
// En el backend Node.js
app.get('/api/colaboradores', async (req, res) => {
  const response = await fetch('http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador');
  const data = await response.json();
  res.json(data);
});
```

### 3. Implementar Fallback
```dart
// Si el servicio principal falla, usar servicio alternativo
static Future<Map<String, dynamic>?> getColaboradorPorCodigo(String codigo) async {
  try {
    return await _getFromPrimaryService(codigo);
  } catch (e) {
    return await _getFromFallbackService(codigo);
  }
}
```

## 📞 Contacto para Soporte

### Información del Servicio
- **URL**: `http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador`
- **Puerto**: 8042
- **Protocolo**: HTTP
- **Formato**: JSON

### Datos de Prueba Disponibles
Según la información proporcionada, el servicio devuelve datos como:
```json
{
  "codigo": "000006",
  "cedula": "1311779688",
  "apellidos": "ANCHUNDIA ANCHUNDIA",
  "nombres": "FANNY VICENTA",
  "cargo": "Trabajador(a) de Producción",
  "departamento": "Producción"
}
```

### Códigos de Prueba Válidos
- `000006` - FANNY VICENTA ANCHUNDIA ANCHUNDIA
- `000017` - JOSEFA FLORICELDA ALARCON VELASQUEZ
- `000025` - AZUCENA ZENEIDA ANCHUNDIA RODRIGUEZ

## 🔄 Próximos Pasos

1. **Probar conexión** usando el botón implementado
2. **Revisar logs** en la consola de Flutter
3. **Verificar conectividad** desde navegador
4. **Contactar administrador** del servidor si es necesario
5. **Implementar solución alternativa** si el problema persiste

---

**Nota**: Si el problema persiste después de intentar todas las soluciones, contacta al departamento de IT de Tecopesca para verificar el estado del servicio web. 