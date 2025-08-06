# NutriPlan Frontend

Sistema de gestión de comedor empresarial desarrollado con Flutter.

## Descripción

NutriPlan es una aplicación Flutter responsiva que permite gestionar las operaciones de un comedor empresarial, incluyendo:

- **Sistema de Facturación**: Registro de ventas y transacciones
- **Búsqueda de Empleados**: Consulta de información de empleados en tiempo real
- **Generación de Reportes**: Creación de reportes detallados con exportación a Excel y PDF
- **Gestión de Productos**: Administración del catálogo de productos del comedor

## Características

- 🎨 **Diseño Responsivo**: Adaptable a dispositivos móviles, tablets y desktop
- 📊 **Reportes Avanzados**: Generación de reportes con exportación a Excel y PDF
- 🔍 **Búsqueda en Tiempo Real**: Integración con servicio web externo para consulta de empleados
- 📱 **Interfaz Moderna**: Material Design 3 con tema personalizado
- ⚡ **Rendimiento Optimizado**: Gestión eficiente de estado y recursos

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Material Design 3**: Sistema de diseño
- **PlutoGrid**: Widget para tablas de datos
- **HTTP**: Cliente HTTP para APIs
- **Excel**: Exportación a formato Excel
- **PDF**: Generación de documentos PDF
- **File Picker**: Selección y guardado de archivos

## Estructura del Proyecto

```
lib/
├── config/
│   └── app_config.dart          # Configuración de la aplicación
├── screens/
│   └── home_screen.dart         # Pantalla principal
├── services/
│   ├── api_service.dart         # Servicios de API
│   ├── export_service.dart      # Servicios de exportación
│   └── reportes_service.dart    # Servicios de reportes
└── widgets/
    ├── billing_system_widget.dart    # Widget de facturación
    ├── employee_search_widget.dart   # Widget de búsqueda de empleados
    ├── mobile_menu.dart              # Menú móvil
    ├── products_widget.dart          # Widget de productos
    ├── recent_movements_widget.dart  # Widget de movimientos recientes
    ├── reports_widget.dart           # Widget de reportes
    ├── responsive_layout.dart        # Layout responsivo
    ├── side_menu.dart                # Menú lateral
    ├── top_menu.dart                 # Menú superior
    └── update_info_widget.dart       # Widget de actualización
```

## Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone <url-del-repositorio>
   cd frontend
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configurar el backend**:
   - Asegúrate de que el backend esté ejecutándose en `http://localhost:3000`
   - Verifica la configuración en `lib/config/app_config.dart`

4. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## Configuración

### Backend URL
Edita `lib/config/app_config.dart` para configurar las URLs del backend:

```dart
class AppConfig {
  static const String backendUrl = 'http://localhost:3000';
  static const String webServiceUrl = 'http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador';
  // ...
}
```

### Variables de Entorno
Para desarrollo local, asegúrate de que el backend esté configurado correctamente con las variables de entorno necesarias.

## Funcionalidades Principales

### 1. Sistema de Facturación
- Registro de ventas de productos
- Búsqueda automática de empleados por código
- Cálculo automático de precios y descuentos
- Validación de datos en tiempo real

### 2. Búsqueda de Empleados
- Integración con servicio web externo
- Búsqueda automática al ingresar 6 dígitos
- Manejo robusto de errores de conexión
- Modo offline con datos de respaldo

### 3. Generación de Reportes
- Reportes por rango de fechas
- Reportes por empleado específico
- Exportación a Excel y PDF
- Visualización en tablas interactivas

### 4. Gestión de Productos
- Catálogo de productos del comedor
- Categorización por tipos
- Precios y disponibilidad

## Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # Cliente HTTP
  pluto_grid: ^8.0.0              # Tablas de datos
  excel: ^2.1.0                   # Exportación Excel
  pdf: ^3.10.7                    # Generación PDF
  file_picker: ^6.1.1             # Selección de archivos
  intl: ^0.19.0                   # Internacionalización
  path_provider: ^2.1.2           # Acceso a archivos
```

## Desarrollo

### Comandos Útiles

```bash
# Analizar el código
flutter analyze

# Ejecutar tests
flutter test

# Construir para web
flutter build web

# Construir para Android
flutter build apk

# Limpiar cache
flutter clean
```

### Estructura de Widgets

Los widgets están organizados por funcionalidad:

- **Menús**: `top_menu.dart`, `side_menu.dart`, `mobile_menu.dart`
- **Funcionalidades**: `billing_system_widget.dart`, `employee_search_widget.dart`, etc.
- **Servicios**: `api_service.dart`, `export_service.dart`, `reportes_service.dart`

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Soporte

Para soporte técnico o preguntas sobre el proyecto, contacta al equipo de desarrollo.

---

**NutriPlan** - Sistema de Gestión de Comedor Empresarial
