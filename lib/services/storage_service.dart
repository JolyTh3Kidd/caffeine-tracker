import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink.dart';
import '../models/drink_entry.dart';
import '../models/custom_drink.dart' as custom;
import '../models/predefined_drink.dart';
import 'widget_service.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (_prefs != null) return;
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  static String _getTodayKey() {
    final now = DateTime.now();
    return 'caffeine_${now.year}_${now.month}_${now.day}';
  }

  static String _getDrinkEntriesKey(DateTime date) {
    return 'drinks_${date.year}_${date.month}_${date.day}';
  }

  static int get todayCaffeine {
    final key = _getTodayKey();
    return _prefs?.getInt(key) ?? 0;
  }

  static int get decayedCaffeine {
    final now = DateTime.now();
    final todayKey = _getTodayKey();
    final rawTotal = _prefs?.getInt(todayKey) ?? 0;

    if (rawTotal <= 0) return 0;

    // We'll calculate decay from all entries today
    final entries = getDrinkEntriesForDate(now);
    if (entries.isEmpty) return rawTotal;

    double currentMg = 0;
    const double halfLifeHours = 5.0;

    for (final entry in entries) {
      final hoursPassed = now.difference(entry.timestamp).inSeconds / 3600.0;
      if (hoursPassed < 0) {
        currentMg +=
            entry.caffeine; // Entry in future? Should not happen but safety
        continue;
      }
      // Decay formula: N(t) = N0 * (0.5 ^ (t / T1/2))
      currentMg += entry.caffeine * math.pow(0.5, hoursPassed / halfLifeHours);
    }

    return currentMg.round().clamp(0, 10000); // 10000 is a safe upper bound
  }

  static Future<void> addCaffeine(int mg,
      {String drinkName = 'Unknown'}) async {
    final key = _getTodayKey();
    final now = DateTime.now();

    // Add to total
    final newTotal = todayCaffeine + mg;
    await _prefs?.setInt(key, newTotal < 0 ? 0 : newTotal);

    // Add drink entry
    final entry = DrinkEntry(name: drinkName, caffeine: mg, timestamp: now);
    final entriesKey = _getDrinkEntriesKey(now);
    final entries = _prefs?.getStringList(entriesKey) ?? [];
    entries.add(entry.toJsonString());
    await _prefs?.setStringList(entriesKey, entries);

    // Sync widget if it's today
    if (key == _getTodayKey()) {
      await WidgetService.updateWidget(totalMg: newTotal);
    }
  }

  // --- NEW METHOD START ---
  static Future<void> deleteDrink(
      DateTime date, DrinkEntry entryToDelete) async {
    final entriesKey = _getDrinkEntriesKey(date);
    final rawList = _prefs?.getStringList(entriesKey) ?? [];

    // Convert to objects
    final entries = rawList.map((e) => DrinkEntry.fromJsonString(e)).toList();

    // Remove the specific entry (matching by timestamp ensures uniqueness)
    entries.removeWhere(
        (e) => e.timestamp.isAtSameMomentAs(entryToDelete.timestamp));

    // Save updated list
    await _prefs?.setStringList(
        entriesKey, entries.map((e) => e.toJsonString()).toList());

    // Recalculate total for that day
    final newTotal = entries.fold<int>(0, (sum, e) => sum + e.caffeine);

    // Update total key
    final totalKey = 'caffeine_${date.year}_${date.month}_${date.day}';
    await _prefs?.setInt(totalKey, newTotal);

    // Sync widget if it's today
    final todayKey = _getTodayKey();
    if (totalKey == todayKey) {
      await WidgetService.updateWidget(totalMg: newTotal);
    }
  }
  // --- NEW METHOD END ---
  // --- NEW METHOD END ---

  static Future<void> updateTodayTotal(int amount) async {
    final key = _getTodayKey();
    final newTotal = todayCaffeine + amount;
    // Don't allow negative total
    await _prefs?.setInt(key, newTotal < 0 ? 0 : newTotal);
  }

  static Future<void> resetDay() async {
    final key = _getTodayKey();
    await _prefs?.setInt(key, 0);

    // Also clear entries for today
    final now = DateTime.now();
    final entriesKey = _getDrinkEntriesKey(now);
    await _prefs?.remove(entriesKey);

    await WidgetService.updateWidget(totalMg: 0);
  }

  // Get history of caffeine intake
  static Map<String, int> getCaffeineHistory() {
    final history = <String, int>{};
    final allKeys = _prefs?.getKeys() ?? {};

    for (final key in allKeys) {
      if (key.startsWith('caffeine_')) {
        final value = _prefs?.getInt(key);
        if (value != null) {
          history[key] = value;
        }
      }
    }
    return history;
  }

  // Get caffeine for a specific date (format: 'caffeine_YYYY_MM_DD')
  static int getCaffeineForDate(String dateKey) {
    return _prefs?.getInt(dateKey) ?? 0;
  }

  // Get caffeine for a specific DateTime
  static int getCaffeineForDateTime(DateTime date) {
    final key = 'caffeine_${date.year}_${date.month}_${date.day}';
    return _prefs?.getInt(key) ?? 0;
  }

  // Get drink entries for a specific date
  static List<DrinkEntry> getDrinkEntriesForDate(DateTime date) {
    final entriesKey = _getDrinkEntriesKey(date);
    final entries = _prefs?.getStringList(entriesKey) ?? [];
    try {
      return entries.map((e) => DrinkEntry.fromJsonString(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static List<Drink> get customDrinks {
    final raw = _prefs?.getStringList('custom') ?? [];
    return raw.map((e) => Drink.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveCustomDrinks(List<Drink> drinks) async {
    await _prefs?.setStringList(
      'custom',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static int get caffeineLimit => _prefs?.getInt('limit') ?? 400;

  static List<custom.CustomDrink> get customDrinksList {
    final raw = _prefs?.getStringList('customDrinks') ?? [];
    return raw
        .map((e) =>
            custom.CustomDrink.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addCustomDrink(custom.CustomDrink drink) async {
    final drinks = customDrinksList;
    drinks.add(drink);
    await _prefs?.setStringList(
      'customDrinks',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<void> removeCustomDrink(String id) async {
    final drinks = customDrinksList;
    drinks.removeWhere((d) => d.id == id);
    await _prefs?.setStringList(
      'customDrinks',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<void> updateCustomDrink(custom.CustomDrink drink) async {
    final drinks = customDrinksList;
    final index = drinks.indexWhere((d) => d.id == drink.id);
    if (index != -1) {
      drinks[index] = drink;
      await _prefs?.setStringList(
        'customDrinks',
        drinks.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
  }

  // Get modified predefined drinks
  static Map<String, dynamic> getModifiedPredefinedDrink(String id) {
    final raw = _prefs?.getString('predefined_$id');
    if (raw != null) {
      return jsonDecode(raw) as Map<String, dynamic>;
    }
    return {};
  }

  // Save modifications to predefined drink
  static Future<void> updatePredefinedDrink(
      String id, String name, int caffeine, String icon) async {
    final data = {
      'id': id,
      'name': name,
      'caffeine': caffeine,
      'icon': icon,
    };
    await _prefs?.setString('predefined_$id', jsonEncode(data));
  }

  // Get all predefined drinks (with modifications applied)
  static List<PredefinedDrink> getPredefinedDrinks() {
    return PredefinedDrink.defaults
        .where((d) => !isPredefinedDrinkDeleted(d.id))
        .map((drink) {
      final modified = getModifiedPredefinedDrink(drink.id);
      if (modified.isNotEmpty) {
        return PredefinedDrink(
          id: drink.id,
          name: modified['name'] as String,
          caffeine: modified['caffeine'] as int,
          icon: modified['icon'] as String? ?? drink.icon,
          isModified: true,
        );
      }
      return drink;
    }).toList();
  }

  // Delete (hide) a predefined drink
  static Future<void> deletePredefinedDrink(String id) async {
    await _prefs?.setStringList(
      'deleted_predefined',
      ((_prefs?.getStringList('deleted_predefined') ?? [])..add(id)),
    );
  }

  // Restore a deleted predefined drink
  static Future<void> restorePredefinedDrink(String id) async {
    final deleted = _prefs?.getStringList('deleted_predefined') ?? [];
    deleted.removeWhere((d) => d == id);
    await _prefs?.setStringList('deleted_predefined', deleted);
  }

  // Check if predefined drink is deleted
  static bool isPredefinedDrinkDeleted(String id) {
    final deleted = _prefs?.getStringList('deleted_predefined') ?? [];
    return deleted.contains(id);
  }

  static Future<void> setLimit(int value) async {
    await _prefs?.setInt('limit', value);
    await WidgetService.updateWidget(limit: value);
  }

  static Future<void> setThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }

  static String get themeMode => _prefs?.getString('theme_mode') ?? 'dark';
}
