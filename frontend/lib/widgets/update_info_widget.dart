import 'package:flutter/material.dart';

class UpdateInfoWidget extends StatefulWidget {
  const UpdateInfoWidget({super.key});

  @override
  State<UpdateInfoWidget> createState() => _UpdateInfoWidgetState();
}

class _UpdateInfoWidgetState extends State<UpdateInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.update, size: 32, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              'Actualizar Información',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actualización de Datos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildUpdateOption(
                          'Actualizar Empleados',
                          Icons.person,
                          'Sincronizar información de empleados desde el sistema externo',
                          Colors.blue,
                        ),
                        _buildUpdateOption(
                          'Actualizar Productos',
                          Icons.inventory,
                          'Modificar catálogo de productos y precios',
                          Colors.green,
                        ),
                        _buildUpdateOption(
                          'Actualizar Precios',
                          Icons.attach_money,
                          'Actualizar precios de productos y servicios',
                          Colors.orange,
                        ),
                        _buildUpdateOption(
                          'Actualizar Configuración',
                          Icons.settings,
                          'Modificar configuraciones del sistema',
                          Colors.purple,
                        ),
                        _buildUpdateOption(
                          'Sincronizar Datos',
                          Icons.sync,
                          'Sincronizar todos los datos con el servidor',
                          Colors.teal,
                        ),
                        _buildUpdateOption(
                          'Respaldar Sistema',
                          Icons.backup,
                          'Crear respaldo completo de la base de datos',
                          Colors.indigo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateOption(
    String title,
    IconData icon,
    String description,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_forward_ios, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                'Actualizar',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // TODO: Implementar funcionalidad específica de actualización
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Iniciando actualización: $title'),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Ver Detalles',
                textColor: Colors.white,
                onPressed: () {
                  _showUpdateDetails(title, description);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 16),
              const Text(
                'Esta funcionalidad está en desarrollo y será implementada próximamente.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
