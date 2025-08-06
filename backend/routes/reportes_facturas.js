const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/reportes-facturas/rango-fechas:
 *   get:
 *     summary: Genera reporte de facturas por rango de fechas
 *     description: Obtiene todas las facturas dentro de un rango de fechas específico con información detallada
 *     tags: [Reportes Facturas]
 *     parameters:
 *       - in: query
 *         name: fechaInicio
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de inicio (YYYY-MM-DD)
 *         example: "2025-05-19"
 *       - in: query
 *         name: fechaFin
 *         required: true
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de fin (YYYY-MM-DD)
 *         example: "2025-05-23"
 *       - in: query
 *         name: formato
 *         required: false
 *         schema:
 *           type: string
 *           enum: [json, excel, resumen, csv]
 *         description: Formato de respuesta (csv devuelve texto plano)
 *         example: "json"
 *     responses:
 *       200:
 *         description: Reporte generado exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Reporte generado exitosamente"
 *                 data:
 *                   type: object
 *                   properties:
 *                     facturas:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           fac_cab_codigo:
 *                             type: integer
 *                             example: 1
 *                           emp_codigo:
 *                             type: string
 *                             example: "123456"
 *                           emp_nombres:
 *                             type: string
 *                             example: "LUCAS SANTANA"
 *                           emp_apellidos:
 *                             type: string
 *                             example: "GENESIS MISHELLE"
 *                           emp_cedula:
 *                             type: string
 *                             example: "1234567890"
 *                           emp_correo:
 *                             type: string
 *                             example: "lucas@example.com"
 *                           fac_cab_fecha:
 *                             type: string
 *                             format: date-time
 *                             example: "2025-05-19T10:30:00.000Z"
 *                           emp_centro_costo:
 *                             type: string
 *                             example: "CC001"
 *                           emp_departamento:
 *                             type: string
 *                             example: "PRODUCCION"
 *                           emp_labor:
 *                             type: string
 *                             example: "OPERADOR"
 *                           fac_cab_cantidad:
 *                             type: integer
 *                             example: 1
 *                           fac_cab_descuento:
 *                             type: number
 *                             format: float
 *                             example: 0.00
 *                           fac_cab_precio_empleado:
 *                             type: number
 *                             format: float
 *                             example: 1.65
 *                           producto_prd_codigo:
 *                             type: integer
 *                             example: 1
 *                           producto_nombre:
 *                             type: string
 *                             example: "Almuerzo"
 *                     resumen:
 *                       type: object
 *                       properties:
 *                         totalFacturas:
 *                           type: integer
 *                           example: 150
 *                         totalCantidad:
 *                           type: integer
 *                           example: 150
 *                         totalPrecio:
 *                           type: number
 *                           format: float
 *                           example: 247.50
 *                         totalDescuento:
 *                           type: number
 *                           format: float
 *                           example: 0.00
 *                         promedioPrecio:
 *                           type: number
 *                           format: float
 *                           example: 1.65
 *                         empleadosUnicos:
 *                           type: integer
 *                           example: 45
 *                         productosUnicos:
 *                           type: integer
 *                           example: 5
 *                     estadisticasPorDia:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           fecha:
 *                             type: string
 *                             format: date
 *                             example: "2025-05-19"
 *                           totalFacturas:
 *                             type: integer
 *                             example: 30
 *                           totalCantidad:
 *                             type: integer
 *                             example: 30
 *                           totalPrecio:
 *                             type: number
 *                             format: float
 *                             example: 49.50
 *                     estadisticasPorEmpleado:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           emp_codigo:
 *                             type: string
 *                             example: "123456"
 *                           emp_nombres:
 *                             type: string
 *                             example: "LUCAS SANTANA"
 *                           emp_apellidos:
 *                             type: string
 *                             example: "GENESIS MISHELLE"
 *                           totalFacturas:
 *                             type: integer
 *                             example: 5
 *                           totalCantidad:
 *                             type: integer
 *                             example: 5
 *                           totalPrecio:
 *                             type: number
 *                             format: float
 *                             example: 8.25
 *                     estadisticasPorProducto:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           producto_prd_codigo:
 *                             type: integer
 *                             example: 1
 *                           producto_nombre:
 *                             type: string
 *                             example: "Almuerzo"
 *                           totalFacturas:
 *                             type: integer
 *                             example: 60
 *                           totalCantidad:
 *                             type: integer
 *                             example: 60
 *                           totalPrecio:
 *                             type: number
 *                             format: float
 *                             example: 99.00
 *           text/csv:
 *             schema:
 *               type: string
 *             description: Datos en formato CSV (cuando formato=csv)
 *       400:
 *         description: Parámetros inválidos
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Las fechas de inicio y fin son requeridas"
 *       500:
 *         description: Error interno del servidor
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Error interno del servidor"
 */

