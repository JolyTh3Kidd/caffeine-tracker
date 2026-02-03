import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String id;
  final String name;
  final int caffeine;
  final String iconName;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;

  const DrinkCard({
    super.key,
    required this.id,
    required this.name,
    required this.caffeine,
    this.iconName = 'local_cafe',
    required this.onAdd,
    this.onEdit,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'coffee':
        return Icons.coffee;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'coffee_maker':
        return Icons.coffee_maker;
      case 'bolt':
        return Icons.bolt;
      case 'icecream':
        return Icons.icecream;
      case 'local_cafe':
      default:
        return Icons.local_cafe;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Hero(
        tag: 'drink_card_$id',
        child: Container(
          // Let the parent control width/margin
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(iconName),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$caffeine mg',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.7),
                          ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          foregroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
