import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductsWidget extends StatefulWidget {
  final Function() onRecordSaved;

  const ProductsWidget({super.key, required this.onRecordSaved});

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  // Variables para el formulario de productos
  List<String> _tiposProductos = [];
  bool _isLoadingTipos = false;
  String? _selectedTipoProducto;
  final TextEditingController _codigoEmpleadoController =
      TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  // Variables para la búsqueda de empleados
  bool _isLoadingEmpleado = false;
  Map<String, dynamic>? _empleadoEncontrado;
  bool _isTestingConnection = false;

  @override
  void initState() {
    super.initState();
    _cargarTiposProductos();
    _setupCodigoEmpleadoListener();
    _cantidadController.text = "1";
  }

  @override
  void dispose() {
    _codigoEmpleadoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _cargarTiposProductos() async {
    setState(() {
      _isLoadingTipos = true;
    });

    try {
      final tipos = await ApiService.getTiposProductos();
      setState(() {
        _tiposProductos = tipos;
        _isLoadingTipos = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTipos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar tipos de productos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _setupCodigoEmpleadoListener() {
    _codigoEmpleadoController.addListener(() {
      final codigo = _codigoEmpleadoController.text.trim();
      if (codigo.length == 6) {
        _buscarEmpleadoPorCodigo(codigo);
      } else if (codigo.length < 6) {
        // Limpiar información del empleado si se borra el código
        setState(() {
          _empleadoEncontrado = null;
        });
      }
    });
  }

  Future<void> _buscarEmpleadoPorCodigo(String codigo) async {
    setState(() {
      _isLoadingEmpleado = true;
    });

    try {
      final empleado = await ApiService.getColaboradorPorCodigo(codigo);
      setState(() {
        _empleadoEncontrado = empleado;
        _isLoadingEmpleado = false;
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
    } catch (e) {
      setState(() {
        _empleadoEncontrado = null;
        _isLoadingEmpleado = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error inesperado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
    });

    try {
      final resultado = await ApiService.testColaboradoresConnection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Conexión exitosa: $resultado'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Cerrar',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al probar conexión: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }

  Future<void> _guardarRegistro() async {
    // Validar campos
    if (_codigoEmpleadoController.text.isEmpty ||
        _selectedTipoProducto == null ||
        _cantidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que el código tenga 6 dígitos
    if (_codigoEmpleadoController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código de empleado debe tener 6 dígitos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que se haya encontrado el empleado
    if (_empleadoEncontrado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor verifica que el empleado exista en el sistema',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que la cantidad sea un número válido
    final cantidad = int.tryParse(_cantidadController.text);
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La cantidad debe ser un número mayor a 0'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Mostrar indicador de carga
    setState(() {
      _isLoadingEmpleado = true;
    });

    try {
      // Preparar datos de la factura según la estructura exacta que espera el backend
      final facturaData = {
        'fac_cab_codigo':
            DateTime.now().millisecondsSinceEpoch, // Código único de factura
        'emp_codigo': _codigoEmpleadoController.text.trim(),
        'emp_apellidos': _empleadoEncontrado?['apellidos'] ?? '',
        'emp_cedula': _empleadoEncontrado?['cedula'] ?? '',
        'emp_correo': _empleadoEncontrado?['email_personal'] ?? '',
        'emp_nombres': _empleadoEncontrado?['nombres'] ?? '',
        'fac_cab_fecha': DateTime.now().toIso8601String(),
        'emp_centro_costo': _empleadoEncontrado?['centro_costo'] ?? '',
        'emp_departamento': _empleadoEncontrado?['departamento'] ?? '',
        'emp_labor': _empleadoEncontrado?['labor'] ?? '',
        'fac_cab_cantidad': cantidad,
        'fac_cab_descuento': 0, // Descuento por defecto
        'fac_cab_precio_empleado': 1, // Precio por defecto
        'producto_prd_codigo': 1, // Código de producto por defecto
        'producto_nombre': _selectedTipoProducto,
      };

      print('📋 Datos de factura a enviar: $facturaData');

      // Enviar al backend
      final resultado = await ApiService.crearFactura(facturaData);

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Registro guardado exitosamente: ${_selectedTipoProducto}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Limpiar formulario
      _codigoEmpleadoController.clear();
      _cantidadController.clear();
      setState(() {
        _selectedTipoProducto = null;
        _empleadoEncontrado = null;
        _isLoadingEmpleado = false;
      });

      // Notificar al widget padre que se guardó un registro
      widget.onRecordSaved();
    } catch (e) {
      setState(() {
        _isLoadingEmpleado = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al guardar registro: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
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
            Icon(Icons.restaurant_menu, size: 32, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              'Gestión de Productos',
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
                    'Registro de Productos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildProductsForm(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsForm() {
    return Column(
      children: [
        // Campo de código de empleado con indicador de carga
        TextFormField(
          controller: _codigoEmpleadoController,
          decoration: InputDecoration(
            labelText: 'Código de Empleado',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.badge),
            suffixIcon: _isLoadingEmpleado
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _empleadoEncontrado != null
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            hintText: 'Ingresa 6 dígitos para buscar automáticamente',
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 16),

        // Información del empleado encontrado
        if (_empleadoEncontrado != null) ...[
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Información del Empleado',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildEmpleadoInfo(
                    'Cédula',
                    _empleadoEncontrado!['cedula'] ?? '',
                  ),
                  _buildEmpleadoInfo(
                    'Cargo',
                    _empleadoEncontrado!['cargo'] ?? '',
                  ),
                  _buildEmpleadoInfo(
                    'Departamento',
                    _empleadoEncontrado!['departamento'] ?? '',
                  ),
                  _buildEmpleadoInfo(
                    'Área',
                    _empleadoEncontrado!['area'] ?? '',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),
        _isLoadingTipos
            ? const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Cargando tipos de productos...'),
                  ],
                ),
              )
            : DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Producto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                value: _selectedTipoProducto,
                items: _tiposProductos.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipoProducto = value;
                  });
                },
                hint: const Text('Selecciona un tipo de producto'),
              ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cantidadController,
          decoration: const InputDecoration(
            labelText: 'Cantidad',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.numbers),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoadingTipos ? null : _cargarTiposProductos,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar Lista'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isTestingConnection ? null : _testConnection,
                icon: _isTestingConnection
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_find),
                label: Text(
                  _isTestingConnection ? 'Probando...' : 'Probar Conexión',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoadingEmpleado ? null : _guardarRegistro,
            child: _isLoadingEmpleado
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Guardando...'),
                    ],
                  )
                : const Text('Guardar Registro'),
          ),
        ),
      ],
    );
  }
}
