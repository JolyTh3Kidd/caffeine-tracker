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
}
