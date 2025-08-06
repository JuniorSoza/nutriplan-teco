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
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMenuItem = 'Inicio';
  String _selectedSideMenuItem = '';

  void _onTopMenuItemSelected(String item) {
    setState(() {
      _selectedMenuItem = item;
      _selectedSideMenuItem = '';
    });
  }

  void _onSideMenuItemSelected(String item) {
    setState(() {
      _selectedSideMenuItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriPlan - Sistema de Gestión'),
        actions: [
          // Menú hamburguesa para móvil
          if (MediaQuery.of(context).size.width < 768)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      endDrawer: MediaQuery.of(context).size.width < 768
          ? MobileMenu(
              selectedTopItem: _selectedMenuItem,
              selectedSideItem: _selectedSideMenuItem,
              onTopItemSelected: _onTopMenuItemSelected,
              onSideItemSelected: _onSideMenuItemSelected,
            )
          : null,
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Menú superior para móvil
        TopMenu(
          selectedItem: _selectedMenuItem,
          onItemSelected: _onTopMenuItemSelected,
          isMobile: true,
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Menú lateral para tablet
        SideMenu(
          selectedItem: _selectedSideMenuItem,
          onItemSelected: _onSideMenuItemSelected,
          isTablet: true,
        ),
        Expanded(
          child: Column(
            children: [
              // Menú superior
              TopMenu(
                selectedItem: _selectedMenuItem,
                onItemSelected: _onTopMenuItemSelected,
                isMobile: false,
              ),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Menú lateral para desktop
        SideMenu(
          selectedItem: _selectedSideMenuItem,
          onItemSelected: _onSideMenuItemSelected,
          isTablet: false,
        ),
        Expanded(
          child: Column(
            children: [
              // Menú superior
              TopMenu(
                selectedItem: _selectedMenuItem,
                onItemSelected: _onTopMenuItemSelected,
                isMobile: false,
              ),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: _getContentForSelectedItem(),
    );
  }

  Widget _getContentForSelectedItem() {
    if (_selectedSideMenuItem.isNotEmpty) {
      return _getSideMenuContent();
    }

    switch (_selectedMenuItem) {
      case 'Productos':
        return _buildProductsContent();
      case 'Últimos Movimientos':
        return _buildRecentMovements();
      default:
        return _buildWelcomeContent();
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.blue[400]),
          const SizedBox(height: 24),
          Text(
            'Bienvenido al Sistema de Gestión NutriPlan',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Selecciona "Productos" del menú superior para registrar movimientos\n'
            'o del menú lateral para consultas y reportes',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsContent() {
    return ProductsWidget(
      onRecordSaved: () {
        // Callback para cuando se guarda un registro
        // Esto se puede usar para actualizar otros widgets si es necesario
      },
    );
  }

  Widget _buildRecentMovements() {
    return const RecentMovementsWidget();
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
