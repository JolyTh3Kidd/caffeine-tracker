// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Кофеин Трекері';

  @override
  String get historyTitle => 'Кофеин Тарихы';

  @override
  String get caffeineLimit => 'Кофеин Шегі';

  @override
  String get noHistory => 'Әзірге тарих жоқ';

  @override
  String get startTracking => 'Кофеин қабылдауды қадағалауды бастаңыз';

  @override
  String get today => 'Бүгін';

  @override
  String get yesterday => 'Кеше';

  @override
  String get drinksConsumed => 'Ішілген сусындар';

  @override
  String get deleteEntry => 'Жазбаны өшіру';

  @override
  String deleteConfirmation(Object drinkName, Object amount) {
    return '$drinkName ($amount мг) тарихтан өшірілсін бе?';
  }

  @override
  String get cancel => 'Болдырмау';

  @override
  String get delete => 'Өшіру';

  @override
  String get save => 'Сақтау';

  @override
  String get editDrink => 'Сусынды өңдеу';

  @override
  String get drinkName => 'Сусын атауы';

  @override
  String get caffeineContent => 'Кофеин мөлшері';

  @override
  String get fillAllFields => 'Барлық өрістерді толтырыңыз';

  @override
  String get settings => 'Баптаулар';

  @override
  String get language => 'Тіл';

  @override
  String get theme => 'Тақырып';

  @override
  String get selectLanguage => 'Тілді таңдаңыз';

  @override
  String get dailyLimit => 'Күндізгі шектеу';

  @override
  String get addCustom => 'Жеке сусын қосу';

  @override
  String get systemTheme => 'Жүйе Түсі';

  @override
  String get lightTheme => 'Жарық Түсі';

  @override
  String get darkTheme => 'Қара Түсі';

  @override
  String get drinkEspresso => 'Эспрессо';

  @override
  String get drinkCappuccino => 'Капучино';

  @override
  String get drinkLatte => 'Латте';

  @override
  String get drinkAmericano => 'Американо';

  @override
  String get drinkFilter => 'Сүзгі кофе';

  @override
  String get drinkInstant => 'Ерігіш кофе';

  @override
  String get hintDrinkName => 'e.g., Суық Латте';

  @override
  String get hintCaffeine => 'e.g., 95';

  @override
  String get unitMg => 'mg';

  @override
  String get saveDrink => 'Сақтау';

  @override
  String get filterByDate => 'Тірі таңдау';

  @override
  String filteredLabel(Object label) {
    return 'Тірі: $label';
  }

  @override
  String totalLabel(Object amount) {
    return 'Жалпы: $amount mg';
  }

  @override
  String get clearFilter => 'Тірін тазалаш';

  @override
  String get noRecordsFound => 'Ішімдіктер туралы жазбалар жоқ';

  @override
  String get tryDifferentDateRange => 'Басқа тірін таңдаңыз';

  @override
  String overLimit(Object amount) {
    return 'Шектен тыс $amount mg';
  }

  @override
  String get withinLimit => 'Шектен тыс';

  @override
  String get noDrinkRecords => 'Ішімдіктер туралы жазбалар жоқ';

  @override
  String get specificDay => 'Нақты күн';

  @override
  String get dateRange => 'Дата тірі';

  @override
  String get specificMonth => 'Нақты ай';

  @override
  String get selectMonth => 'Суранып таңдаңыз';

  @override
  String get deleteDrinkTitle => 'Сусын жоюға қабылдаңыз?';

  @override
  String deleteDrinkContent(Object drinkName) {
    return 'Сусын \"$drinkName\" жоюға қабылдаңыз?';
  }

  @override
  String confirmAddTitle(Object drinkName) {
    return 'Қосу $drinkName?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get editDefaultDrink => 'Редакциялау';

  @override
  String get invalidCaffeineNumber =>
      'Кофеин мөлшерінің бір неімді санын еңгізіңіз';

  @override
  String get errorSavingDrink => 'Сусын сақтау қатысы. Қайта басқарай.';

  @override
  String get deleteDrinkTooltip => 'Сусынды жою';

  @override
  String get quickAdd => 'Қолмен қосу';

  @override
  String get manualAdd => 'Қолмен қосу';

  @override
  String get manualReduce => 'Қолмен азайту';

  @override
  String get remaining => 'Қалған';

  @override
  String get statusOverLimit => 'Шектен тыс';

  @override
  String dailyGoalPercent(Object percent) {
    return 'Күнделікті мақсаттың $percent%';
  }

  @override
  String get chooseIcon => 'Иконканы таңдаңыз';

  @override
  String get editDrinkIcon => 'Иконканы өңдеу';
}
