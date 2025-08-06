import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ReportesService {
  static const String baseUrl = AppConfig.backendUrl;

  /// Obtiene reporte de facturas por rango de fechas
  static Future<Map<String, dynamic>> obtenerReporteRangoFechas({
    required String fechaInicio,
    required String fechaFin,
    String formato = 'json',
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/reportes-facturas/rango-fechas?fechaInicio=$fechaInicio&fechaFin=$fechaFin&formato=$formato',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (formato == 'csv') {
          // Para CSV, devolver el texto plano
          return {
            'success': true,
            'data': response.body,
            'contentType': 'text/csv',
          };
        } else {
          // Para JSON, parsear la respuesta
          return json.decode(response.body);
        }
      } else {
        return {
          'success': false,
          'message': 'Error al obtener reporte: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  /// Obtiene reporte de facturas por empleado específico
  static Future<Map<String, dynamic>> obtenerReporteEmpleado({
    required String codigo,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    try {
      String url = '$baseUrl/api/reportes-facturas/empleado/$codigo';

      if (fechaInicio != null && fechaFin != null) {
        url += '?fechaInicio=$fechaInicio&fechaFin=$fechaFin';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message':
              'Error al obtener reporte del empleado: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
