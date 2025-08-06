const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/productos:
 *   get:
 *     summary: Obtener todos los productos
 *     tags: [Productos]
 *     parameters:
 *       - in: query
 *         name: nombre
 *         schema:
 *           type: string
 *         description: Filtrar por nombre del producto
 *     responses:
 *       200:
 *         description: Lista de productos
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Producto'
 */
router.get('/', async (req, res, next) => {
  try {
    const { nombre } = req.query;
    let query = 'SELECT * FROM producto';
    let params = [];

    if (nombre) {
      query += ' WHERE prd_nombre LIKE ?';
      params.push(`%${nombre}%`);
    }

    query += ' ORDER BY prd_codigo';
    const [rows] = await pool.query(query, params);
    res.json(rows);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/productos/{codigo}:
 *   get:
 *     summary: Obtener un producto por código
 *     tags: [Productos]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código del producto
 *     responses:
 *       200:
 *         description: Producto encontrado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Producto'
 *       404:
 *         description: Producto no encontrado
 */
router.get('/:codigo', async (req, res, next) => {
  try {
    const { codigo } = req.params;
    const [rows] = await pool.query('SELECT * FROM producto WHERE prd_codigo = ?', [codigo]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/productos:
 *   post:
 *     summary: Crear un nuevo producto
 *     tags: [Productos]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Producto'
 *     responses:
 *       201:
 *         description: Producto creado exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Producto'
 */
router.post('/', async (req, res, next) => {
  try {
    const { prd_codigo, prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion } = req.body;
    
    if (!prd_codigo || !prd_nombre) {
      return res.status(400).json({ message: 'Código y nombre son requeridos' });
    }
    
    const [result] = await pool.query(
      'INSERT INTO producto (prd_codigo, prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion) VALUES (?, ?, ?, ?, ?)',
      [prd_codigo, prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion]
    );
    
    res.status(201).json({ prd_codigo, prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/productos/{codigo}:
 *   put:
 *     summary: Actualizar un producto
 *     tags: [Productos]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código del producto
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Producto'
 *     responses:
 *       200:
 *         description: Producto actualizado exitosamente
 *       404:
 *         description: Producto no encontrado
 */
router.put('/:codigo', async (req, res, next) => {
  try {
    const { codigo } = req.params;
    const { prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion } = req.body;
    
    if (!prd_nombre) {
      return res.status(400).json({ message: 'Nombre es requerido' });
    }
    
    const [result] = await pool.query(
      'UPDATE producto SET prd_descripcion = ?, prd_imagen = ?, prd_nombre = ?, prd_ubicacion = ? WHERE prd_codigo = ?',
      [prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion, codigo]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json({ prd_codigo: parseInt(codigo), prd_descripcion, prd_imagen, prd_nombre, prd_ubicacion });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/productos/{codigo}:
 *   delete:
 *     summary: Eliminar un producto
 *     tags: [Productos]
 *     parameters:
 *       - in: path
 *         name: codigo
 *         required: true
 *         schema:
 *           type: integer
 *         description: Código del producto
 *     responses:
 *       200:
 *         description: Producto eliminado exitosamente
 *       404:
 *         description: Producto no encontrado
 */
router.delete('/:codigo', async (req, res, next) => {
  try {
    const { codigo } = req.params;
    
    // Verificar si el producto está siendo usado en facturas
    const [facturas] = await pool.query(
      'SELECT COUNT(*) as count FROM factura_cabecera WHERE producto_prd_codigo = ?',
      [codigo]
    );
    
    if (facturas[0].count > 0) {
      return res.status(400).json({ 
        message: 'No se puede eliminar el producto porque está siendo usado en facturas' 
      });
    }
    
    const [result] = await pool.query('DELETE FROM producto WHERE prd_codigo = ?', [codigo]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json({ message: 'Producto eliminado exitosamente' });
  } catch (error) {
    next(error);
  }
});

module.exports = router; 