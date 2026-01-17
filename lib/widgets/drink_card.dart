import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String name;
  final int caffeine;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;

  const DrinkCard({
    super.key,
    required this.name,
    required this.caffeine,
    required this.onAdd,
    this.onEdit,
  });

  static List<Widget> predefined(
    Function(int, {String drinkName}) onAdd,
    Function(String, String, int)? onEdit,
  ) {
    final drinks = [
      ('espresso', 'Espresso', 63),
      ('cappuccino', 'Cappuccino', 75),
      ('latte', 'Latte', 75),
      ('americano', 'Americano', 95),
      ('filter', 'Filter', 120),
      ('instant', 'Instant', 60),
    ];

    return drinks.map((drink) {
      return DrinkCard(
        name: drink.$2,
        caffeine: drink.$3,
        onAdd: () => onAdd(drink.$3, drinkName: drink.$2),
        onEdit: onEdit != null ? () => onEdit(drink.$1, drink.$2, drink.$3) : null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onEdit,
      child: Hero(
        tag: name,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFEEEEEE),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$caffeine mg',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF5F5F5),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded, size: 20),
                    color: const Color(0xFF6F4E37),
                    onPressed: onAdd,
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}