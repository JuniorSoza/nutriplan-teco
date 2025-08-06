const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/reportes:
 *   get:
 *     summary: Obtener todos los reportes
 *     tags: [Reportes]
 *     parameters:
 *       - in: query
 *         name: fecha
 *         schema:
 *           type: string
 *           format: date
 *         description: Filtrar por fecha (YYYY-MM-DD)
 *       - in: query
 *         name: tipo
 *         schema:
 *           type: string
 *         description: Filtrar por tipo de reporte
 *       - in: query
 *         name: empleado
 *         schema:
 *           type: string
 *         description: Filtrar por código de empleado
 *     responses:
 *       200:
 *         description: Lista de reportes
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Reporte'
 */
router.get('/', async (req, res, next) => {
  try {
    const { fecha, tipo, empleado } = req.query;
    let query = 'SELECT * FROM reporte';
    let params = [];
    let conditions = [];

    if (fecha) {
      conditions.push('DATE(fecha) = ?');
      params.push(fecha);
    }

    if (tipo) {
      conditions.push('tipo = ?');
      params.push(tipo);
    }

    if (empleado) {
      conditions.push('empleado_codigo = ?');
      params.push(empleado);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    query += ' ORDER BY fecha DESC';
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/reportes/{id}:
 *   get:
 *     summary: Obtener un reporte por ID
 *     tags: [Reportes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del reporte
 *     responses:
 *       200:
 *         description: Reporte encontrado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Reporte'
 *       404:
 *         description: Reporte no encontrado
 */
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query('SELECT * FROM reporte WHERE id = ?', [id]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/reportes:
 *   post:
 *     summary: Crear un nuevo reporte
 *     tags: [Reportes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Reporte'
 *     responses:
 *       201:
 *         description: Reporte creado exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Reporte'
 */
router.post('/', async (req, res, next) => {
  try {
    const {
      empleado_codigo,
      empleado,
      fecha,
      tipo,
      factura,
      cantidad,
      centro_costo,
      departamento,
      descuento,
      labor,
      nombres,
      precio_empleado,
      codigo
    } = req.body;

    const [result] = await pool.query(`
      INSERT INTO reporte (
        empleado_codigo, empleado, fecha, tipo, factura, cantidad,
        centro_costo, departamento, descuento, labor, nombres,
        precio_empleado, codigo
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      empleado_codigo, empleado, fecha, tipo, factura, cantidad,
      centro_costo, departamento, descuento || 0, labor, nombres,
      precio_empleado, codigo
    ]);

    res.status(201).json({
      id: result.insertId,
      empleado_codigo,
      empleado,
      fecha,
      tipo
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/reportes/{id}:
 *   put:
 *     summary: Actualizar un reporte
 *     tags: [Reportes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del reporte
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Reporte'
 *     responses:
 *       200:
 *         description: Reporte actualizado exitosamente
 *       404:
 *         description: Reporte no encontrado
 */
router.put('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const {
      empleado_codigo,
      empleado,
      fecha,
      tipo,
      factura,
      cantidad,
      centro_costo,
      departamento,
      descuento,
      labor,
      nombres,
      precio_empleado,
      codigo
    } = req.body;

    const [result] = await pool.query(`
      UPDATE reporte SET 
        empleado_codigo = ?, empleado = ?, fecha = ?, tipo = ?, factura = ?,
        cantidad = ?, centro_costo = ?, departamento = ?, descuento = ?,
        labor = ?, nombres = ?, precio_empleado = ?, codigo = ?
      WHERE id = ?
    `, [
      empleado_codigo, empleado, fecha, tipo, factura, cantidad,
      centro_costo, departamento, descuento || 0, labor, nombres,
      precio_empleado, codigo, id
    ]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }

    res.json({
      id: parseInt(id),
      empleado_codigo,
      empleado,
      fecha,
      tipo
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/reportes/{id}:
 *   delete:
 *     summary: Eliminar un reporte
 *     tags: [Reportes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del reporte
 *     responses:
 *       200:
 *         description: Reporte eliminado exitosamente
 *       404:
 *         description: Reporte no encontrado
 */
router.delete('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query('DELETE FROM reporte WHERE id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Reporte no encontrado' });
    }
    
    res.json({ message: 'Reporte eliminado exitosamente' });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/reportes/estadisticas:
 *   get:
 *     summary: Obtener estadísticas de reportes
 *     tags: [Reportes]
 *     parameters:
 *       - in: query
 *         name: fecha_inicio
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de inicio para las estadísticas
 *       - in: query
 *         name: fecha_fin
 *         schema:
 *           type: string
 *           format: date
 *         description: Fecha de fin para las estadísticas
 *     responses:
 *       200:
 *         description: Estadísticas de reportes
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 total_reportes:
 *                   type: integer
 *                 total_cantidad:
 *                   type: integer
 *                 promedio_precio:
 *                   type: number
 *                 por_tipo:
 *                   type: object
 */
router.get('/estadisticas', async (req, res, next) => {
  try {
    const { fecha_inicio, fecha_fin } = req.query;
    let whereClause = '';
    let params = [];

    if (fecha_inicio && fecha_fin) {
      whereClause = 'WHERE fecha BETWEEN ? AND ?';
      params = [fecha_inicio, fecha_fin];
    }

    // Total de reportes
    const [totalReportes] = await pool.query(
      `SELECT COUNT(*) as total FROM reporte ${whereClause}`,
      params
    );

    // Total de cantidad
    const [totalCantidad] = await pool.query(
      `SELECT SUM(cantidad) as total FROM reporte ${whereClause}`,
      params
    );

    // Promedio de precio
    const [promedioPrecio] = await pool.query(
      `SELECT AVG(precio_empleado) as promedio FROM reporte ${whereClause}`,
      params
    );

    // Reportes por tipo
    const [porTipo] = await pool.query(
      `SELECT tipo, COUNT(*) as cantidad FROM reporte ${whereClause} GROUP BY tipo`,
      params
    );

    res.json({
      total_reportes: totalReportes[0].total,
      total_cantidad: totalCantidad[0].total || 0,
      promedio_precio: promedioPrecio[0].promedio || 0,
      por_tipo: porTipo
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router; 