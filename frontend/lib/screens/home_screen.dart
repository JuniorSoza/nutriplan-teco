import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/top_menu.dart';
import '../widgets/side_menu.dart';
import '../widgets/mobile_menu.dart';
import '../widgets/products_widget.dart';
import '../widgets/recent_movements_widget.dart';
import '../widgets/billing_system_widget.dart';
import '../widgets/employee_search_widget.dart';
import '../widgets/reports_widget.dart';
import '../widgets/update_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTopMenuItem = 'Productos';
  String _selectedSideMenuItem = 'Sistema de Facturación';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriPlan'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: MobileMenu(
        selectedTopItem: _selectedTopMenuItem,
        selectedSideItem: _selectedSideMenuItem,
        onTopItemSelected: (item) {
          setState(() {
            _selectedTopMenuItem = item;
          });
        },
        onSideItemSelected: (item) {
          setState(() {
            _selectedSideMenuItem = item;
          });
        },
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        TopMenu(
          selectedItem: _selectedTopMenuItem,
          onItemSelected: (item) {
            setState(() {
              _selectedTopMenuItem = item;
            });
          },
          isMobile: true,
        ),
        Expanded(child: _getTopMenuContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        SideMenu(
          selectedItem: _selectedSideMenuItem,
          onItemSelected: (item) {
            setState(() {
              _selectedSideMenuItem = item;
            });
          },
          isTablet: true,
        ),
        Expanded(
          child: Column(
            children: [
              TopMenu(
                selectedItem: _selectedTopMenuItem,
                onItemSelected: (item) {
                  setState(() {
                    _selectedTopMenuItem = item;
                  });
                },
                isMobile: false,
              ),
              Expanded(child: _getTopMenuContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SideMenu(
          selectedItem: _selectedSideMenuItem,
          onItemSelected: (item) {
            setState(() {
              _selectedSideMenuItem = item;
            });
          },
          isTablet: false,
        ),
        Expanded(
          child: Column(
            children: [
              TopMenu(
                selectedItem: _selectedTopMenuItem,
                onItemSelected: (item) {
                  setState(() {
                    _selectedTopMenuItem = item;
                  });
                },
                isMobile: false,
              ),
              Expanded(child: _getTopMenuContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getTopMenuContent() {
    switch (_selectedTopMenuItem) {
      case 'Productos':
        return ProductsWidget(
          onRecordSaved: () {
            // Callback para cuando se guarda un registro
            // Esto se puede usar para actualizar otros widgets si es necesario
          },
        );
      case 'Últimos Movimientos':
        return const RecentMovementsWidget();
      default:
        return _getSideMenuContent();
    }
  }

  Widget _getSideMenuContent() {
    switch (_selectedSideMenuItem) {
      case 'Sistema de Facturación':
        return _buildBillingSystem();
      case 'Buscar Empleado':
        return _buildEmployeeSearch();
      case 'Generar Reportes':
        return _buildReports();
      case 'Actualizar Información':
        return _buildUpdateInfo();
      default:
        return _buildWelcomeContent();
    }
  }

  Widget _buildWelcomeContent() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, size: 48, color: Colors.purple),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido a NutriPlan',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sistema de Gestión de Comedor Empresarial',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Funcionalidades Principales',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.point_of_sale,
                    'Sistema de Facturación',
                    'Registra y gestiona las ventas del comedor',
                  ),
                  _buildFeatureItem(
                    Icons.person_search,
                    'Búsqueda de Empleados',
                    'Consulta información de empleados en tiempo real',
                  ),
                  _buildFeatureItem(
                    Icons.assessment,
                    'Generación de Reportes',
                    'Crea reportes detallados de ventas y consumo',
                  ),
                  _buildFeatureItem(
                    Icons.update,
                    'Actualización de Información',
                    'Mantén actualizada la información del sistema',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSystem() {
    return const BillingSystemWidget();
  }

  Widget _buildEmployeeSearch() {
    return const EmployeeSearchWidget();
  }

  Widget _buildReports() {
    return const ReportsWidget();
  }

  Widget _buildUpdateInfo() {
    return const UpdateInfoWidget();
  }
}
