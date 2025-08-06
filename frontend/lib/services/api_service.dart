import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'package:collection/collection.dart';

class ApiService {
  // Mock object for fallback when API is unreachable
  static final Map<String, dynamic> _fallbackColaborador = {
    'apellidos': 'APELLIDO PRUEBA',
    'area': 'AREA PRUEBA',
    'cargo': 'CARGO PRUEBA',
    'cedula': 'CEDULA PRUEBA',
    'centro_costo': 'CENTRO DE COSTO PRUEBA',
    'departamento': 'DEPARTAMENTO PRUEBA',
    'email_personal': 'email@prueba.com',
    'fecha_ingreso': '18/11/2024 12:00:00 a. m.',
    'labor': 'L',
    'nombres': 'NOMBRE PRUEBA',
    'seccion': 'SECCION PRUEBA',
  };
  // Obtener todos los productos
  static Future<List<Map<String, dynamic>>> getProductos() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.productosUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al obtener productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener productos por nombre (filtro)
  static Future<List<Map<String, dynamic>>> getProductosPorNombre(
    String nombre,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.productosUrl}?nombre=$nombre'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error al buscar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear un nuevo producto
  static Future<Map<String, dynamic>> crearProducto(
    Map<String, dynamic> producto,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.productosUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producto),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener tipos únicos de productos (basado en prd_nombre)
  static Future<List<String>> getTiposProductos() async {
    try {
      final productos = await getProductos();
      final tipos = productos
          .map((producto) => producto['prd_nombre'] as String)
          .where((nombre) => nombre.isNotEmpty)
          .toSet()
          .toList();

      // Ordenar alfabéticamente
      tipos.sort();
      return tipos;
    } catch (e) {
      throw Exception('Error al obtener tipos de productos: $e');
    }
  }

