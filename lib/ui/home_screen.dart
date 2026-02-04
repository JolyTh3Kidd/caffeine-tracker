import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';
import '../services/widget_service.dart';
import '../widgets/drink_card.dart';
import '../ui/caffeine_overview.dart';
import '../l10n/app_localizations.dart';
import '../models/custom_drink.dart';
import '../models/predefined_drink.dart';
import 'add_custom_drink_screen.dart';
import 'edit_drink_screen.dart';
import 'history_screen.dart';
import '../models/drink_entry.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;
  const HomeScreen(
      {super.key, required this.onThemeChanged, required this.onLocaleChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _todayTotal = StorageService.todayCaffeine;
  int _dailyLimit = StorageService.caffeineLimit;
  late List<CustomDrink> _customDrinks;
  late List<PredefinedDrink> _predefinedDrinks;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _customDrinks = StorageService.customDrinksList;
    _predefinedDrinks = StorageService.getPredefinedDrinks();
    _todayTotal = StorageService.todayCaffeine;
    _dailyLimit = StorageService.caffeineLimit;
  }

  Future<void> _addDrink(DrinkEntry entry) async {
    HapticFeedback.mediumImpact();
    await StorageService.addCaffeine(entry.caffeine, drinkName: entry.name);
    setState(() {
      _refreshData();
    });
  }

  void _editDrink(dynamic drink, {required bool isPredefined}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EditDrinkScreen(
          drinkId: drink.id,
          initialName: drink.name,
          initialCaffeine: drink.caffeine,
          initialIcon: drink.icon,
          isPredefined: isPredefined,
          onSave: () {
            setState(() {
              _refreshData();
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

  void _openAddCustomDrink() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AddCustomDrinkScreen(
          onSave: (drink) {
            setState(() {
              _refreshData();
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

  void _showSettings() {
    int tempLimit = _dailyLimit;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.settings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.systemTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.system);
                  StorageService.setThemeMode('system');
                  final brightness = MediaQuery.of(context).platformBrightness;
                  WidgetService.updateWidget(
                      isDarkMode: brightness == Brightness.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.lightTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.light);
                  StorageService.setThemeMode('light');
                  WidgetService.updateWidget(isDarkMode: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.darkTheme),
                onTap: () {
                  widget.onThemeChanged(ThemeMode.dark);
                  StorageService.setThemeMode('dark');
                  WidgetService.updateWidget(isDarkMode: true);
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
                  _refreshData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              AppLocalizations.of(context)!.appTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: _showLanguageBottomSheet,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(
                        onHistoryChanged: () {
                          setState(() {
                            _refreshData();
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
              ),
              IconButton(
                onPressed: _showSettings,
                icon: const Icon(Icons.settings_outlined),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: CaffeineOverviewCard(
              total: _todayTotal,
              limit: _dailyLimit,
              onManualAdjustment: (amount) => _addDrink(
                DrinkEntry(
                  // id: DateTime.now().millisecondsSinceEpoch.toString(), // Removed
                  name: amount > 0 ? '__MANUAL_ADD__' : '__MANUAL_REDUCE__',
                  caffeine: amount,
                  timestamp: DateTime.now(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.quickAdd,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: _openAddCustomDrink,
                    icon: Icon(Icons.add_circle,
                        color: Theme.of(context).primaryColor),
                    tooltip: AppLocalizations.of(context)?.addCustom,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final allDrinks = [..._predefinedDrinks, ..._customDrinks];

                  if (index >= allDrinks.length) return null;

                  final dynamic drink = allDrinks[index];
                  final isPredefined = index < _predefinedDrinks.length;
                  String displayName = drink.name;
                  if (isPredefined) {
                    switch (drink.id) {
                      case 'espresso':
                        displayName =
                            AppLocalizations.of(context)!.drinkEspresso;
                        break;
                      case 'cappuccino':
                        displayName =
                            AppLocalizations.of(context)!.drinkCappuccino;
                        break;
                      case 'latte':
                        displayName = AppLocalizations.of(context)!.drinkLatte;
                        break;
                      case 'americano':
                        displayName =
                            AppLocalizations.of(context)!.drinkAmericano;
                        break;
                      case 'filter':
                        displayName = AppLocalizations.of(context)!.drinkFilter;
                        break;
                      case 'instant':
                        displayName =
                            AppLocalizations.of(context)!.drinkInstant;
                        break;
                    }
                  }

                  return DrinkCard(
                    id: drink.id,
                    name: displayName,
                    caffeine: drink.caffeine,
                    iconName: drink.icon,
                    onAdd: () => _addDrink(
                      DrinkEntry(
                        // id: DateTime.now().millisecondsSinceEpoch.toString(), // Removed
                        name: displayName,
                        caffeine: drink.caffeine,
                        timestamp: DateTime.now(),
                        // isCustom: !isPredefined, // Removed
                      ),
                    ),
                    onEdit: () => _editDrink(drink, isPredefined: isPredefined),
                  );
                },
                childCount: _predefinedDrinks.length + _customDrinks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
