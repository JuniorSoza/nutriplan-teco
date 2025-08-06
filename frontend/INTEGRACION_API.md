# Integración con API Backend - NutriPlan Frontend

## 📋 Descripción

El frontend de NutriPlan ahora está integrado con el backend para obtener dinámicamente los tipos de productos desde la base de datos.

## 🔧 Configuración

### Dependencias Agregadas

```yaml
dependencies:
  http: ^1.1.0  # Cliente HTTP para llamadas a la API
```

### Archivos Creados

#### `lib/config/app_config.dart`
Configuración centralizada para URLs y parámetros del backend:
- URLs del backend
- Timeouts de conexión
- Configuración de la aplicación

#### `lib/services/api_service.dart`
Servicio para manejar todas las llamadas a la API:
- Obtener productos
- Filtrar productos por nombre
- Crear nuevos productos
- Obtener tipos únicos de productos

## 🚀 Funcionalidades Implementadas

### 1. Carga Dinámica de Tipos de Productos

El dropdown "Tipo de Producto" ahora se carga automáticamente desde el endpoint `/api/productos` del backend.

**Proceso:**
1. Al iniciar la aplicación, se llama a `ApiService.getTiposProductos()`
2. Se obtienen todos los productos del backend
3. Se extraen los nombres únicos (`prd_nombre`)
4. Se ordenan alfabéticamente
5. Se muestran en el dropdown

### 2. Formulario Mejorado

**Campos del formulario:**
- **Código de Empleado**: Campo de texto con icono
- **Nombre del Empleado**: Campo de texto con icono
- **Tipo de Producto**: Dropdown dinámico con icono
- **Cantidad**: Campo numérico con icono

**Funcionalidades:**
- Validación de campos obligatorios
- Indicador de carga mientras se obtienen los tipos
- Botón para actualizar la lista de tipos
- Limpieza automática del formulario después de guardar

### 3. Manejo de Errores

- **Error de conexión**: Muestra mensaje de error en SnackBar
- **Error de carga**: Permite reintentar con botón "Actualizar Lista"
- **Validación**: Verifica que todos los campos estén completos

## 🔗 Endpoints Utilizados

### GET `/api/productos`
- **Propósito**: Obtener todos los productos
- **Respuesta**: Lista de productos con estructura:
  ```json
  [
    {
      "prd_codigo": 1,
      "prd_descripcion": "Producto de desayuno",
      "prd_imagen": "/images/desayuno.jpg",
      "prd_nombre": "desayuno",
      "prd_ubicacion": "Cafetería"
    }
  ]
  ```

### GET `/api/productos?nombre=valor`
- **Propósito**: Filtrar productos por nombre
- **Parámetros**: `nombre` (opcional)
- **Respuesta**: Lista filtrada de productos

## 📱 Interfaz de Usuario

### Estados del Dropdown

1. **Cargando**: Muestra spinner y texto "Cargando tipos de productos..."
2. **Cargado**: Muestra lista de tipos disponibles
3. **Error**: Permite reintentar con botón "Actualizar Lista"

### Botones de Acción

- **Actualizar Lista**: Recarga los tipos de productos desde el backend
- **Guardar Registro**: Valida y procesa el formulario

## 🛠️ Configuración del Backend

### Requisitos

1. **Backend ejecutándose**: Puerto 3000 por defecto
2. **Base de datos configurada**: Con tabla `producto` poblada
3. **CORS habilitado**: Para permitir peticiones desde Flutter

### URL de Configuración

```dart
// En lib/config/app_config.dart
static const String backendUrl = 'http://localhost:3000';
```

**Para desarrollo móvil**, cambiar a la IP de tu máquina:
```dart
static const String backendUrl = 'http://192.168.1.100:3000';
```

## 🔍 Pruebas

### 1. Verificar Conexión

1. Iniciar el backend: `npm run dev`
2. Iniciar el frontend: `flutter run`
3. Navegar a "Productos"
4. Verificar que el dropdown se carga con los tipos

### 2. Probar Funcionalidades

1. **Carga inicial**: Los tipos deben aparecer automáticamente
2. **Actualizar lista**: Botón debe recargar los tipos
3. **Validación**: Formulario debe validar campos vacíos
4. **Guardar**: Debe limpiar el formulario después de guardar

### 3. Manejo de Errores

1. **Sin backend**: Debe mostrar error de conexión
2. **Backend sin datos**: Dropdown debe estar vacío
3. **Error de red**: Debe permitir reintentar

## 📈 Próximas Mejoras

- [ ] Integración completa con endpoint de guardar registros
- [ ] Cache local de tipos de productos
- [ ] Sincronización automática en segundo plano
- [ ] Filtros avanzados de productos
- [ ] Búsqueda en tiempo real

## 🐛 Solución de Problemas

### Error de Conexión
```bash
# Verificar que el backend esté ejecutándose
curl http://localhost:3000/health
```

### CORS Error
```javascript
// En el backend, verificar configuración CORS
app.use(cors({
  origin: ['http://localhost:3000', 'http://127.0.0.1:3000']
}));
```

### URL Incorrecta
```dart
// Cambiar en lib/config/app_config.dart
static const String backendUrl = 'http://TU_IP:3000';
```

---

**Nota**: Esta integración permite que el frontend se adapte automáticamente a los cambios en la base de datos del backend, manteniendo la sincronización entre ambos sistemas. 