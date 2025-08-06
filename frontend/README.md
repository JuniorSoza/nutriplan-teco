# NutriPlan Frontend - Flutter App

Aplicación móvil y web para el sistema de gestión de NutriPlan desarrollada en Flutter.

## 🚀 Características

- **Interfaz responsiva** que se adapta a móviles, tablets y desktop
- **Menú superior** para registro de movimientos (Desayuno, Almuerzo, Merienda, etc.)
- **Menú lateral** para administración (Facturación, Búsqueda, Reportes, etc.)
- **Diseño Material 3** con tema personalizado
- **Navegación intuitiva** con indicadores visuales de selección

## 📱 Menús Implementados

### Menú Superior (Registro de Movimientos)
- **Inicio**: Pantalla de bienvenida
- **Desayuno**: Registro de desayunos
- **Almuerzo**: Registro de almuerzos
- **Merienda**: Registro de meriendas
- **Refrigerio**: Registro de refrigerios
- **Extras**: Registro de extras
- **Últimos Movimientos**: Historial de registros

### Menú Lateral (Administración)
- **Sistema de Facturación**: Gestión de facturas
- **Buscar Empleado**: Búsqueda de empleados
- **Generar Reportes**: Generación de reportes
- **Actualizar Información**: Actualización de datos

## 🎨 Diseño Responsivo

### Móvil (< 768px)
- Menú superior horizontal scrolleable
- Drawer lateral con todos los menús
- Botón hamburguesa en AppBar

### Tablet (768px - 1200px)
- Menú superior completo
- Menú lateral compacto (200px)
- Layout optimizado para pantallas medianas

### Desktop (> 1200px)
- Menú superior completo
- Menú lateral completo (250px)
- Máximo aprovechamiento del espacio

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo
- **Material Design 3**: Sistema de diseño
- **Responsive Design**: Adaptación a diferentes pantallas
- **State Management**: Gestión de estado con setState

## 📦 Instalación

### Prerrequisitos

- Flutter SDK (versión 3.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Emulador o dispositivo físico

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd frontend
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   # Para desarrollo
   flutter run

   # Para web
   flutter run -d chrome

   # Para Android
   flutter run -d android

   # Para iOS
   flutter run -d ios
   ```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada de la aplicación
├── screens/
│   └── home_screen.dart   # Pantalla principal con navegación
└── widgets/
    ├── responsive_layout.dart  # Layout responsivo
    ├── top_menu.dart          # Menú superior
    ├── side_menu.dart         # Menú lateral
    └── mobile_menu.dart       # Menú móvil (drawer)
```

## 🎯 Funcionalidades por Pantalla

### Pantalla de Inicio
- Mensaje de bienvenida
- Instrucciones de navegación
- Iconografía descriptiva

### Pantallas de Registro (Desayuno, Almuerzo, etc.)
- Formulario de registro
- Campos: Código de empleado, nombre, cantidad
- Botón de guardar con confirmación
- Validación de datos

### Últimos Movimientos
- Lista de registros recientes
- Información: Empleado, tipo de comida, hora, cantidad
- Diseño de tarjetas con avatares

### Sistema de Facturación
- Botones para nueva factura y búsqueda
- Interfaz preparada para integración con backend

### Búsqueda de Empleados
- Campo de búsqueda con icono
- Preparado para integración con API

### Generación de Reportes
- Grid de reportes disponibles
- Reporte diario, semanal, mensual, por empleado
- Diseño de tarjetas interactivas

### Actualización de Información
- Lista de opciones de actualización
- Empleados, productos, precios, configuración
- Navegación preparada para subpantallas

## 🔧 Configuración

### Tema de la Aplicación
- Color primario: Azul
- Material Design 3 habilitado
- AppBar personalizado
- Drawer con tema consistente

### Breakpoints Responsivos
- **Móvil**: < 768px
- **Tablet**: 768px - 1200px
- **Desktop**: > 1200px

## 🚀 Próximas Funcionalidades

- [ ] Integración con API backend
- [ ] Autenticación de usuarios
- [ ] Persistencia local de datos
- [ ] Notificaciones push
- [ ] Modo offline
- [ ] Exportación de reportes
- [ ] Escáner de códigos QR
- [ ] Sincronización en tiempo real

## 🐛 Solución de Problemas

### Error de Dependencias
```bash
flutter clean
flutter pub get
```

### Error de Compilación
```bash
flutter doctor
flutter analyze
```

### Problemas de Rendimiento
- Verificar que el dispositivo tenga suficiente memoria
- Usar `flutter run --profile` para testing de rendimiento

## 📝 Scripts Disponibles

- `flutter run` - Ejecutar en modo debug
- `flutter run --release` - Ejecutar en modo release
- `flutter build web` - Construir para web
- `flutter build apk` - Construir APK para Android
- `flutter build ios` - Construir para iOS

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Contacto

- **Empresa**: NutriPlan
- **Email**: info@nutriplan.com
- **Proyecto**: [https://github.com/nutriplan/frontend-app](https://github.com/nutriplan/frontend-app)

---

**Nota**: Esta aplicación está diseñada para funcionar en conjunto con el backend de NutriPlan.
