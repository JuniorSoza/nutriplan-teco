import 'dart:io';
import 'dart:html' as html;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportService {
  /// Exporta datos a Excel
  static Future<bool> exportarAExcel({
    required List<Map<String, dynamic>> datos,
    required List<String> columnas,
    required String nombreArchivo,
  }) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Reporte'];

      // Agregar encabezados
      for (int i = 0; i < columnas.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          ..value = columnas[i]
          ..cellStyle = CellStyle(
            bold: true,
            horizontalAlign: HorizontalAlign.Center,
            backgroundColorHex: '#E0E0E0',
          );
      }

      // Agregar datos
      for (int row = 0; row < datos.length; row++) {
        final fila = datos[row];
        for (int col = 0; col < columnas.length; col++) {
          final valor = fila[columnas[col]]?.toString() ?? '';
          sheet
                  .cell(
                    CellIndex.indexByColumnRow(
                      columnIndex: col,
                      rowIndex: row + 1,
                    ),
                  )
                  .value =
              valor;
        }
      }

      // Ajustar ancho de columnas (comentado por compatibilidad)
      // for (int i = 0; i < columnas.length; i++) {
      //   sheet.setColumnWidth(CellIndex.indexByColumnRow(columnIndex: i), 15);
      // }

      // Guardar archivo
      final bytes = excel.save();
      if (bytes != null) {
        if (kIsWeb) {
          // Para Flutter Web, usar descarga directa
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', '$nombreArchivo.xlsx')
            ..click();
          html.Url.revokeObjectUrl(url);
          return true;
        } else {
          // Para otras plataformas, usar FilePicker
          final result = await FilePicker.platform.saveFile(
            dialogTitle: 'Guardar reporte Excel',
            fileName: '$nombreArchivo.xlsx',
            allowedExtensions: ['xlsx'],
          );

          if (result != null) {
            final file = File(result);
            await file.writeAsBytes(bytes);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print('Error al exportar a Excel: $e');
      return false;
    }
  }

  /// Exporta datos a PDF
  static Future<bool> exportarAPDF({
    required List<Map<String, dynamic>> datos,
    required List<String> columnas,
    required String nombreArchivo,
    required String titulo,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          // Removed custom font loading to fix "Helvetica no Unicode support"
          build: (context) => [
            // Título
            pw.Header(
              level: 0,
              child: pw.Text(
                titulo,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            // Tabla de datos
            pw.Table.fromTextArray(
              headers: columnas,
              data: datos.map((fila) {
                return columnas.map((columna) {
                  final valor = fila[columna]?.toString() ?? '';
                  return valor.length > 30
                      ? '${valor.substring(0, 30)}...'
                      : valor;
                }).toList();
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
              border: pw.TableBorder.all(),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerLeft,
                7: pw.Alignment.centerLeft,
                8: pw.Alignment.centerLeft,
                9: pw.Alignment.centerLeft,
                10: pw.Alignment.center,
                11: pw.Alignment.center,
                12: pw.Alignment.center,
                13: pw.Alignment.center,
                14: pw.Alignment.centerLeft,
              },
            ),

            // Información adicional
            pw.SizedBox(height: 20),
            pw.Text(
              'Total de registros: ${datos.length}',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Generado el: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        ),
      );

      // Guardar archivo
      final bytes = await pdf.save();

      if (kIsWeb) {
        // Para Flutter Web, usar descarga directa
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', '$nombreArchivo.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
        return true;
      } else {
        // Para otras plataformas, usar FilePicker
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar reporte PDF',
          fileName: '$nombreArchivo.pdf',
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          final file = File(result);
          await file.writeAsBytes(bytes);
          return true;
        }
        return false;
      }
    } catch (e) {
      print('Error al exportar a PDF: $e');
      return false;
    }
  }

  /// Convierte datos de facturas a formato para exportación
  static List<Map<String, dynamic>> convertirDatosFacturas(
    List<dynamic> facturas,
  ) {
    return facturas.map<Map<String, dynamic>>((factura) {
      return {
        'Código Factura': factura['fac_cab_codigo']?.toString() ?? '',
        'Código Empleado': factura['emp_codigo']?.toString() ?? '',
        'Nombres': factura['emp_nombres']?.toString() ?? '',
        'Apellidos': factura['emp_apellidos']?.toString() ?? '',
        'Cédula': factura['emp_cedula']?.toString() ?? '',
        'Correo': factura['emp_correo']?.toString() ?? '',
        'Fecha': factura['fac_cab_fecha']?.toString() ?? '',
        'Centro de Costo': factura['emp_centro_costo']?.toString() ?? '',
        'Departamento': factura['emp_departamento']?.toString() ?? '',
        'Labor': factura['emp_labor']?.toString() ?? '',
        'Cantidad': factura['fac_cab_cantidad']?.toString() ?? '',
        'Descuento': factura['fac_cab_descuento']?.toString() ?? '',
        'Precio Empleado': factura['fac_cab_precio_empleado']?.toString() ?? '',
        'Código Producto': factura['producto_prd_codigo']?.toString() ?? '',
        'Nombre Producto': factura['producto_nombre']?.toString() ?? '',
      };
    }).toList();
  }

  /// Obtiene las columnas para la tabla
  static List<String> obtenerColumnas() {
    return [
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
      'Nombre Producto',
    ];
  }
}
