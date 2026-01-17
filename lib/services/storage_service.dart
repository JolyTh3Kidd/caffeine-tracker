import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink.dart';
import '../models/drink_entry.dart';
import '../models/custom_drink.dart' as custom;
import '../models/predefined_drink.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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
    return _prefs.getInt(key) ?? 0;
  }

  static void addCaffeine(int mg, {String drinkName = 'Unknown'}) {
    final key = _getTodayKey();
    final now = DateTime.now();
    
    // Add to total
    _prefs.setInt(key, todayCaffeine + mg);
    
    // Add drink entry
    final entry = DrinkEntry(name: drinkName, caffeine: mg, timestamp: now);
    final entriesKey = _getDrinkEntriesKey(now);
    final entries = _prefs.getStringList(entriesKey) ?? [];
    entries.add(entry.toJsonString());
    _prefs.setStringList(entriesKey, entries);
  }

  static void resetDay() {
    final key = _getTodayKey();
    _prefs.setInt(key, 0);
  }

  // Get history of caffeine intake
  static Map<String, int> getCaffeineHistory() {
    final history = <String, int>{};
    final allKeys = _prefs.getKeys();
    
    for (final key in allKeys) {
      if (key.startsWith('caffeine_')) {
        final value = _prefs.getInt(key);
        if (value != null) {
          history[key] = value;
        }
      }
    }
    return history;
  }

  // Get caffeine for a specific date (format: 'caffeine_YYYY_MM_DD')
  static int getCaffeineForDate(String dateKey) {
    return _prefs.getInt(dateKey) ?? 0;
  }

  // Get caffeine for a specific DateTime
  static int getCaffeineForDateTime(DateTime date) {
    final key = 'caffeine_${date.year}_${date.month}_${date.day}';
    return _prefs.getInt(key) ?? 0;
  }

  // Get drink entries for a specific date
  static List<DrinkEntry> getDrinkEntriesForDate(DateTime date) {
    final entriesKey = _getDrinkEntriesKey(date);
    final entries = _prefs.getStringList(entriesKey) ?? [];
    try {
      return entries.map((e) => DrinkEntry.fromJsonString(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static List<Drink> get customDrinks {
    final raw = _prefs.getStringList('custom') ?? [];
    return raw.map((e) => Drink.fromJson(jsonDecode(e))).toList();
  }

  static void saveCustomDrinks(List<Drink> drinks) {
    _prefs.setStringList(
      'custom',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static int get caffeineLimit => _prefs.getInt('limit') ?? 400;

  static List<custom.CustomDrink> get customDrinksList {
    final raw = _prefs.getStringList('customDrinks') ?? [];
    return raw
        .map((e) => custom.CustomDrink.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  static void addCustomDrink(custom.CustomDrink drink) {
    final drinks = customDrinksList;
    drinks.add(drink);
    _prefs.setStringList(
      'customDrinks',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static void removeCustomDrink(String id) {
    final drinks = customDrinksList;
    drinks.removeWhere((d) => d.id == id);
    _prefs.setStringList(
      'customDrinks',
      drinks.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static void updateCustomDrink(custom.CustomDrink drink) {
    final drinks = customDrinksList;
    final index = drinks.indexWhere((d) => d.id == drink.id);
    if (index != -1) {
      drinks[index] = drink;
      _prefs.setStringList(
        'customDrinks',
        drinks.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }
  }

  // Get modified predefined drinks
  static Map<String, dynamic> getModifiedPredefinedDrink(String id) {
    final raw = _prefs.getString('predefined_$id');
    if (raw != null) {
      return jsonDecode(raw) as Map<String, dynamic>;
    }
    return {};
  }

  // Save modifications to predefined drink
  static void updatePredefinedDrink(String id, String name, int caffeine) {
    final data = {'id': id, 'name': name, 'caffeine': caffeine};
    _prefs.setString('predefined_$id', jsonEncode(data));
  }

  // Get all predefined drinks (with modifications applied)
  static List<PredefinedDrink> getPredefinedDrinks() {
    return PredefinedDrink.defaults.map((drink) {
      final modified = getModifiedPredefinedDrink(drink.id);
      if (modified.isNotEmpty) {
        return PredefinedDrink(
          id: drink.id,
          name: modified['name'] as String,
          caffeine: modified['caffeine'] as int,
        );
      }
      return drink;
    }).toList();
  }

  // Delete (hide) a predefined drink
  static void deletePredefinedDrink(String id) {
    _prefs.setStringList(
      'deleted_predefined',
      ((_prefs.getStringList('deleted_predefined') ?? [])..add(id)),
    );
  }

  // Restore a deleted predefined drink
  static void restorePredefinedDrink(String id) {
    final deleted = _prefs.getStringList('deleted_predefined') ?? [];
    deleted.removeWhere((d) => d == id);
    _prefs.setStringList('deleted_predefined', deleted);
  }

  // Check if predefined drink is deleted
  static bool isPredefinedDrinkDeleted(String id) {
    final deleted = _prefs.getStringList('deleted_predefined') ?? [];
    return deleted.contains(id);
  }

  static void setLimit(int value) => _prefs.setInt('limit', value);
}