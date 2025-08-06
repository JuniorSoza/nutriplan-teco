# NutriPlan Backend - API REST

API REST completa para el sistema de gestión NutriPlan desarrollada en Node.js con Express.

## 🚀 Características

- **API REST completa** con todas las operaciones CRUD
- **Base de datos MySQL** con pool de conexiones
- **Documentación Swagger** automática
- **Seguridad** con Helmet, CORS y Rate Limiting
- **Manejo de errores** centralizado
- **Transacciones** para operaciones complejas

## 📋 Tablas de la Base de Datos

### Notificacion
- `id` (BIGINT, PRIMARY KEY)
- `mensaje` (VARCHAR(255))

### Biometrico
- `bio_tarjeta` (VARCHAR(255), PRIMARY KEY)
- `bio_huella` (VARCHAR(255))

### Producto
- `prd_codigo` (INT, PRIMARY KEY)
- `prd_descripcion` (VARCHAR(255))
- `prd_imagen` (VARCHAR(255))
- `prd_nombre` (VARCHAR(255))
- `prd_ubicacion` (VARCHAR(255))

### Factura Cabecera
- `fac_cab_codigo` (INT, PRIMARY KEY)
- `emp_codigo` (VARCHAR(255))
- `emp_apellidos` (VARCHAR(255))
- `emp_cedula` (VARCHAR(255))
- `emp_correo` (VARCHAR(255))
- `emp_nombres` (VARCHAR(255))
- `fac_cab_fecha` (DATETIME(6))
- `emp_centro_costo` (VARCHAR(255))
- `emp_departamento` (VARCHAR(255))
- `emp_labor` (VARCHAR(255))
- `fac_cab_cantidad` (INT, NOT NULL)
- `fac_cab_descuento` (DOUBLE, DEFAULT 0)
- `fac_cab_precio_empleado` (DOUBLE)
- `producto_prd_codigo` (INT, FOREIGN KEY)

### Reporte
- `id` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `empleado_codigo` (VARCHAR(255))
- `empleado` (VARCHAR(255))
- `fecha` (DATETIME(6))
- `tipo` (VARCHAR(255))
- `factura` (INT)
- `cantidad` (INT)
- `centro_costo` (VARCHAR(255))
- `departamento` (VARCHAR(255))
- `descuento` (DOUBLE)
- `labor` (VARCHAR(255))
- `nombres` (VARCHAR(255))
- `precio_empleado` (DOUBLE)
- `codigo` (VARCHAR(255))

## 🛠️ Tecnologías Utilizadas

- **Node.js** - Runtime de JavaScript
- **Express.js** - Framework web
- **MySQL2** - Driver de base de datos
- **Swagger/OpenAPI** - Documentación de API
- **Helmet** - Seguridad HTTP
- **CORS** - Cross-Origin Resource Sharing
- **Express Rate Limit** - Protección contra spam/DDoS
- **Joi** - Validación de datos
- **Nodemon** - Desarrollo con auto-restart

## 📦 Instalación

### Prerrequisitos

- Node.js (versión 14 o superior)
- MySQL (versión 5.7 o superior)
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd backend
   ```

2. **Instalar dependencias**
   ```bash
   npm install
   ```

3. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   # Editar .env con las credenciales de la BD
   ```

4. **Configurar base de datos**
   ```bash
   # Ejecutar el script de base de datos
   mysql -u root -p < ../bd\ mejorado.sql
   
   # Ejecutar inserts de prueba (opcional)
   mysql -u root -p < inserts_prueba.sql
   ```

5. **Iniciar servidor**
   ```bash
   # Modo desarrollo
   npm run dev
   
   # Modo producción
   npm start
   ```

## 🔧 Configuración de Variables de Entorno

Crear archivo `.env` en la raíz del proyecto:

```env
# Configuración de la base de datos
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=teco_new
DB_PORT=3306

# Configuración del servidor
PORT=3000
NODE_ENV=development
```

## 📚 Documentación de la API

Una vez iniciado el servidor, la documentación estará disponible en:
```
http://localhost:3000/api-docs
```

