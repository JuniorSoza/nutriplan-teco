import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecentMovementsWidget extends StatefulWidget {
  const RecentMovementsWidget({super.key});

  @override
  State<RecentMovementsWidget> createState() => _RecentMovementsWidgetState();
}

class _RecentMovementsWidgetState extends State<RecentMovementsWidget> {
  // Variables para las últimas facturas
  List<Map<String, dynamic>> _ultimasFacturas = [];
  bool _isLoadingFacturas = false;

  @override
  void initState() {
    super.initState();
    _cargarUltimasFacturas();
  }

  // Cargar las últimas facturas
  Future<void> _cargarUltimasFacturas() async {
    setState(() {
      _isLoadingFacturas = true;
    });

    try {
      final facturas = await ApiService.getUltimasFacturas();
      setState(() {
        _ultimasFacturas = facturas;
        _isLoadingFacturas = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFacturas = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar últimas facturas: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Eliminar una factura
  Future<void> _eliminarFactura(String facturaId) async {
    try {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar esta factura?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );

      if (confirmacion == true) {
        await ApiService.eliminarFactura(facturaId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Factura eliminada exitosamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Recargar las últimas facturas
        await _cargarUltimasFacturas();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al eliminar factura: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Widget para mostrar un item de factura con toda la información
  Widget _buildFacturaItem(Map<String, dynamic> factura) {
    final fecha =
        DateTime.tryParse(factura['fac_cab_fecha'] ?? '') ?? DateTime.now();
    final fechaFormateada =
        '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            factura['emp_codigo']?.toString().substring(0, 2) ?? '??',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${factura['emp_nombres'] ?? ''} ${factura['emp_apellidos'] ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Producto: ${factura['producto_nombre'] ?? ''} - Cantidad: ${factura['fac_cab_cantidad'] ?? ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  _eliminarFactura(factura['fac_cab_codigo']?.toString() ?? ''),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Eliminar registro',
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información de la factura
                _buildInfoSection(
                  'Información de Factura',
                  Icons.receipt,
                  Colors.blue,
                  [
                    _buildInfoRow(
                      'Código Factura',
                      factura['fac_cab_codigo']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow('Fecha', fechaFormateada),
                    _buildInfoRow(
                      'Cantidad',
                      factura['fac_cab_cantidad']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Descuento',
                      factura['fac_cab_descuento']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Precio Empleado',
                      factura['fac_cab_precio_empleado']?.toString() ?? 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Información del empleado
                _buildInfoSection(
                  'Información del Empleado',
                  Icons.person,
                  Colors.green,
                  [
                    _buildInfoRow(
                      'Código',
                      factura['emp_codigo']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Nombres',
                      factura['emp_nombres']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Apellidos',
                      factura['emp_apellidos']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Cédula',
                      factura['emp_cedula']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Correo',
                      factura['emp_correo']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Centro de Costo',
                      factura['emp_centro_costo']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Departamento',
                      factura['emp_departamento']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Labor',
                      factura['emp_labor']?.toString() ?? 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Información del producto
                _buildInfoSection(
                  'Información del Producto',
                  Icons.restaurant_menu,
                  Colors.orange,
                  [
                    _buildInfoRow(
                      'Código Producto',
                      factura['producto_prd_codigo']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Nombre Producto',
                      factura['producto_nombre']?.toString() ?? 'N/A',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir una sección de información
  Widget _buildInfoSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Widget para construir una fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, size: 32, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              'Últimos Movimientos',
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
                  Row(
                    children: [
                      const Icon(Icons.history, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Últimos 10 Registros (Información Completa)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _isLoadingFacturas
                            ? null
                            : _cargarUltimasFacturas,
                        icon: _isLoadingFacturas
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        tooltip: 'Actualizar lista',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isLoadingFacturas)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_ultimasFacturas.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No hay registros recientes',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _ultimasFacturas.length,
                        itemBuilder: (context, index) {
                          return _buildFacturaItem(_ultimasFacturas[index]);
                        },
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
}
