import 'package:flutter/material.dart';

class MobileMenu extends StatelessWidget {
  final String selectedTopItem;
  final String selectedSideItem;
  final Function(String) onTopItemSelected;
  final Function(String) onSideItemSelected;

  const MobileMenu({
    super.key,
    required this.selectedTopItem,
    required this.selectedSideItem,
    required this.onTopItemSelected,
    required this.onSideItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  'NutriPlan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sistema de Gestión',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Sección del menú superior
          _buildMenuSection(
            context,
            'Registro de Movimientos',
            [
              {'title': 'Inicio', 'icon': Icons.home},
              {'title': 'Productos', 'icon': Icons.restaurant_menu},
              {'title': 'Últimos Movimientos', 'icon': Icons.history},
            ],
            selectedTopItem,
            onTopItemSelected,
          ),
          const Divider(),
          // Sección del menú lateral
          _buildMenuSection(
            context,
            'Administración',
            [
              {'title': 'Sistema de Facturación', 'icon': Icons.receipt},
              {'title': 'Buscar Empleado', 'icon': Icons.person_search},
              {'title': 'Generar Reportes', 'icon': Icons.assessment},
              {'title': 'Actualizar Información', 'icon': Icons.update},
            ],
            selectedSideItem,
            onSideItemSelected,
          ),
          const Spacer(),
          // Footer del drawer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.grey[600]),
                  title: Text(
                    'Versión 1.0.0',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String sectionTitle,
    List<Map<String, dynamic>> items,
    String selectedItem,
    Function(String) onItemSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        ...items.map((item) {
          final isSelected = selectedItem == item['title'];

          return ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: isSelected ? Colors.blue : Colors.grey[600],
            ),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: Colors.blue, size: 20)
                : null,
            onTap: () {
              onItemSelected(item['title'] as String);
              Navigator.pop(context); // Cerrar el drawer
            },
            tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
          );
        }).toList(),
      ],
    );
  }
}
