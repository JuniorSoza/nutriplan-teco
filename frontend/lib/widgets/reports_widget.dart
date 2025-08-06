import 'package:flutter/material.dart';

class ReportsWidget extends StatefulWidget {
  const ReportsWidget({super.key});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assessment, size: 32, color: Colors.purple),
            const SizedBox(width: 12),
            Text(
              'Generar Reportes',
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
                    'Reportes Disponibles',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildReportCard(
                          'Reporte Diario',
                          Icons.today,
                          Colors.blue,
                          'Genera un reporte de todas las transacciones del día actual',
                        ),
                        _buildReportCard(
                          'Reporte Semanal',
                          Icons.date_range,
                          Colors.green,
                          'Reporte semanal con resumen de productos más vendidos',
                        ),
                        _buildReportCard(
                          'Reporte Mensual',
                          Icons.calendar_month,
                          Colors.orange,
                          'Análisis mensual completo de ventas y empleados',
                        ),
                        _buildReportCard(
                          'Reporte por Empleado',
                          Icons.person,
                          Colors.purple,
                          'Reporte detallado de consumo por empleado',
                        ),
                        _buildReportCard(
                          'Reporte de Productos',
                          Icons.inventory,
                          Colors.red,
                          'Análisis de productos más y menos consumidos',
                        ),
                        _buildReportCard(
                          'Reporte de Costos',
                          Icons.attach_money,
                          Colors.teal,
                          'Análisis de costos y gastos del sistema',
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

  Widget _buildReportCard(
    String title,
    IconData icon,
    Color color,
    String description,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Implementar generación de reporte específico
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Generando reporte: $title'),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Generar',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