// Función para convertir datos a formato CSV
function convertirACSV(facturas) {
    if (!facturas || facturas.length === 0) {
        return 'No hay datos para mostrar';
    }

    // Definir las columnas del CSV
    const columnas = [
        'Código Factura',
        'Código Empleado',
        'Nombres',
        'Apellidos',
        'Cédula',
        'Correo',
        'Fecha',
        'Centro de Costo',
        'Departamento',
        'Labor',
        'Cantidad',
        'Descuento',
        'Precio Empleado',
        'Código Producto',
        'Nombre Producto'
    ];

    // Crear la línea de encabezados
    let csv = columnas.join(',') + '\n';

    // Agregar cada fila de datos
    facturas.forEach(factura => {
        const fila = [
            factura.fac_cab_codigo || '',
            factura.emp_codigo || '',
            `"${factura.emp_nombres || ''}"`,
            `"${factura.emp_apellidos || ''}"`,
            factura.emp_cedula || '',
            factura.emp_correo || '',
            factura.fac_cab_fecha || '',
            factura.emp_centro_costo || '',
            factura.emp_departamento || '',
            factura.emp_labor || '',
            factura.fac_cab_cantidad || '',
            factura.fac_cab_descuento || '',
            factura.fac_cab_precio_empleado || '',
            factura.producto_prd_codigo || '',
            `"${factura.producto_nombre || ''}"`
        ];
        csv += fila.join(',') + '\n';
    });

    return csv;
}

