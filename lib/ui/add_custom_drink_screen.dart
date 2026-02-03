import 'package:flutter/material.dart';
import 'package:caffeine_tracker/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../models/custom_drink.dart';
import '../services/storage_service.dart';

class AddCustomDrinkScreen extends StatefulWidget {
  final Function(CustomDrink) onSave;

  const AddCustomDrinkScreen({super.key, required this.onSave});

  @override
  State<AddCustomDrinkScreen> createState() => _AddCustomDrinkScreenState();
}

class _AddCustomDrinkScreenState extends State<AddCustomDrinkScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _caffeineController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedIcon = 'local_cafe';

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
    _nameController = TextEditingController();
    _caffeineController = TextEditingController();

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
    if (_nameController.text.isEmpty || _caffeineController.text.isEmpty) {
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

    HapticFeedback.mediumImpact();

    final drink = CustomDrink(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      caffeine: int.parse(_caffeineController.text),
      icon: _selectedIcon,
    );

    StorageService.addCustomDrink(drink);
    widget.onSave(drink);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCustom),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withValues(alpha: 0.7),
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
                  const SizedBox(height: 32),
                  // Drink name field
                  _buildInputField(
                    controller: _nameController,
                    label: AppLocalizations.of(context)!.drinkName,
                    hint: AppLocalizations.of(context)!.hintDrinkName,
                    icon: Icons.local_cafe,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  // Caffeine input field
                  _buildInputField(
                    controller: _caffeineController,
                    label: AppLocalizations.of(context)!.caffeineContent,
                    hint: AppLocalizations.of(context)!.hintCaffeine,
                    icon: Icons.bolt,
                    keyboardType: TextInputType.number,
                    isDark: isDark,
                    suffix: AppLocalizations.of(context)!.unitMg,
                  ),
                  const SizedBox(height: 24),
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
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.saveDrink,
                              style: TextStyle(
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
