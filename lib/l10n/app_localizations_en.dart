// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Caffeine Tracker';

  @override
  String get historyTitle => 'Caffeine History';

  @override
  String get caffeineLimit => 'Caffeine Limit';

  @override
  String get noHistory => 'No history yet';

  @override
  String get startTracking => 'Start tracking your caffeine intake';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get drinksConsumed => 'Drinks Consumed';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String deleteConfirmation(Object drinkName, Object amount) {
    return 'Remove $drinkName ($amount mg) from history?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save Changes';

  @override
  String get editDrink => 'Edit Drink';

  @override
  String get drinkName => 'Drink Name';

  @override
  String get caffeineContent => 'Caffeine Content';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get dailyLimit => 'Daily Limit';

  @override
  String get addCustom => 'Add Custom Drink';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get drinkEspresso => 'Espresso';

  @override
  String get drinkCappuccino => 'Cappuccino';

  @override
  String get drinkLatte => 'Latte';

  @override
  String get drinkAmericano => 'Americano';

  @override
  String get drinkFilter => 'Filter';

  @override
  String get drinkInstant => 'Instant';
}
