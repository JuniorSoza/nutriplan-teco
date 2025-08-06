import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class EmployeeSearchWidget extends StatefulWidget {
  const EmployeeSearchWidget({super.key});

  @override
  State<EmployeeSearchWidget> createState() => _EmployeeSearchWidgetState();
}

class _EmployeeSearchWidgetState extends State<EmployeeSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _empleadoEncontrado;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _validarConexionWebService() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Validando conexión al web service...');

      var request = http.Request(
        'GET',
        Uri.parse('http://ddws.tecopesca.com:8042/ws_comedor/api/colaborador'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('✅ Conexión exitosa al web service');
        print('📄 Respuesta del servidor: $responseBody');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Conexión exitosa al web service\nRespuesta: ${responseBody.length} caracteres',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Ver Detalles',
                textColor: Colors.white,
                onPressed: () {
                  _mostrarDetallesConexion(responseBody, response.statusCode);
                },
              ),
            ),
          );
        }
      } else {
        print(
          '❌ Error en la conexión: ${response.statusCode} - ${response.reasonPhrase}',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ Error en la conexión: ${response.statusCode} - ${response.reasonPhrase}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Excepción al validar conexión: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al validar conexión: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mostrarDetallesConexion(String responseBody, int statusCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles de la Conexión'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Status Code: $statusCode'),
                const SizedBox(height: 8),
                const Text(
                  'Respuesta del servidor:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    responseBody,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
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

  Future<void> _buscarEmpleado() async {
    final searchTerm = _searchController.text.trim();

    if (searchTerm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un término de búsqueda'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _empleadoEncontrado = null;
    });

    try {
      // Si el término de búsqueda tiene 6 dígitos, asumimos que es un código
      if (searchTerm.length == 6 && int.tryParse(searchTerm) != null) {
        final empleado = await ApiService.getColaboradorPorCodigo(searchTerm);
        setState(() {
          _empleadoEncontrado = empleado;
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Empleado encontrado'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // TODO: Implementar búsqueda por nombre o cédula
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Búsqueda por nombre/cédula en desarrollo'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _empleadoEncontrado = null;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al buscar empleado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildEmpleadoInfo(String label, String value) {
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
            Icon(Icons.person_search, size: 32, color: Colors.orange),
            const SizedBox(width: 12),
            Text(
              'Buscar Empleado',
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
                    'Búsqueda de Empleados',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText:
                          'Buscar por código (6 dígitos), nombre o cédula',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                    ),
                    onFieldSubmitted: (_) => _buscarEmpleado(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _buscarEmpleado,
                          child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Buscando...'),
                                  ],
                                )
                              : const Text('Buscar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : _validarConexionWebService,
                        icon: const Icon(Icons.wifi_find, size: 18),
                        label: const Text('Validar\nConexión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Resultado de la búsqueda
                  if (_empleadoEncontrado != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Empleado Encontrado',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildEmpleadoInfo(
                            'Código',
                            _empleadoEncontrado!['codigo']?.toString() ?? 'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Nombres',
                            _empleadoEncontrado!['nombres']?.toString() ??
                                'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Apellidos',
                            _empleadoEncontrado!['apellidos']?.toString() ??
                                'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Cédula',
                            _empleadoEncontrado!['cedula']?.toString() ?? 'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Cargo',
                            _empleadoEncontrado!['cargo']?.toString() ?? 'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Departamento',
                            _empleadoEncontrado!['departamento']?.toString() ??
                                'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Centro de Costo',
                            _empleadoEncontrado!['centro_costo']?.toString() ??
                                'N/A',
                          ),
                          _buildEmpleadoInfo(
                            'Correo',
                            _empleadoEncontrado!['email_personal']
                                    ?.toString() ??
                                'N/A',
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Información de ayuda
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Tipos de Búsqueda',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Código: Ingresa exactamente 6 dígitos\n'
                          '• Nombre: Búsqueda por nombre completo (en desarrollo)\n'
                          '• Cédula: Búsqueda por número de cédula (en desarrollo)\n'
                          '• Validar Conexión: Prueba la conectividad al web service',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
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
}
