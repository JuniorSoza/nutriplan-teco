# NutriPlan - Sistema de Gestión Completo

Sistema completo de gestión para NutriPlan que incluye backend en Node.js y frontend en Flutter.

## 📋 Descripción

NutriPlan es un sistema integral de gestión que permite administrar productos, facturas, reportes y autenticación biométrica. El sistema está compuesto por dos partes principales:

- **Backend**: API REST en Node.js con MySQL
- **Frontend**: Aplicación Flutter responsiva

## 🏗️ Arquitectura del Proyecto

```
nutriplan_new/
├── backend/           # API REST en Node.js
│   ├── config/        # Configuración de BD y Swagger
│   ├── middleware/    # Middlewares personalizados
│   ├── routes/        # Rutas de la API
│   ├── server.js      # Servidor principal
│   └── package.json   # Dependencias del backend
├── frontend/          # Aplicación Flutter
│   ├── lib/           # Código fuente Flutter
│   │   ├── screens/   # Pantallas de la aplicación
│   │   ├── widgets/   # Widgets reutilizables
│   │   └── main.dart  # Punto de entrada
│   └── pubspec.yaml   # Dependencias Flutter
└── bd mejorado.sql   # Script de base de datos
```

## 🚀 Características Principales

### Backend (Node.js)
- ✅ API REST completa con CRUD
- ✅ Base de datos MySQL con pool de conexiones
- ✅ Documentación automática con Swagger
- ✅ Seguridad con Helmet, CORS y Rate Limiting
- ✅ Manejo centralizado de errores
- ✅ Transacciones para operaciones complejas

### Frontend (Flutter)
- ✅ Diseño responsivo para móvil, tablet y desktop
- ✅ Menús adaptativos según el tamaño de pantalla
- ✅ Material Design 3
- ✅ Navegación intuitiva
- ✅ Interfaz moderna y profesional

## 📊 Base de Datos

El sistema utiliza MySQL con las siguientes tablas principales:

- **notificacion**: Gestión de notificaciones
- **biometrico**: Registros biométricos
- **producto**: Catálogo de productos
- **factura_cabecera**: Facturas de empleados
- **reporte**: Reportes del sistema

## 🛠️ Tecnologías Utilizadas

### Backend
- Node.js
- Express.js
- MySQL2
- Swagger/OpenAPI
- Helmet
- CORS
- Express Rate Limit

### Frontend
- Flutter
- Material Design 3
- Dart

## 📦 Instalación

### Prerrequisitos
- Node.js (v14+)
- Flutter SDK
- MySQL (v5.7+)
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd nutriplan_new
   ```

2. **Configurar Backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Editar .env con las credenciales de BD
   ```

3. **Configurar Base de Datos**
   ```bash
   mysql -u root -p < ../bd\ mejorado.sql
   ```

4. **Configurar Frontend**
   ```bash
   cd ../frontend
   flutter pub get
   ```

5. **Ejecutar el Sistema**
   ```bash
   # Terminal 1 - Backend
   cd backend
   npm run dev
   
   # Terminal 2 - Frontend
   cd frontend
   flutter run
   ```

## 🔧 Configuración

### Variables de Entorno (Backend)
Crear archivo `.env` en la carpeta `backend/`:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=teco_new
DB_PORT=3306
PORT=3000
NODE_ENV=development
```

## 📚 Documentación

- **API Documentation**: http://localhost:3000/api-docs
- **Backend README**: [backend/README.md](backend/README.md)
- **Frontend README**: [frontend/README.md](frontend/README.md)

## 🎯 Funcionalidades

### Menús del Sistema

#### Menú Superior (Navegación Principal)
- 🍳 **Desayuno** - Gestión de productos de desayuno
- 🍽️ **Almuerzo** - Gestión de productos de almuerzo
- ☕ **Merienda** - Gestión de productos de merienda
- 🥤 **Refrigerio** - Gestión de refrigerios
- 🍰 **Extras** - Productos adicionales
- 📊 **Últimos Movimientos** - Historial de transacciones

#### Menú Lateral (Administración)
- 💳 **Sistema de Facturación** - Gestión de facturas
- 👤 **Buscar Empleado** - Consulta de empleados
- 📈 **Generar Reportes** - Reportes del sistema
- 🔧 **Actualizar Información** - Mantenimiento de datos

## 🔒 Seguridad

- Rate limiting (100 requests/15min por IP)
- Headers de seguridad con Helmet
- CORS configurado
- Validación de datos en endpoints
- Transacciones para operaciones críticas

## 🚀 Scripts Disponibles

### Backend
```bash
npm start          # Modo producción
npm run dev        # Modo desarrollo
```

### Frontend
```bash
flutter run        # Ejecutar aplicación
flutter build      # Construir para producción
```

## 🐛 Solución de Problemas

### Error de Conexión a BD
1. Verificar que MySQL esté ejecutándose
2. Confirmar credenciales en `.env`
3. Verificar que la BD `teco_new` exista

### Error de Dependencias
```bash
# Backend
cd backend && rm -rf node_modules package-lock.json && npm install

# Frontend
cd frontend && flutter clean && flutter pub get
```

## 📈 Próximas Funcionalidades

- [ ] Autenticación JWT
- [ ] Autorización por roles
- [ ] Notificaciones push
- [ ] Backup automático
- [ ] Tests automatizados
- [ ] Dashboard con gráficos
- [ ] Exportación de datos
- [ ] Integración con sistemas externos

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama para feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 📞 Contacto

- **Empresa**: NutriPlan
- **Email**: info@nutriplan.com
- **Proyecto**: [https://github.com/nutriplan/nutriplan-system](https://github.com/nutriplan/nutriplan-system)

---

**Nota**: Este sistema está diseñado para ser escalable y mantenible, siguiendo las mejores prácticas de desarrollo. 