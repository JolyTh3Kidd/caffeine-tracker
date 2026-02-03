// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rastreador de Cafeína';

  @override
  String get historyTitle => 'Historial de Cafeína';

  @override
  String get caffeineLimit => 'Límite de Cafeína';

  @override
  String get noHistory => 'Sin historial aún';

  @override
  String get startTracking => 'Empieza a registrar tu consumo';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get drinksConsumed => 'Bebidas Consumidas';

  @override
  String get deleteEntry => 'Eliminar Entrada';

  @override
  String deleteConfirmation(Object drinkName, Object amount) {
    return '¿Eliminar $drinkName ($amount mg) del historial?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar Cambios';

  @override
  String get editDrink => 'Editar Bebida';

  @override
  String get drinkName => 'Nombre de Bebida';

  @override
  String get caffeineContent => 'Contenido de Cafeína';

  @override
  String get fillAllFields => 'Por favor llena todos los campos';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get dailyLimit => 'Límite Diario';

  @override
  String get addCustom => 'Añadir bebida personalizada';

  @override
  String get systemTheme => 'Tema Del Sistema';

  @override
  String get lightTheme => 'Tema Claro';

  @override
  String get darkTheme => 'Tema Oscuro';

  @override
  String get drinkEspresso => 'Espresso';

  @override
  String get drinkCappuccino => 'Capuchino';

  @override
  String get drinkLatte => 'Latte';

  @override
  String get drinkAmericano => 'Americano';

  @override
  String get drinkFilter => 'Filtro';

  @override
  String get drinkInstant => 'Instantáneo';
}