### Endpoints Principales

#### Notificaciones
- `GET /api/notificaciones` - Obtener todas las notificaciones
- `GET /api/notificaciones/:id` - Obtener notificación por ID
- `POST /api/notificaciones` - Crear nueva notificación
- `PUT /api/notificaciones/:id` - Actualizar notificación
- `DELETE /api/notificaciones/:id` - Eliminar notificación

#### Productos
- `GET /api/productos` - Obtener todos los productos
- `GET /api/productos/:codigo` - Obtener producto por código
- `POST /api/productos` - Crear nuevo producto
- `PUT /api/productos/:codigo` - Actualizar producto
- `DELETE /api/productos/:codigo` - Eliminar producto

#### Facturas
- `GET /api/facturas` - Obtener todas las facturas
- `GET /api/facturas/:codigo` - Obtener factura por código
- `POST /api/facturas` - Crear nueva factura
- `PUT /api/facturas/:codigo` - Actualizar factura
- `DELETE /api/facturas/:codigo` - Eliminar factura

#### Reportes
- `GET /api/reportes` - Obtener todos los reportes
- `GET /api/reportes/:id` - Obtener reporte por ID
- `POST /api/reportes` - Crear nuevo reporte
- `PUT /api/reportes/:id` - Actualizar reporte
- `DELETE /api/reportes/:id` - Eliminar reporte
- `GET /api/reportes/estadisticas` - Obtener estadísticas

#### Biométricos
- `GET /api/biometricos` - Obtener todos los registros
- `GET /api/biometricos/:tarjeta` - Obtener registro por tarjeta
- `POST /api/biometricos` - Crear nuevo registro
- `PUT /api/biometricos/:tarjeta` - Actualizar registro
- `DELETE /api/biometricos/:tarjeta` - Eliminar registro
- `POST /api/biometricos/verificar/:tarjeta` - Verificar huella

## 🔒 Seguridad

### Rate Limiting
- 100 requests por IP cada 15 minutos
- Protección contra spam y ataques DDoS

### Headers de Seguridad
- Helmet configurado para headers HTTP seguros
- CORS configurado para permitir acceso desde frontend

### Validación de Datos
- Validación de entrada en todos los endpoints
- Sanitización de datos antes de procesar

## 🚀 Scripts Disponibles

```bash
npm start          # Modo producción
npm run dev        # Modo desarrollo con nodemon
npm test           # Ejecutar pruebas (pendiente)
```

## 🔍 Pruebas de la API

### Health Check
```bash
curl http://localhost:3000/health
```

### Ejemplo de uso con cURL

#### Obtener productos
```bash
curl http://localhost:3000/api/productos
```

#### Crear un producto
```bash
curl -X POST http://localhost:3000/api/productos \
  -H "Content-Type: application/json" \
  -d '{
    "prd_codigo": 1,
    "prd_descripcion": "Producto de desayuno",
    "prd_imagen": "/images/desayuno.jpg",
    "prd_nombre": "desayuno",
    "prd_ubicacion": "Cafetería"
  }'
```

## 🐛 Solución de Problemas

### Error de Conexión a Base de Datos
1. Verificar que MySQL esté ejecutándose
2. Confirmar credenciales en `.env`
3. Verificar que la base de datos `teco_new` exista

### Error de Dependencias
```bash
rm -rf node_modules package-lock.json
npm install
```

### Error de Puerto en Uso
```bash
# Cambiar puerto en .env
PORT=3001
```

## 📈 Próximas Funcionalidades

- [ ] Autenticación JWT
- [ ] Autorización por roles
- [ ] Logs de auditoría
- [ ] Backup automático
- [ ] Cache con Redis
- [ ] Tests unitarios y de integración
- [ ] Validación con Joi
- [ ] Upload de imágenes
- [ ] Exportación de datos

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
- **Proyecto**: [https://github.com/nutriplan/backend-api](https://github.com/nutriplan/backend-api)

---

**Nota**: Esta API está diseñada para funcionar en conjunto con el frontend de NutriPlan. 