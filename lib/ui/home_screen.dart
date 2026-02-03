import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../widgets/drink_card.dart';
import '../ui/caffeine_overview.dart';
import '../l10n/app_localizations.dart';
import '../models/custom_drink.dart';
import '../models/predefined_drink.dart';
import 'add_custom_drink_screen.dart';
import 'edit_drink_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  const HomeScreen(
      {super.key, required this.onThemeChanged, required this.onLocaleChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int total = StorageService.todayCaffeine;
  int limit = StorageService.caffeineLimit;
  late List<CustomDrink> customDrinks;
  late List<PredefinedDrink> predefinedDrinks;

  @override
  void initState() {
    super.initState();
    customDrinks = StorageService.customDrinksList;
    predefinedDrinks = StorageService.getPredefinedDrinks();
  }

  void _add(int mg, {String drinkName = 'Unknown'}) {
    HapticFeedback.mediumImpact();
    setState(() {
      StorageService.addCaffeine(mg, drinkName: drinkName);
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

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.language ?? 'Choose Language',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildLanguageOption('🇺🇸 English', 'en'),
            _buildLanguageOption('🇰🇿 Қазақша', 'kk'),
            _buildLanguageOption('🇻🇳 Tiếng Việt', 'vi'),
            _buildLanguageOption('🇨🇳 中文', 'zh'),
            _buildLanguageOption('🇪🇸 Español', 'es'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String code) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(label),
      onTap: () {
        widget.onLocaleChanged(Locale(code));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageBottomSheet,
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(CupertinoIcons.calendar),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              ),
            ),
          ),
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
            CaffeineOverviewCard(
              total: total,
              limit: limit,
              onManualAdjustment: (amount) {
                HapticFeedback.lightImpact();
                setState(() {
                  StorageService.updateTodayTotal(amount);
                  total = StorageService.todayCaffeine;
                });
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  ...predefinedDrinks.map(
                    (drink) {
                      String getName() {
                        if (drink.isModified) return drink.name;
                        switch (drink.id) {
                          case 'espresso':
                            return l?.drinkEspresso ?? drink.name;
                          case 'cappuccino':
                            return l?.drinkCappuccino ?? drink.name;
                          case 'latte':
                            return l?.drinkLatte ?? drink.name;
                          case 'americano':
                            return l?.drinkAmericano ?? drink.name;
                          case 'filter':
                            return l?.drinkFilter ?? drink.name;
                          case 'instant':
                            return l?.drinkInstant ?? drink.name;
                          default:
                            return drink.name;
                        }
                      }

                      final name = getName();

                      return DrinkCard(
                        name: name,
                        caffeine: drink.caffeine,
                        onAdd: () => _add(drink.caffeine, drinkName: name),
                        onEdit: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => EditDrinkScreen(
                                drinkId: drink.id,
                                initialName: name,
                                initialCaffeine: drink.caffeine,
                                isPredefined: true,
                                onSave: () {
                                  setState(() {
                                    predefinedDrinks =
                                        StorageService.getPredefinedDrinks();
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
                        },
                      );
                    },
                  ),
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
                    (drink) => DrinkCard(
                      name: drink.name,
                      caffeine: drink.caffeine,
                      onAdd: () => _add(drink.caffeine, drinkName: drink.name),
                      onEdit: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => EditDrinkScreen(
                              drinkId: drink.id,
                              initialName: drink.name,
                              initialCaffeine: drink.caffeine,
                              isPredefined: false,
                              onSave: () {
                                setState(() {
                                  customDrinks =
                                      StorageService.customDrinksList;
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
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: _openAddCustomDrink,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)?.addCustom ??
                          'Add Custom Drink'),
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
                title: Text(AppLocalizations.of(context)!.systemTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.lightTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.darkTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.caffeineLimit),
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
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                StorageService.setLimit(tempLimit);
                this.setState(() {
                  limit = tempLimit;
                });
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }
}
