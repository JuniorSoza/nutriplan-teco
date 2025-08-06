const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/biometricos:
 *   get:
 *     summary: Obtener todos los registros biométricos
 *     tags: [Biométricos]
 *     responses:
 *       200:
 *         description: Lista de registros biométricos
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Biometrico'
 */
router.get('/', async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM biometrico ORDER BY bio_tarjeta');
    res.json(rows);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/biometricos/{tarjeta}:
 *   get:
 *     summary: Obtener un registro biométrico por tarjeta
 *     tags: [Biométricos]
 *     parameters:
 *       - in: path
 *         name: tarjeta
 *         required: true
 *         schema:
 *           type: string
 *         description: Número de tarjeta biométrica
 *     responses:
 *       200:
 *         description: Registro biométrico encontrado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Biometrico'
 *       404:
 *         description: Registro biométrico no encontrado
 */
router.get('/:tarjeta', async (req, res, next) => {
  try {
    const { tarjeta } = req.params;
    const [rows] = await pool.query('SELECT * FROM biometrico WHERE bio_tarjeta = ?', [tarjeta]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Registro biométrico no encontrado' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/biometricos:
 *   post:
 *     summary: Crear un nuevo registro biométrico
 *     tags: [Biométricos]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Biometrico'
 *     responses:
 *       201:
 *         description: Registro biométrico creado exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Biometrico'
 */
router.post('/', async (req, res, next) => {
  try {
    const { bio_tarjeta, bio_huella } = req.body;
    
    if (!bio_tarjeta || !bio_huella) {
      return res.status(400).json({ message: 'Tarjeta y huella son requeridos' });
    }
    
    const [result] = await pool.query(
      'INSERT INTO biometrico (bio_tarjeta, bio_huella) VALUES (?, ?)',
      [bio_tarjeta, bio_huella]
    );
    
    res.status(201).json({ bio_tarjeta, bio_huella });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/biometricos/{tarjeta}:
 *   put:
 *     summary: Actualizar un registro biométrico
 *     tags: [Biométricos]
 *     parameters:
 *       - in: path
 *         name: tarjeta
 *         required: true
 *         schema:
 *           type: string
 *         description: Número de tarjeta biométrica
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Biometrico'
 *     responses:
 *       200:
 *         description: Registro biométrico actualizado exitosamente
 *       404:
 *         description: Registro biométrico no encontrado
 */
router.put('/:tarjeta', async (req, res, next) => {
  try {
    const { tarjeta } = req.params;
    const { bio_huella } = req.body;
    
    if (!bio_huella) {
      return res.status(400).json({ message: 'Huella es requerida' });
    }
    
    const [result] = await pool.query(
      'UPDATE biometrico SET bio_huella = ? WHERE bio_tarjeta = ?',
      [bio_huella, tarjeta]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Registro biométrico no encontrado' });
    }
    
    res.json({ bio_tarjeta: tarjeta, bio_huella });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/biometricos/{tarjeta}:
 *   delete:
 *     summary: Eliminar un registro biométrico
 *     tags: [Biométricos]
 *     parameters:
 *       - in: path
 *         name: tarjeta
 *         required: true
 *         schema:
 *           type: string
 *         description: Número de tarjeta biométrica
 *     responses:
 *       200:
 *         description: Registro biométrico eliminado exitosamente
 *       404:
 *         description: Registro biométrico no encontrado
 */
router.delete('/:tarjeta', async (req, res, next) => {
  try {
    const { tarjeta } = req.params;
    const [result] = await pool.query('DELETE FROM biometrico WHERE bio_tarjeta = ?', [tarjeta]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Registro biométrico no encontrado' });
    }
    
    res.json({ message: 'Registro biométrico eliminado exitosamente' });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/biometricos/verificar/{tarjeta}:
 *   post:
 *     summary: Verificar huella biométrica
 *     tags: [Biométricos]
 *     parameters:
 *       - in: path
 *         name: tarjeta
 *         required: true
 *         schema:
 *           type: string
 *         description: Número de tarjeta biométrica
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               bio_huella:
 *                 type: string
 *                 description: Huella a verificar
 *     responses:
 *       200:
 *         description: Resultado de la verificación
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 coincidencia:
 *                   type: boolean
 *                 mensaje:
 *                   type: string
 *       404:
 *         description: Tarjeta no encontrada
 */
router.post('/verificar/:tarjeta', async (req, res, next) => {
  try {
    const { tarjeta } = req.params;
    const { bio_huella } = req.body;
    
    if (!bio_huella) {
      return res.status(400).json({ message: 'Huella es requerida para la verificación' });
    }
    
    const [rows] = await pool.query(
      'SELECT bio_huella FROM biometrico WHERE bio_tarjeta = ?',
      [tarjeta]
    );
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Tarjeta no encontrada' });
    }
    
    const huellaAlmacenada = rows[0].bio_huella;
    const coincidencia = huellaAlmacenada === bio_huella;
    
    res.json({
      coincidencia,
      mensaje: coincidencia ? 'Huella verificada correctamente' : 'Huella no coincide'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router; 