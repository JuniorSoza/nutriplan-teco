import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final String selectedItem;
  final Function(String) onItemSelected;
  final bool isTablet;

  const SideMenu({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'Sistema de Facturación',
        'icon': Icons.receipt,
        'color': Colors.green,
      },
      {
        'title': 'Buscar Empleado',
        'icon': Icons.person_search,
        'color': Colors.orange,
      },
      {
        'title': 'Generar Reportes',
        'icon': Icons.assessment,
        'color': Colors.purple,
      },
      {
        'title': 'Actualizar Información',
        'icon': Icons.update,
        'color': Colors.red,
      },
    ];

    return Container(
      width: isTablet ? 200 : 250,
      color: Colors.grey[100],
      child: Column(
        children: [
          // Header del menú lateral
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Column(
              children: [
                Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  'Administración',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Lista de opciones del menú
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = selectedItem == item['title'];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Card(
                    elevation: isSelected ? 4 : 1,
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isSelected
                            ? Colors.blue
                            : item['color'] as Color,
                        size: 24,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                              size: 16,
                            )
                          : null,
                      onTap: () => onItemSelected(item['title'] as String),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer del menú lateral
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text(
                  'NutriPlan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistema de Gestión',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
