import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../widgets/drink_card.dart';
import '../ui/caffeine_overview.dart';
import '../l10n/app_localizations.dart';
import '../models/custom_drink.dart';
import 'add_custom_drink_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int total = StorageService.todayCaffeine;
  int limit = StorageService.caffeineLimit;
  late List<CustomDrink> customDrinks;

  @override
  void initState() {
    super.initState();
    customDrinks = StorageService.customDrinksList;
  }

  void _add(int mg) {
    HapticFeedback.mediumImpact();
    setState(() {
      StorageService.addCaffeine(mg);
      total = StorageService.todayCaffeine;
    });
  }

  void _openAddCustomDrink() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AddCustomDrinkScreen(
          onSave: (drink) {
            setState(() {
              customDrinks = StorageService.customDrinksList;
            });
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l.appName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(CupertinoIcons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CaffeineOverviewCard(total: total, limit: limit),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  ...DrinkCard.predefined(_add),
                  if (customDrinks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(
                        'Custom Drinks',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ...customDrinks.map(
                    (drink) => GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Drink?'),
                            content: Text('Remove "${drink.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  StorageService.removeCustomDrink(drink.id);
                                  setState(() {
                                    customDrinks =
                                        StorageService.customDrinksList;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: DrinkCard(
                        name: drink.name,
                        caffeine: drink.caffeine,
                        onAdd: () => _add(drink.caffeine),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: _openAddCustomDrink,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Custom Drink'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    int tempLimit = limit;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('System Theme'),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light Theme'),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text('Caffeine Limit'),
              Slider(
                min: 100,
                max: 600,
                divisions: 10,
                value: tempLimit.toDouble(),
                label: '$tempLimit mg',
                onChanged: (v) {
                  setState(() {
                    tempLimit = v.toInt();
                  });
                },
              ),
              Text('$tempLimit mg'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                StorageService.setLimit(tempLimit);
                this.setState(() {
                  limit = tempLimit;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}