// Endpoint para generar reporte por rango de fechas
router.get('/rango-fechas', async (req, res) => {
    try {
        const { fechaInicio, fechaFin, formato = 'json' } = req.query;

        // Validar parámetros requeridos
        if (!fechaInicio || !fechaFin) {
            return res.status(400).json({
                success: false,
                message: 'Las fechas de inicio y fin son requeridas'
            });
        }

        // Validar formato de fechas
        const fechaInicioDate = new Date(fechaInicio);
        const fechaFinDate = new Date(fechaFin);

        if (isNaN(fechaInicioDate.getTime()) || isNaN(fechaFinDate.getTime())) {
            return res.status(400).json({
                success: false,
                message: 'Formato de fecha inválido. Use YYYY-MM-DD'
            });
        }

        if (fechaInicioDate > fechaFinDate) {
            return res.status(400).json({
                success: false,
                message: 'La fecha de inicio no puede ser mayor a la fecha de fin'
            });
        }

        // Consulta principal para obtener facturas con información de productos
        const [facturas] = await pool.execute(`
            SELECT 
                fc.fac_cab_codigo,
                fc.emp_codigo,
                fc.emp_nombres,
                fc.emp_apellidos,
                fc.emp_cedula,
                fc.emp_correo,
                fc.fac_cab_fecha,
                fc.emp_centro_costo,
                fc.emp_departamento,
                fc.emp_labor,
                fc.fac_cab_cantidad,
                fc.fac_cab_descuento,
                fc.fac_cab_precio_empleado,
                fc.producto_prd_codigo,
                p.prd_nombre as producto_nombre
            FROM factura_cabecera fc
            LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
            WHERE DATE(fc.fac_cab_fecha) BETWEEN ? AND ?
            ORDER BY fc.fac_cab_fecha ASC, fc.emp_nombres ASC
        `, [fechaInicio, fechaFin]);

        // Si el formato es CSV, devolver texto plano
        if (formato === 'csv') {
            const csvData = convertirACSV(facturas);
            res.setHeader('Content-Type', 'text/csv');
            res.setHeader('Content-Disposition', `attachment; filename="reporte_facturas_${fechaInicio}_${fechaFin}.csv"`);
            return res.send(csvData);
        }

        // Consulta para resumen general
        const [resumenResult] = await pool.execute(`
            SELECT 
                COUNT(*) as totalFacturas,
                SUM(fac_cab_cantidad) as totalCantidad,
                SUM(fac_cab_precio_empleado) as totalPrecio,
                SUM(fac_cab_descuento) as totalDescuento,
                AVG(fac_cab_precio_empleado) as promedioPrecio,
                COUNT(DISTINCT emp_codigo) as empleadosUnicos,
                COUNT(DISTINCT producto_prd_codigo) as productosUnicos
            FROM factura_cabecera
            WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
        `, [fechaInicio, fechaFin]);

        // Consulta para estadísticas por día
        const [estadisticasPorDia] = await pool.execute(`
            SELECT 
                DATE(fac_cab_fecha) as fecha,
                COUNT(*) as totalFacturas,
                SUM(fac_cab_cantidad) as totalCantidad,
                SUM(fac_cab_precio_empleado) as totalPrecio
            FROM factura_cabecera
            WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
            GROUP BY DATE(fac_cab_fecha)
            ORDER BY fecha ASC
        `, [fechaInicio, fechaFin]);

        // Consulta para estadísticas por empleado
        const [estadisticasPorEmpleado] = await pool.execute(`
            SELECT 
                emp_codigo,
                emp_nombres,
                emp_apellidos,
                COUNT(*) as totalFacturas,
                SUM(fac_cab_cantidad) as totalCantidad,
                SUM(fac_cab_precio_empleado) as totalPrecio
            FROM factura_cabecera
            WHERE DATE(fac_cab_fecha) BETWEEN ? AND ?
            GROUP BY emp_codigo, emp_nombres, emp_apellidos
            ORDER BY totalPrecio DESC
        `, [fechaInicio, fechaFin]);

        // Consulta para estadísticas por producto
        const [estadisticasPorProducto] = await pool.execute(`
            SELECT 
                fc.producto_prd_codigo,
                p.prd_nombre as producto_nombre,
                COUNT(*) as totalFacturas,
                SUM(fc.fac_cab_cantidad) as totalCantidad,
                SUM(fc.fac_cab_precio_empleado) as totalPrecio
            FROM factura_cabecera fc
            LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
            WHERE DATE(fc.fac_cab_fecha) BETWEEN ? AND ?
            GROUP BY fc.producto_prd_codigo, p.prd_nombre
            ORDER BY totalPrecio DESC
        `, [fechaInicio, fechaFin]);

        // Preparar respuesta según formato
        let response;
        if (formato === 'resumen') {
            response = {
                success: true,
                message: 'Resumen del reporte generado exitosamente',
                data: {
                    resumen: resumenResult[0],
                    estadisticasPorDia,
                    estadisticasPorEmpleado,
                    estadisticasPorProducto
                }
            };
        } else if (formato === 'excel') {
            // Formato similar a Excel para exportación
            response = {
                success: true,
                message: 'Datos preparados para exportación a Excel',
                data: {
                    facturas: facturas.map(f => ({
                        fecha: f.fac_cab_fecha,
                        tipo: f.producto_nombre,
                        empleado: `${f.emp_nombres} ${f.emp_apellidos}`,
                        codigo: f.emp_codigo,
                        cantidad: f.fac_cab_cantidad,
                        precio: f.fac_cab_precio_empleado,
                        descuento: f.fac_cab_descuento,
                        centro_costo: f.emp_centro_costo,
                        departamento: f.emp_departamento,
                        labor: f.emp_labor
                    })),
                    resumen: resumenResult[0],
                    estadisticasPorDia,
                    estadisticasPorEmpleado,
                    estadisticasPorProducto
                }
            };
        } else {
            // Formato JSON completo
            response = {
                success: true,
                message: 'Reporte generado exitosamente',
                data: {
                    facturas,
                    resumen: resumenResult[0],
                    estadisticasPorDia,
                    estadisticasPorEmpleado,
                    estadisticasPorProducto
                }
            };
        }

        res.json(response);

    } catch (error) {
        console.error('Error al generar reporte:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

/**
 * @swagger
 * /api/reportes-facturas/empleado/{codigo}:
 *   get:
 *     summary: Genera reporte de facturas por empleado específico
 *     description: Obtiene todas las facturas de un empleado específico con información detallada
 *     tags: [Reportes Facturas]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: string
 *         description: Código del empleado
 *         example: "123456"
 *       - in: query
 *         name: fechaInicio
 *         required: false
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de inicio (YYYY-MM-DD)
 *         example: "2025-05-19"
 *       - in: query
 *         name: fechaFin
 *         required: false
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de fin (YYYY-MM-DD)
 *         example: "2025-05-23"
 *     responses:
 *       200:
 *         description: Reporte del empleado generado exitosamente
 *       404:
 *         description: Empleado no encontrado
 *       500:
 *         description: Error interno del servidor
 */

// Endpoint para generar reporte por empleado específico
router.get('/empleado/:codigo', async (req, res) => {
    try {
        const { codigo } = req.params;
        const { fechaInicio, fechaFin } = req.query;

        let query = `
            SELECT 
                fc.fac_cab_codigo,
                fc.emp_codigo,
                fc.emp_nombres,
                fc.emp_apellidos,
                fc.emp_cedula,
                fc.emp_correo,
                fc.fac_cab_fecha,
                fc.emp_centro_costo,
                fc.emp_departamento,
                fc.emp_labor,
                fc.fac_cab_cantidad,
                fc.fac_cab_descuento,
                fc.fac_cab_precio_empleado,
                fc.producto_prd_codigo,
                p.prd_nombre as producto_nombre
            FROM factura_cabecera fc
            LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
            WHERE fc.emp_codigo = ?
        `;

        let params = [codigo];

        if (fechaInicio && fechaFin) {
            query += ` AND DATE(fc.fac_cab_fecha) BETWEEN ? AND ?`;
            params.push(fechaInicio, fechaFin);
        }

        query += ` ORDER BY fc.fac_cab_fecha DESC`;

        const [facturas] = await pool.execute(query, params);

        if (facturas.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'No se encontraron facturas para este empleado'
            });
        }

        // Resumen del empleado
        const [resumenEmpleado] = await pool.execute(`
            SELECT 
                COUNT(*) as totalFacturas,
                SUM(fac_cab_cantidad) as totalCantidad,
                SUM(fac_cab_precio_empleado) as totalPrecio,
                SUM(fac_cab_descuento) as totalDescuento,
                AVG(fac_cab_precio_empleado) as promedioPrecio
            FROM factura_cabecera
            WHERE emp_codigo = ?
            ${fechaInicio && fechaFin ? 'AND DATE(fac_cab_fecha) BETWEEN ? AND ?' : ''}
        `, fechaInicio && fechaFin ? [codigo, fechaInicio, fechaFin] : [codigo]);

        res.json({
            success: true,
            message: 'Reporte del empleado generado exitosamente',
            data: {
                empleado: {
                    codigo: facturas[0].emp_codigo,
                    nombres: facturas[0].emp_nombres,
                    apellidos: facturas[0].emp_apellidos,
                    cedula: facturas[0].emp_cedula,
                    correo: facturas[0].emp_correo,
                    centro_costo: facturas[0].emp_centro_costo,
                    departamento: facturas[0].emp_departamento,
                    labor: facturas[0].emp_labor
                },
                facturas,
                resumen: resumenEmpleado[0]
            }
        });

    } catch (error) {
        console.error('Error al generar reporte del empleado:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

module.exports = router; 