  // Crear una nueva factura
  static Future<Map<String, dynamic>> crearFactura(
    Map<String, dynamic> factura,
  ) async {
    try {
      print('📤 Enviando factura al backend: ${json.encode(factura)}');

      final response = await http.post(
        Uri.parse(AppConfig.facturasUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(factura),
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Factura creada exitosamente: $responseData');
        return responseData;
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        print('❌ Error Body: ${response.body}');
        throw Exception(
          'Error al crear factura: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Error de conexión al crear factura: $e');
      throw Exception('Error de conexión al crear factura: $e');
    }
  }

  // Obtener las últimas facturas
  static Future<List<Map<String, dynamic>>> getUltimasFacturas() async {
    try {
      print('📥 Obteniendo últimas facturas...');

      final response = await http.get(
        Uri.parse(AppConfig.facturasUrl),
        headers: {'Accept': 'application/json'},
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final facturas = data.cast<Map<String, dynamic>>();

        // Ordenar por fecha descendente y tomar las últimas 3
        facturas.sort((a, b) {
          final fechaA =
              DateTime.tryParse(a['fac_cab_fecha'] ?? '') ?? DateTime(1900);
          final fechaB =
              DateTime.tryParse(b['fac_cab_fecha'] ?? '') ?? DateTime(1900);
          return fechaB.compareTo(fechaA);
        });

        final ultimas10 = facturas.take(10).toList();
        print('✅ Últimas 10 facturas obtenidas: ${ultimas10.length}');
        return ultimas10;
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        print('❌ Error Body: ${response.body}');
        throw Exception(
          'Error al obtener facturas: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Error de conexión al obtener facturas: $e');
      throw Exception('Error de conexión al obtener facturas: $e');
    }
  }

  // Eliminar una factura por ID
  static Future<bool> eliminarFactura(String facturaId) async {
    try {
      print('🗑️ Eliminando factura con ID: $facturaId');

      final response = await http.delete(
        Uri.parse('${AppConfig.facturasUrl}/$facturaId'),
        headers: {'Accept': 'application/json'},
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Factura eliminada exitosamente');
        return true;
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        print('❌ Error Body: ${response.body}');
        throw Exception(
          'Error al eliminar factura: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Error de conexión al eliminar factura: $e');
      throw Exception('Error de conexión al eliminar factura: $e');
    }
  }

  // Obtener información de colaborador por código
  static Future<Map<String, dynamic>?> getColaboradorPorCodigo(
    String codigo,
  ) async {
    // Primero intentar con datos de prueba locales
    final colaboradorLocal = _getColaboradorLocal(codigo);
    if (colaboradorLocal != null) {
      print(
        '✅ Colaborador encontrado en datos locales: ${colaboradorLocal['nombres']} ${colaboradorLocal['apellidos']}',
      );
      return colaboradorLocal;
    }

    try {
      print('🔍 Iniciando búsqueda de colaborador con código: $codigo');
      print('🌐 URL del servicio: ${AppConfig.colaboradoresUrl}');

      // Usar el mismo enfoque que funcionó en Postman
      final request = http.Request(
        'GET',
        Uri.parse(AppConfig.colaboradoresUrl),
      );
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['User-Agent'] = 'NutriPlan-App/1.0';

      print('📤 Enviando request con headers: ${request.headers}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La conexión tardó más de 30 segundos');
        },
      );

      print('📡 Status Code: ${streamedResponse.statusCode}');
      print('📡 Response Headers: ${streamedResponse.headers}');

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        print('📄 Tamaño de respuesta: ${responseBody.length} caracteres');
        print(
          '📄 Primeros 200 caracteres: ${responseBody.substring(0, responseBody.length > 200 ? 200 : responseBody.length)}',
        );

        // Verificar que el body no esté vacío
        if (responseBody.isEmpty) {
          throw Exception('El servidor devolvió una respuesta vacía');
        }

        final List<dynamic> data = json.decode(responseBody);
        print('📊 Número de colaboradores recibidos: ${data.length}');

        print('✅ Respuesta exitosa del servidor');

        // Buscar el colaborador por código
        final colaborador = data.firstWhereOrNull(
          (colab) => colab['codigo'] == codigo,
        );

        if (colaborador != null) {
          print(
            '✅ Colaborador encontrado: ${colaborador['nombres']} ${colaborador['apellidos']}',
          );
        } else {
          print('❌ Colaborador no encontrado con código: $codigo');
        }

        return colaborador;
      } else {
        print('❌ Error HTTP: ${streamedResponse.statusCode}');
        final errorBody = await streamedResponse.stream.bytesToString();
        print('❌ Response Body: $errorBody');
        throw Exception(
          'Error HTTP ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}',
        );
      }
    } on FormatException catch (e) {
      print('❌ Error de formato JSON: $e');
      throw Exception(
        'Error al procesar la respuesta del servidor: Formato JSON inválido',
      );
    } on SocketException catch (e) {
      print('❌ Error de socket: $e');
      // Return mock object on network error
      final mock = Map<String, dynamic>.from(_fallbackColaborador);
      mock['codigo'] = codigo;
      print('💡 Fallback a datos de ejemplo por error de red.');
      return mock;
    } on TimeoutException catch (e) {
      print('❌ Error de timeout: $e');
      // Return mock object on timeout error
      final mock = Map<String, dynamic>.from(_fallbackColaborador);
      mock['codigo'] = codigo;
      print('💡 Fallback a datos de ejemplo por timeout.');
      return mock;
    } catch (e) {
      print('❌ Error inesperado: $e');
      if (e.toString().contains('Failed to fetch')) {
        // Return mock object on ClientException: Failed to fetch
        final mock = Map<String, dynamic>.from(_fallbackColaborador);
        mock['codigo'] = codigo;
        print(
          '💡 Fallback a datos de ejemplo por error de conectividad (Failed to fetch).',
        );
        return mock;
      }
      // For any other unexpected error, still throw.
      throw Exception('Error de conexión: $e');
    }
  }

  // Datos locales de prueba para cuando el servicio web no esté disponible
  static Map<String, dynamic>? _getColaboradorLocal(String codigo) {
    final colaboradoresLocales = [
      {
        'codigo': '000000',
        'cedula': '000000000',
        'apellidos': 'APELLIDO PRUEBA',
        'nombres': 'NOMBRE PRUEBA',
        'fecha_ingreso': '6/05/2024 12:00:00 a. m.',
        'labor': 'O',
        'area': 'AREA PRUEBA',
        'centro_costo': 'CENTRO DE COSTO PRUEBA',
        'cargo': 'CARGO PRUEBA',
        'departamento': 'DEPARTAMENTO PRUEBA',
        'seccion': 'SECCION PRUEBA',
        'email_personal': 'email@prueba.com',
      },
    ];

    try {
      final colaborador = colaboradoresLocales
          .where((colab) => colab['codigo'] == codigo)
          .firstOrNull;
      return colaborador;
    } catch (e) {
      return null;
    }
  }

  // Función para probar la conectividad al servicio web
  static Future<Map<String, dynamic>> testColaboradoresConnection() async {
    try {
      print('🧪 Iniciando prueba de conectividad...');
      print('🌐 URL: ${AppConfig.colaboradoresUrl}');

      // Usar el mismo enfoque que funcionó en Postman
      final request = http.Request(
        'GET',
        Uri.parse(AppConfig.colaboradoresUrl),
      );
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['User-Agent'] = 'NutriPlan-App/1.0';

      print('📤 Enviando request de prueba con headers: ${request.headers}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
      );

      print('📡 Status Code: ${streamedResponse.statusCode}');
      print('📡 Content-Type: ${streamedResponse.headers['content-type']}');

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        print('📄 Response Length: ${responseBody.length}');
        print(
          '📄 Primeros 200 caracteres: ${responseBody.substring(0, responseBody.length > 200 ? 200 : responseBody.length)}',
        );

        final data = json.decode(responseBody);
        return {
          'success': true,
          'statusCode': streamedResponse.statusCode,
          'totalColaboradores': data.length,
          'sampleData': data.isNotEmpty ? data.first : null,
          'message': 'Conexión exitosa al servicio web',
        };
      } else {
        final errorBody = await streamedResponse.stream.bytesToString();
        return {
          'success': false,
          'statusCode': streamedResponse.statusCode,
          'error':
              'HTTP ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}',
          'body': errorBody,
        };
      }
    } on SocketException catch (e) {
      return {
        'success': false,
        'error':
            'Error de red: No se pudo conectar al servidor. Verifica tu conexión a internet.',
        'type': 'SocketException',
        'details': e.toString(),
      };
    } on TimeoutException catch (e) {
      return {
        'success': false,
        'error': 'Timeout: La conexión tardó demasiado tiempo.',
        'type': 'TimeoutException',
        'details': e.toString(),
      };
    } catch (e) {
      String errorMessage = 'Error de conexión: $e';
      if (e.toString().contains('Failed to fetch')) {
        errorMessage =
            'Error de conectividad: No se pudo conectar al servicio web. Verifica tu conexión a internet y que el servicio esté disponible.';
      }

      return {
        'success': false,
        'error': errorMessage,
        'type': e.runtimeType.toString(),
        'details': e.toString(),
      };
    }
  }
}
