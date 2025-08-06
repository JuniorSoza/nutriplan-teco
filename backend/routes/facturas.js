const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/facturas:
 *   get:
 *     summary: Obtener todas las facturas
 *     tags: [Facturas]
 *     parameters:
 *       - in: query
 *         name: fecha
 *         schema:
 *           type: string
 *           format: date
 *         description: Filtrar por fecha (YYYY-MM-DD)
 *       - in: query
 *         name: empleado
 *         schema:
 *           type: string
 *         description: Filtrar por código de empleado
 *     responses:
 *       200:
 *         description: Lista de facturas
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/FacturaCabecera'
 */
router.get('/', async (req, res, next) => {
  try {
    const { fecha, empleado } = req.query;
    let query = `
      SELECT fc.*, p.prd_nombre as producto_nombre 
      FROM factura_cabecera fc 
      LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo
    `;
    let params = [];
    let conditions = [];

    if (fecha) {
      conditions.push('DATE(fc.fac_cab_fecha) = ?');
      params.push(fecha);
    }

    if (empleado) {
      conditions.push('fc.emp_codigo = ?');
      params.push(empleado);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    query += ' ORDER BY fc.fac_cab_fecha DESC';
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/facturas/{codigo}:
 *   get:
 *     summary: Obtener una factura por código
 *     tags: [Facturas]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código de la factura
 *     responses:
 *       200:
 *         description: Factura encontrada
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/FacturaCabecera'
 *       404:
 *         description: Factura no encontrada
 */
router.get('/:codigo', async (req, res, next) => {
  try {
    const { codigo } = req.params;
    const [rows] = await pool.query(`
      SELECT fc.*, p.prd_nombre as producto_nombre 
      FROM factura_cabecera fc 
      LEFT JOIN producto p ON fc.producto_prd_codigo = p.prd_codigo 
      WHERE fc.fac_cab_codigo = ?
    `, [codigo]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Factura no encontrada' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/facturas:
 *   post:
 *     summary: Crear una nueva factura
 *     tags: [Facturas]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/FacturaCabecera'
 *     responses:
 *       201:
 *         description: Factura creada exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/FacturaCabecera'
 */
router.post('/', async (req, res, next) => {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const {
      fac_cab_codigo,
      emp_codigo,
      emp_apellidos,
      emp_cedula,
      emp_correo,
      emp_nombres,
      fac_cab_fecha,
      emp_centro_costo,
      emp_departamento,
      emp_labor,
      fac_cab_cantidad,
      fac_cab_descuento,
      fac_cab_precio_empleado,
      producto_prd_codigo
    } = req.body;

    if (!fac_cab_codigo || !emp_codigo || !emp_nombres || !fac_cab_cantidad || !producto_prd_codigo) {
      return res.status(400).json({ 
        message: 'Código de factura, código de empleado, nombres, cantidad y producto son requeridos' 
      });
    }

    // Verificar que el producto existe
    const [producto] = await connection.query(
      'SELECT prd_codigo FROM producto WHERE prd_codigo = ?',
      [producto_prd_codigo]
    );

    if (producto.length === 0) {
      await connection.rollback();
      return res.status(400).json({ message: 'El producto especificado no existe' });
    }

    const [result] = await connection.query(`
      INSERT INTO factura_cabecera (
        fac_cab_codigo, emp_codigo, emp_apellidos, emp_cedula, emp_correo, 
        emp_nombres, fac_cab_fecha, emp_centro_costo, emp_departamento, 
        emp_labor, fac_cab_cantidad, fac_cab_descuento, fac_cab_precio_empleado, 
        producto_prd_codigo
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      fac_cab_codigo, emp_codigo, emp_apellidos, emp_cedula, emp_correo,
      emp_nombres, fac_cab_fecha, emp_centro_costo, emp_departamento,
      emp_labor, fac_cab_cantidad, fac_cab_descuento || 0, fac_cab_precio_empleado,
      producto_prd_codigo
    ]);

    await connection.commit();

    res.status(201).json({
      fac_cab_codigo,
      emp_codigo,
      emp_nombres,
      fac_cab_cantidad,
      producto_prd_codigo
    });
  } catch (error) {
    await connection.rollback();
    next(error);
  } finally {
    connection.release();
  }
});

/**
 * @swagger
 * /api/facturas/{codigo}:
 *   put:
 *     summary: Actualizar una factura
 *     tags: [Facturas]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código de la factura
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/FacturaCabecera'
 *     responses:
 *       200:
 *         description: Factura actualizada exitosamente
 *       404:
 *         description: Factura no encontrada
 */
router.put('/:codigo', async (req, res, next) => {
  try {
    const { codigo } = req.params;
    const {
      emp_codigo,
      emp_apellidos,
      emp_cedula,
      emp_correo,
      emp_nombres,
      fac_cab_fecha,
      emp_centro_costo,
      emp_departamento,
      emp_labor,
      fac_cab_cantidad,
      fac_cab_descuento,
      fac_cab_precio_empleado,
      producto_prd_codigo
    } = req.body;

    if (!emp_codigo || !emp_nombres || !fac_cab_cantidad || !producto_prd_codigo) {
      return res.status(400).json({ 
        message: 'Código de empleado, nombres, cantidad y producto son requeridos' 
      });
    }

    const [result] = await pool.query(`
      UPDATE factura_cabecera SET 
        emp_codigo = ?, emp_apellidos = ?, emp_cedula = ?, emp_correo = ?,
        emp_nombres = ?, fac_cab_fecha = ?, emp_centro_costo = ?, emp_departamento = ?,
        emp_labor = ?, fac_cab_cantidad = ?, fac_cab_descuento = ?, 
        fac_cab_precio_empleado = ?, producto_prd_codigo = ?
      WHERE fac_cab_codigo = ?
    `, [
      emp_codigo, emp_apellidos, emp_cedula, emp_correo,
      emp_nombres, fac_cab_fecha, emp_centro_costo, emp_departamento,
      emp_labor, fac_cab_cantidad, fac_cab_descuento || 0, fac_cab_precio_empleado,
      producto_prd_codigo, codigo
    ]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Factura no encontrada' });
    }

    res.json({ 
      fac_cab_codigo: parseInt(codigo),
      emp_codigo,
      emp_nombres,
      fac_cab_cantidad,
      producto_prd_codigo
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/facturas/{codigo}:
 *   delete:
 *     summary: Eliminar una factura
 *     tags: [Facturas]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código de la factura
 *     responses:
 *       200:
 *         description: Factura eliminada exitosamente
 *       404:
 *         description: Factura no encontrada
 */
router.delete('/:codigo', async (req, res, next) => {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const { codigo } = req.params;

    const [result] = await connection.query(
      'DELETE FROM factura_cabecera WHERE fac_cab_codigo = ?',
      [codigo]
    );

    if (result.affectedRows === 0) {
      await connection.rollback();
      return res.status(404).json({ message: 'Factura no encontrada' });
    }

    await connection.commit();
    res.json({ message: 'Factura eliminada exitosamente' });
  } catch (error) {
    await connection.rollback();
    next(error);
  } finally {
    connection.release();
  }
});

module.exports = router; 