const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const swaggerUi = require('swagger-ui-express');
const swaggerSpecs = require('./config/swagger');
const errorHandler = require('./middleware/errorHandler');
const { testConnection } = require('./config/database');

// Importar rutas
const notificacionesRoutes = require('./routes/notificaciones');
const productosRoutes = require('./routes/productos');
const facturasRoutes = require('./routes/facturas');
const reportesRoutes = require('./routes/reportes');
const biometricosRoutes = require('./routes/biometricos');

const app = express();
const PORT = process.env.PORT || 3000;

// Configurar rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // máximo 100 requests por ventana
  message: {
    error: 'Demasiadas solicitudes desde esta IP, intenta de nuevo en 15 minutos'
  }
});

// Middleware de seguridad
app.use(helmet());
app.use(cors());
app.use(limiter);

// Middleware para parsing JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Servir documentación Swagger
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpecs, {
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'NutriPlan API Documentation'
}));

// Ruta de bienvenida
app.get('/', (req, res) => {
  res.json({
    message: 'Bienvenido a la API de NutriPlan',
    version: '1.0.0',
    documentation: '/api-docs',
    endpoints: {
      notificaciones: '/api/notificaciones',
      productos: '/api/productos',
      facturas: '/api/facturas',
      reportes: '/api/reportes',
      biometricos: '/api/biometricos'
    }
  });
});

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    await testConnection();
    res.json({
      status: 'OK',
      timestamp: new Date().toISOString(),
      database: 'Connected'
    });
  } catch (error) {
    res.status(503).json({
      status: 'ERROR',
      timestamp: new Date().toISOString(),
      database: 'Disconnected',
      error: error.message
    });
  }
});

// Montar rutas
app.use('/api/notificaciones', notificacionesRoutes);
app.use('/api/productos', productosRoutes);
app.use('/api/facturas', facturasRoutes);
app.use('/api/reportes', reportesRoutes);
app.use('/api/biometricos', biometricosRoutes);

// Middleware de manejo de errores
app.use(errorHandler);

// Manejo de rutas no encontradas
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Ruta no encontrada',
    message: `La ruta ${req.originalUrl} no existe en esta API`,
    availableEndpoints: [
      'GET /',
      'GET /health',
      'GET /api-docs',
      'GET /api/notificaciones',
      'GET /api/productos',
      'GET /api/facturas',
      'GET /api/reportes',
      'GET /api/biometricos'
    ]
  });
});

// Iniciar servidor
const server = app.listen(PORT, () => {
  console.log(`🚀 Servidor NutriPlan ejecutándose en puerto ${PORT}`);
  console.log(`📚 Documentación disponible en: http://localhost:${PORT}/api-docs`);
  console.log(`🏥 Health check disponible en: http://localhost:${PORT}/health`);
});

// Manejo de cierre graceful
process.on('SIGTERM', () => {
  console.log('SIGTERM recibido, cerrando servidor...');
  server.close(() => {
    console.log('Servidor cerrado');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT recibido, cerrando servidor...');
  server.close(() => {
    console.log('Servidor cerrado');
    process.exit(0);
  });
});

module.exports = app; 