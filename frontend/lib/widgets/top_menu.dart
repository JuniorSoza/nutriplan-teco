import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget {
  final String selectedItem;
  final Function(String) onItemSelected;
  final bool isMobile;

  const TopMenu({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ['Inicio', 'Productos', 'Últimos Movimientos'];

    if (isMobile) {
      return _buildMobileMenu(context, menuItems);
    } else {
      return _buildDesktopMenu(context, menuItems);
    }
  }

  Widget _buildMobileMenu(BuildContext context, List<String> menuItems) {
    return Container(
      height: 60,
      color: Colors.blue[50],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          final isSelected = selectedItem == item;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: InkWell(
              onTap: () => onItemSelected(item),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopMenu(BuildContext context, List<String> menuItems) {
    return Container(
      height: 60,
      color: Colors.blue[50],
      child: Row(
        children: menuItems.map((item) {
          final isSelected = selectedItem == item;

          return Expanded(
            child: InkWell(
              onTap: () => onItemSelected(item),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.blue,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
