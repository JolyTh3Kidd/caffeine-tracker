import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caffeine_tracker/l10n/app_localizations.dart';
import '../services/storage_service.dart';

class EditDrinkScreen extends StatefulWidget {
  final String drinkId;
  final String initialName;
  final int initialCaffeine;
  final String initialIcon;
  final bool isPredefined;
  final VoidCallback onSave;

  const EditDrinkScreen({
    super.key,
    required this.drinkId,
    required this.initialName,
    required this.initialCaffeine,
    required this.initialIcon,
    required this.isPredefined,
    required this.onSave,
  });

  @override
  State<EditDrinkScreen> createState() => _EditDrinkScreenState();
}

class _EditDrinkScreenState extends State<EditDrinkScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _caffeineController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late String _selectedIcon;

  final List<String> _availableIcons = [
    'local_cafe',
    'coffee',
    'emoji_food_beverage',
    'coffee_maker',
    'bolt',
    'icecream',
  ];

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _caffeineController =
        TextEditingController(text: widget.initialCaffeine.toString());

    _selectedIcon = widget.initialIcon;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caffeineController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveDrink() {
    final name = _nameController.text.trim();
    final caffeineStr = _caffeineController.text.trim();

    // 1. Validate Empty Fields
    if (name.isEmpty || caffeineStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fillAllFields),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    // 2. Validate Caffeine is a Number
    final caffeine = int.tryParse(caffeineStr);
    if (caffeine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // invalidCaffeineNumber
          content: Text(AppLocalizations.of(context)!.invalidCaffeineNumber),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      if (widget.isPredefined) {
        StorageService.updatePredefinedDrink(
          widget.drinkId,
          name,
          caffeine,
          _selectedIcon,
        );
        // Also restore if it was deleted
        StorageService.restorePredefinedDrink(widget.drinkId);
      } else {
        // Safe Custom Drink Update
        final customDrinks = StorageService.customDrinksList;

        // Ensure we can find the drink before trying to update it
        final drinkIndex =
            customDrinks.indexWhere((d) => d.id == widget.drinkId);

        if (drinkIndex != -1) {
          final existingDrink = customDrinks[drinkIndex];
          final updatedDrink = existingDrink.copyWith(
            name: name,
            caffeine: caffeine,
            icon: _selectedIcon,
          );
          StorageService.updateCustomDrink(updatedDrink);
        } else {
          throw Exception("Drink not found");
        }
      }

      widget.onSave();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // errorSavingDrink
          content: Text(AppLocalizations.of(context)!.errorSavingDrink),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  void _deleteDrink() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // deleteDrinkTitle
        title: Text(AppLocalizations.of(context)!.deleteDrinkTitle),
        // deleteDrinkContent
        content: Text(AppLocalizations.of(context)!
            .deleteDrinkContent(widget.initialName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            // cancel
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              if (widget.isPredefined) {
                StorageService.deletePredefinedDrink(widget.drinkId);
              } else {
                StorageService.removeCustomDrink(widget.drinkId);
              }
              widget.onSave(); // Ensure parent updates on delete too
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: Text(
              // delete
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.isPredefined
            ? AppLocalizations.of(context)!.editDefaultDrink
            : AppLocalizations.of(context)!.editDrink),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[600]),
            onPressed: _deleteDrink,
            // deleteDrinkTooltip
            tooltip: AppLocalizations.of(context)!.deleteDrinkTooltip,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Decorative icon
                  Hero(
                    tag: 'drink_icon_${widget.drinkId}',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.7),
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        _getIconData(_selectedIcon),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Icon Selection
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        AppLocalizations.of(context)!.chooseIcon,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableIcons.map((iconName) {
                      final isSelected = _selectedIcon == iconName;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = iconName;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _getIconData(iconName),
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Drink name field
                  _buildInputField(
                    controller: _nameController,
                    // drinkName
                    label: AppLocalizations.of(context)!.drinkName,
                    // hintDrinkName
                    hint: AppLocalizations.of(context)!.hintDrinkName,
                    icon: Icons.local_cafe,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  // Caffeine input field
                  _buildInputField(
                    controller: _caffeineController,
                    // caffeineContent
                    label: AppLocalizations.of(context)!.caffeineContent,
                    // hintCaffeine
                    hint: AppLocalizations.of(context)!.hintCaffeine,
                    icon: Icons.bolt,
                    keyboardType: TextInputType.number,
                    isDark: isDark,
                    // unitMg
                    suffix: AppLocalizations.of(context)!.unitMg,
                  ),
                  const SizedBox(height: 36),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saveDrink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              // save
                              AppLocalizations.of(context)!.save,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        // cancel
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
    String? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
          suffixText: suffix,
          suffixStyle: TextStyle(
            color: Colors.brown[600],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
