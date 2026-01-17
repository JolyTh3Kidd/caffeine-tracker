import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drink.dart';
import '../models/custom_drink.dart' as custom;

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int get todayCaffeine => _prefs.getInt('today') ?? 0;

  static void addCaffeine(int mg) {
    _prefs.setInt('today', todayCaffeine + mg);
  }

  static void resetDay() {
    _prefs.setInt('today', 0);
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
  static void setLimit(int value) => _prefs.setInt('limit', value);
}