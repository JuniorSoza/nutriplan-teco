import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../services/reportes_service.dart';
import '../services/export_service.dart';

class ReportsWidget extends StatefulWidget {
  const ReportsWidget({super.key});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  List<PlutoRow> _rows = [];
  bool _isLoading = false;
  String _selectedReportType = 'rango_fechas';

  // Controllers para fechas
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();
  final TextEditingController _codigoEmpleadoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // Establecer fechas por defecto (últimos 7 días)
    final now = DateTime.now();
    _fechaInicioController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(now.subtract(const Duration(days: 7)));
    _fechaFinController.text = DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  void dispose() {
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    _codigoEmpleadoController.dispose();
    super.dispose();
  }

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
                  _buildReportControls(),
                  const SizedBox(height: 16),
                  _buildExportButtons(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildDataTable()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuración del Reporte',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Tipo de reporte
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedReportType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Reporte',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'rango_fechas',
                    child: Text('Reporte por Rango de Fechas'),
                  ),
                  DropdownMenuItem(
                    value: 'empleado',
                    child: Text('Reporte por Empleado'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generarReporte,
              icon: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.search),
              label: Text(_isLoading ? 'Generando...' : 'Generar Reporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Campos específicos según el tipo de reporte
        if (_selectedReportType == 'rango_fechas') ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fechaInicioController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_fechaInicioController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _fechaFinController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Fin',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_fechaFinController),
                ),
              ),
            ],
          ),
        ] else ...[
          TextFormField(
            controller: _codigoEmpleadoController,
            decoration: const InputDecoration(
              labelText: 'Código de Empleado',
              border: OutlineInputBorder(),
              hintText: 'Ej: 123456',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fechaInicioController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Inicio (Opcional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_fechaInicioController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _fechaFinController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Fin (Opcional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(_fechaFinController),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildExportButtons() {
    if (_rows.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Text(
          'Exportar Reporte:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _exportarAExcel,
          icon: Icon(Icons.table_chart),
          label: Text('Excel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _exportarAPDF,
          icon: Icon(Icons.picture_as_pdf),
          label: Text('PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          'Total registros: ${_rows.length}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    if (_rows.isEmpty && !_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_chart_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay datos para mostrar',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Genera un reporte para ver los datos',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return PlutoGrid(
      columns: _getColumns(),
      rows: _rows,
      configuration: const PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
        style: PlutoGridStyleConfig(
          gridBorderColor: Colors.grey,
          gridBackgroundColor: Colors.white,
          rowHeight: 50,
        ),
      ),
    );
  }

  List<PlutoColumn> _getColumns() {
    return [
      PlutoColumn(
        title: 'Código Factura',
        field: 'fac_cab_codigo',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Código Empleado',
        field: 'emp_codigo',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Nombres',
        field: 'emp_nombres',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Apellidos',
        field: 'emp_apellidos',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Cédula',
        field: 'emp_cedula',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Correo',
        field: 'emp_correo',
        type: PlutoColumnType.text(),
        width: 200,
      ),
      PlutoColumn(
        title: 'Fecha',
        field: 'fac_cab_fecha',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Centro de Costo',
        field: 'emp_centro_costo',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Departamento',
        field: 'emp_departamento',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Labor',
        field: 'emp_labor',
        type: PlutoColumnType.text(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Cantidad',
        field: 'fac_cab_cantidad',
        type: PlutoColumnType.number(),
        width: 80,
      ),
      PlutoColumn(
        title: 'Descuento',
        field: 'fac_cab_descuento',
        type: PlutoColumnType.number(),
        width: 100,
      ),
      PlutoColumn(
        title: 'Precio Empleado',
        field: 'fac_cab_precio_empleado',
        type: PlutoColumnType.number(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Código Producto',
        field: 'producto_prd_codigo',
        type: PlutoColumnType.number(),
        width: 120,
      ),
      PlutoColumn(
        title: 'Nombre Producto',
        field: 'producto_nombre',
        type: PlutoColumnType.text(),
        width: 150,
      ),
    ];
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _generarReporte() async {
    if (_selectedReportType == 'rango_fechas') {
      if (_fechaInicioController.text.isEmpty ||
          _fechaFinController.text.isEmpty) {
        _mostrarError('Por favor, selecciona las fechas de inicio y fin');
        return;
      }
    } else {
      if (_codigoEmpleadoController.text.isEmpty) {
        _mostrarError('Por favor, ingresa el código del empleado');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> resultado;

      if (_selectedReportType == 'rango_fechas') {
        resultado = await ReportesService.obtenerReporteRangoFechas(
          fechaInicio: _fechaInicioController.text,
          fechaFin: _fechaFinController.text,
        );
      } else {
        resultado = await ReportesService.obtenerReporteEmpleado(
          codigo: _codigoEmpleadoController.text,
          fechaInicio: _fechaInicioController.text.isNotEmpty
              ? _fechaInicioController.text
              : null,
          fechaFin: _fechaFinController.text.isNotEmpty
              ? _fechaFinController.text
              : null,
        );
      }

      if (resultado['success'] == true) {
        final facturas = resultado['data']['facturas'] as List<dynamic>;
        _actualizarTabla(facturas);
        _mostrarExito(
          'Reporte generado exitosamente. ${facturas.length} registros encontrados.',
        );
      } else {
        _mostrarError(resultado['message'] ?? 'Error al generar el reporte');
      }
    } catch (e) {
      _mostrarError('Error de conexión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _actualizarTabla(List<dynamic> facturas) {
    final rows = facturas.map<PlutoRow>((factura) {
      return PlutoRow(
        cells: {
          'fac_cab_codigo': PlutoCell(
            value: factura['fac_cab_codigo']?.toString() ?? '',
          ),
          'emp_codigo': PlutoCell(
            value: factura['emp_codigo']?.toString() ?? '',
          ),
          'emp_nombres': PlutoCell(
            value: factura['emp_nombres']?.toString() ?? '',
          ),
          'emp_apellidos': PlutoCell(
            value: factura['emp_apellidos']?.toString() ?? '',
          ),
          'emp_cedula': PlutoCell(
            value: factura['emp_cedula']?.toString() ?? '',
          ),
          'emp_correo': PlutoCell(
            value: factura['emp_correo']?.toString() ?? '',
          ),
          'fac_cab_fecha': PlutoCell(
            value: factura['fac_cab_fecha']?.toString() ?? '',
          ),
          'emp_centro_costo': PlutoCell(
            value: factura['emp_centro_costo']?.toString() ?? '',
          ),
          'emp_departamento': PlutoCell(
            value: factura['emp_departamento']?.toString() ?? '',
          ),
          'emp_labor': PlutoCell(value: factura['emp_labor']?.toString() ?? ''),
          'fac_cab_cantidad': PlutoCell(
            value: factura['fac_cab_cantidad']?.toString() ?? '',
          ),
          'fac_cab_descuento': PlutoCell(
            value: factura['fac_cab_descuento']?.toString() ?? '',
          ),
          'fac_cab_precio_empleado': PlutoCell(
            value: factura['fac_cab_precio_empleado']?.toString() ?? '',
          ),
          'producto_prd_codigo': PlutoCell(
            value: factura['producto_prd_codigo']?.toString() ?? '',
          ),
          'producto_nombre': PlutoCell(
            value: factura['producto_nombre']?.toString() ?? '',
          ),
        },
      );
    }).toList();

    setState(() {
      _rows = rows;
    });
  }

  Future<void> _exportarAExcel() async {
    if (_rows.isEmpty) {
      _mostrarError('No hay datos para exportar');
      return;
    }

    try {
      final facturas = _rows.map((row) {
        return {
          'fac_cab_codigo':
              row.cells['fac_cab_codigo']?.value?.toString() ?? '',
          'emp_codigo': row.cells['emp_codigo']?.value?.toString() ?? '',
          'emp_nombres': row.cells['emp_nombres']?.value?.toString() ?? '',
          'emp_apellidos': row.cells['emp_apellidos']?.value?.toString() ?? '',
          'emp_cedula': row.cells['emp_cedula']?.value?.toString() ?? '',
          'emp_correo': row.cells['emp_correo']?.value?.toString() ?? '',
          'fac_cab_fecha': row.cells['fac_cab_fecha']?.value?.toString() ?? '',
          'emp_centro_costo':
              row.cells['emp_centro_costo']?.value?.toString() ?? '',
          'emp_departamento':
              row.cells['emp_departamento']?.value?.toString() ?? '',
          'emp_labor': row.cells['emp_labor']?.value?.toString() ?? '',
          'fac_cab_cantidad':
              row.cells['fac_cab_cantidad']?.value?.toString() ?? '',
          'fac_cab_descuento':
              row.cells['fac_cab_descuento']?.value?.toString() ?? '',
          'fac_cab_precio_empleado':
              row.cells['fac_cab_precio_empleado']?.value?.toString() ?? '',
          'producto_prd_codigo':
              row.cells['producto_prd_codigo']?.value?.toString() ?? '',
          'producto_nombre':
              row.cells['producto_nombre']?.value?.toString() ?? '',
        };
      }).toList();

      final datos = ExportService.convertirDatosFacturas(facturas);
      final columnas = ExportService.obtenerColumnas();
      final nombreArchivo =
          'reporte_facturas_${DateTime.now().millisecondsSinceEpoch}';

      final success = await ExportService.exportarAExcel(
        datos: datos,
        columnas: columnas,
        nombreArchivo: nombreArchivo,
      );

      if (success) {
        _mostrarExito('Reporte exportado a Excel exitosamente');
      } else {
        _mostrarError('Error al exportar a Excel');
      }
    } catch (e) {
      _mostrarError('Error al exportar: $e');
    }
  }

  Future<void> _exportarAPDF() async {
    if (_rows.isEmpty) {
      _mostrarError('No hay datos para exportar');
      return;
    }

    try {
      final facturas = _rows.map((row) {
        return {
          'fac_cab_codigo':
              row.cells['fac_cab_codigo']?.value?.toString() ?? '',
          'emp_codigo': row.cells['emp_codigo']?.value?.toString() ?? '',
          'emp_nombres': row.cells['emp_nombres']?.value?.toString() ?? '',
          'emp_apellidos': row.cells['emp_apellidos']?.value?.toString() ?? '',
          'emp_cedula': row.cells['emp_cedula']?.value?.toString() ?? '',
          'emp_correo': row.cells['emp_correo']?.value?.toString() ?? '',
          'fac_cab_fecha': row.cells['fac_cab_fecha']?.value?.toString() ?? '',
          'emp_centro_costo':
              row.cells['emp_centro_costo']?.value?.toString() ?? '',
          'emp_departamento':
              row.cells['emp_departamento']?.value?.toString() ?? '',
          'emp_labor': row.cells['emp_labor']?.value?.toString() ?? '',
          'fac_cab_cantidad':
              row.cells['fac_cab_cantidad']?.value?.toString() ?? '',
          'fac_cab_descuento':
              row.cells['fac_cab_descuento']?.value?.toString() ?? '',
          'fac_cab_precio_empleado':
              row.cells['fac_cab_precio_empleado']?.value?.toString() ?? '',
          'producto_prd_codigo':
              row.cells['producto_prd_codigo']?.value?.toString() ?? '',
          'producto_nombre':
              row.cells['producto_nombre']?.value?.toString() ?? '',
        };
      }).toList();

      final datos = ExportService.convertirDatosFacturas(facturas);
      final columnas = ExportService.obtenerColumnas();
      final nombreArchivo =
          'reporte_facturas_${DateTime.now().millisecondsSinceEpoch}';
      final titulo = 'Reporte de Facturas - NutriPlan';

      final success = await ExportService.exportarAPDF(
        datos: datos,
        columnas: columnas,
        nombreArchivo: nombreArchivo,
        titulo: titulo,
      );

      if (success) {
        _mostrarExito('Reporte exportado a PDF exitosamente');
      } else {
        _mostrarError('Error al exportar a PDF');
      }
    } catch (e) {
      _mostrarError('Error al exportar: $e');
    }
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
