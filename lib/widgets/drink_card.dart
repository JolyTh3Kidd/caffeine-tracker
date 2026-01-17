import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String name;
  final int caffeine;
  final VoidCallback onAdd;

  const DrinkCard({super.key, required this.name, required this.caffeine, required this.onAdd});

  static List<Widget> predefined(Function(int) onAdd) => [
        DrinkCard(name: 'Espresso', caffeine: 63, onAdd: () => onAdd(63)),
        DrinkCard(name: 'Cappuccino', caffeine: 75, onAdd: () => onAdd(75)),
        DrinkCard(name: 'Latte', caffeine: 75, onAdd: () => onAdd(75)),
        DrinkCard(name: 'Americano', caffeine: 95, onAdd: () => onAdd(95)),
        DrinkCard(name: 'Filter', caffeine: 120, onAdd: () => onAdd(120)),
        DrinkCard(name: 'Instant', caffeine: 60, onAdd: () => onAdd(60)),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Hero(
      tag: name,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$caffeine mg',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                onPressed: onAdd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}