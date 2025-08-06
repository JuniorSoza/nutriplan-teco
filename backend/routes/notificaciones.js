const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');

/**
 * @swagger
 * /api/notificaciones:
 *   get:
 *     summary: Obtener todas las notificaciones
 *     tags: [Notificaciones]
 *     responses:
 *       200:
 *         description: Lista de notificaciones
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Notificacion'
 */
router.get('/', async (req, res, next) => {
  try {
    const [rows] = await pool.query('SELECT * FROM notificacion ORDER BY id DESC');
    res.json(rows);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/notificaciones/{id}:
 *   get:
 *     summary: Obtener una notificación por ID
 *     tags: [Notificaciones]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la notificación
 *     responses:
 *       200:
 *         description: Notificación encontrada
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Notificacion'
 *       404:
 *         description: Notificación no encontrada
 */
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query('SELECT * FROM notificacion WHERE id = ?', [id]);
    
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Notificación no encontrada' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/notificaciones:
 *   post:
 *     summary: Crear una nueva notificación
 *     tags: [Notificaciones]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Notificacion'
 *     responses:
 *       201:
 *         description: Notificación creada exitosamente
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Notificacion'
 */
router.post('/', async (req, res, next) => {
  try {
    const { id, mensaje } = req.body;
    
    if (!id || !mensaje) {
      return res.status(400).json({ message: 'ID y mensaje son requeridos' });
    }
    
    const [result] = await pool.query(
      'INSERT INTO notificacion (id, mensaje) VALUES (?, ?)',
      [id, mensaje]
    );
    
    res.status(201).json({ id, mensaje });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/notificaciones/{id}:
 *   put:
 *     summary: Actualizar una notificación
 *     tags: [Notificaciones]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la notificación
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Notificacion'
 *     responses:
 *       200:
 *         description: Notificación actualizada exitosamente
 *       404:
 *         description: Notificación no encontrada
 */
router.put('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const { mensaje } = req.body;
    
    if (!mensaje) {
      return res.status(400).json({ message: 'Mensaje es requerido' });
    }
    
    const [result] = await pool.query(
      'UPDATE notificacion SET mensaje = ? WHERE id = ?',
      [mensaje, id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Notificación no encontrada' });
    }
    
    res.json({ id: parseInt(id), mensaje });
  } catch (error) {
    next(error);
  }
});

/**
 * @swagger
 * /api/notificaciones/{id}:
 *   delete:
 *     summary: Eliminar una notificación
 *     tags: [Notificaciones]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la notificación
 *     responses:
 *       200:
 *         description: Notificación eliminada exitosamente
 *       404:
 *         description: Notificación no encontrada
 */
router.delete('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query('DELETE FROM notificacion WHERE id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Notificación no encontrada' });
    }
    
    res.json({ message: 'Notificación eliminada exitosamente' });
  } catch (error) {
    next(error);
  }
});

module.exports = router; 