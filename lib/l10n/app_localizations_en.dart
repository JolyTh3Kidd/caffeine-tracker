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

  @override
  String get hintDrinkName => 'e.g., Iced Latte';

  @override
  String get hintCaffeine => 'e.g., 95';

  @override
  String get unitMg => 'mg';

  @override
  String get saveDrink => 'Save Drink';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String filteredLabel(Object label) {
    return 'Filtered: $label';
  }

  @override
  String totalLabel(Object amount) {
    return 'Total: $amount mg';
  }

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get noRecordsFound => 'No records found';

  @override
  String get tryDifferentDateRange => 'Try selecting a different date range';

  @override
  String overLimit(Object amount) {
    return 'Over by $amount mg';
  }

  @override
  String get withinLimit => 'Within limit';

  @override
  String get noDrinkRecords => 'No drink records';

  @override
  String get specificDay => 'Specific Day';

  @override
  String get dateRange => 'Date Range';

  @override
  String get specificMonth => 'Specific Month';

  @override
  String get selectMonth => 'SELECT MONTH (PICK ANY DAY)';

  @override
  String get deleteDrinkTitle => 'Delete Drink?';

  @override
  String deleteDrinkContent(Object drinkName) {
    return 'Are you sure you want to delete \"$drinkName\"?';
  }

  @override
  String confirmAddTitle(Object drinkName) {
    return 'Add $drinkName?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get editDefaultDrink => 'Edit Default Drink';

  @override
  String get invalidCaffeineNumber =>
      'Please enter a valid number for caffeine';

  @override
  String get errorSavingDrink => 'Error saving drink. Please try again.';

  @override
  String get deleteDrinkTooltip => 'Delete drink';

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get manualAdd => 'Manual Add';

  @override
  String get manualReduce => 'Manual Reduce';

  @override
  String get remaining => 'Remaining';

  @override
  String get statusOverLimit => 'Over Limit';

  @override
  String dailyGoalPercent(Object percent) {
    return '$percent% of Daily Goal';
  }

  @override
  String get chooseIcon => 'Choose Icon';

  @override
  String get editDrinkIcon => 'Edit Drink Icon';
}
