import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('kk'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Caffeine Tracker'**
  String get appTitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Caffeine History'**
  String get historyTitle;

  /// No description provided for @caffeineLimit.
  ///
  /// In en, this message translates to:
  /// **'Caffeine Limit'**
  String get caffeineLimit;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistory;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your caffeine intake'**
  String get startTracking;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @drinksConsumed.
  ///
  /// In en, this message translates to:
  /// **'Drinks Consumed'**
  String get drinksConsumed;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove {drinkName} ({amount} mg) from history?'**
  String deleteConfirmation(Object drinkName, Object amount);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save;

  /// No description provided for @editDrink.
  ///
  /// In en, this message translates to:
  /// **'Edit Drink'**
  String get editDrink;

  /// No description provided for @drinkName.
  ///
  /// In en, this message translates to:
  /// **'Drink Name'**
  String get drinkName;

  /// No description provided for @caffeineContent.
  ///
  /// In en, this message translates to:
  /// **'Caffeine Content'**
  String get caffeineContent;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @dailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Limit'**
  String get dailyLimit;

  /// No description provided for @addCustom.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Drink'**
  String get addCustom;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @drinkEspresso.
  ///
  /// In en, this message translates to:
  /// **'Espresso'**
  String get drinkEspresso;

  /// No description provided for @drinkCappuccino.
  ///
  /// In en, this message translates to:
  /// **'Cappuccino'**
  String get drinkCappuccino;

  /// No description provided for @drinkLatte.
  ///
  /// In en, this message translates to:
  /// **'Latte'**
  String get drinkLatte;

  /// No description provided for @drinkAmericano.
  ///
  /// In en, this message translates to:
  /// **'Americano'**
  String get drinkAmericano;

  /// No description provided for @drinkFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get drinkFilter;

  /// No description provided for @drinkInstant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get drinkInstant;

  /// No description provided for @hintDrinkName.
  ///
  /// In en, this message translates to:
  /// **'e.g., Iced Latte'**
  String get hintDrinkName;

  /// No description provided for @hintCaffeine.
  ///
  /// In en, this message translates to:
  /// **'e.g., 95'**
  String get hintCaffeine;

  /// No description provided for @unitMg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get unitMg;

  /// No description provided for @saveDrink.
  ///
  /// In en, this message translates to:
  /// **'Save Drink'**
  String get saveDrink;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @filteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Filtered: {label}'**
  String filteredLabel(Object label);

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount} mg'**
  String totalLabel(Object amount);

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @tryDifferentDateRange.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different date range'**
  String get tryDifferentDateRange;

  /// No description provided for @overLimit.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount} mg'**
  String overLimit(Object amount);

  /// No description provided for @withinLimit.
  ///
  /// In en, this message translates to:
  /// **'Within limit'**
  String get withinLimit;

  /// No description provided for @noDrinkRecords.
  ///
  /// In en, this message translates to:
  /// **'No drink records'**
  String get noDrinkRecords;

  /// No description provided for @specificDay.
  ///
  /// In en, this message translates to:
  /// **'Specific Day'**
  String get specificDay;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @specificMonth.
  ///
  /// In en, this message translates to:
  /// **'Specific Month'**
  String get specificMonth;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'SELECT MONTH (PICK ANY DAY)'**
  String get selectMonth;

  /// No description provided for @deleteDrinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Drink?'**
  String get deleteDrinkTitle;

  /// No description provided for @deleteDrinkContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{drinkName}\"?'**
  String deleteDrinkContent(Object drinkName);

  /// No description provided for @confirmAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {drinkName}?'**
  String confirmAddTitle(Object drinkName);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @editDefaultDrink.
  ///
  /// In en, this message translates to:
  /// **'Edit Default Drink'**
  String get editDefaultDrink;

  /// No description provided for @invalidCaffeineNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number for caffeine'**
  String get invalidCaffeineNumber;

  /// No description provided for @errorSavingDrink.
  ///
  /// In en, this message translates to:
  /// **'Error saving drink. Please try again.'**
  String get errorSavingDrink;

  /// No description provided for @deleteDrinkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete drink'**
  String get deleteDrinkTooltip;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @manualAdd.
  ///
  /// In en, this message translates to:
  /// **'Manual Add'**
  String get manualAdd;

  /// No description provided for @manualReduce.
  ///
  /// In en, this message translates to:
  /// **'Manual Reduce'**
  String get manualReduce;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @statusOverLimit.
  ///
  /// In en, this message translates to:
  /// **'Over Limit'**
  String get statusOverLimit;

  /// No description provided for @dailyGoalPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of Daily Goal'**
  String dailyGoalPercent(Object percent);

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get chooseIcon;

  /// No description provided for @editDrinkIcon.
  ///
  /// In en, this message translates to:
  /// **'Edit Drink Icon'**
  String get editDrinkIcon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'kk', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'kk':
      return AppLocalizationsKk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
