const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'NutriPlan API',
      version: '1.0.0',
      description: 'API REST para el sistema de gestión NutriPlan',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Servidor de desarrollo',
      },
    ],
    components: {
      schemas: {
        Notificacion: {
          type: 'object',
          properties: {
            id: { type: 'integer', format: 'int64' },
            mensaje: { type: 'string', maxLength: 255 }
          },
          required: ['id', 'mensaje']
        },
        Biometrico: {
          type: 'object',
          properties: {
            bio_tarjeta: { type: 'string', maxLength: 255 },
            bio_huella: { type: 'string', maxLength: 255 }
          },
          required: ['bio_tarjeta', 'bio_huella']
        },
        Producto: {
          type: 'object',
          properties: {
            prd_codigo: { type: 'integer' },
            prd_descripcion: { type: 'string', maxLength: 255 },
            prd_imagen: { type: 'string', maxLength: 255 },
            prd_nombre: { type: 'string', maxLength: 255 },
            prd_ubicacion: { type: 'string', maxLength: 255 }
          },
          required: ['prd_codigo', 'prd_nombre']
        },
        FacturaCabecera: {
          type: 'object',
          properties: {
            fac_cab_codigo: { type: 'integer' },
            emp_codigo: { type: 'string', maxLength: 255 },
            emp_apellidos: { type: 'string', maxLength: 255 },
            emp_cedula: { type: 'string', maxLength: 255 },
            emp_correo: { type: 'string', maxLength: 255 },
            emp_nombres: { type: 'string', maxLength: 255 },
            fac_cab_fecha: { type: 'string', format: 'date-time' },
            emp_centro_costo: { type: 'string', maxLength: 255 },
            emp_departamento: { type: 'string', maxLength: 255 },
            emp_labor: { type: 'string', maxLength: 255 },
            fac_cab_cantidad: { type: 'integer' },
            fac_cab_descuento: { type: 'number', format: 'double' },
            fac_cab_precio_empleado: { type: 'number', format: 'double' },
            producto_prd_codigo: { type: 'integer' }
          },
          required: ['fac_cab_codigo', 'fac_cab_cantidad']
        },
        Reporte: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            empleado_codigo: { type: 'string', maxLength: 255 },
            empleado: { type: 'string', maxLength: 255 },
            fecha: { type: 'string', format: 'date-time' },
            tipo: { type: 'string', maxLength: 255 },
            factura: { type: 'integer' },
            cantidad: { type: 'integer' },
            centro_costo: { type: 'string', maxLength: 255 },
            departamento: { type: 'string', maxLength: 255 },
            descuento: { type: 'number', format: 'double' },
            labor: { type: 'string', maxLength: 255 },
            nombres: { type: 'string', maxLength: 255 },
            precio_empleado: { type: 'number', format: 'double' },
            codigo: { type: 'string', maxLength: 255 }
          }
        }
      }
    }
  },
  apis: ['./routes/*.js'],
};

const specs = swaggerJsdoc(options);

module.exports = specs; 