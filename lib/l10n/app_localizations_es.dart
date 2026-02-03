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

  @override
  String get hintDrinkName => 'e.g., Latte';

  @override
  String get hintCaffeine => 'e.g., 95';

  @override
  String get unitMg => 'mg';

  @override
  String get saveDrink => 'Guardar Bebida';

  @override
  String get filterByDate => 'Filtrar por Fecha';

  @override
  String filteredLabel(Object label) {
    return 'Filtrado: $label';
  }

  @override
  String totalLabel(Object amount) {
    return 'Total: $amount mg';
  }

  @override
  String get clearFilter => 'Limpiar Filtro';

  @override
  String get noRecordsFound => 'No se encontraron registros';

  @override
  String get tryDifferentDateRange =>
      'Prueba a seleccionar un intervalo de fechas diferente.';

  @override
  String overLimit(Object amount) {
    return 'Por encima del límite por $amount mg';
  }

  @override
  String get withinLimit => 'Dentro del límite';

  @override
  String get noDrinkRecords => 'No hay registros de bebidas';

  @override
  String get specificDay => 'Día Específico';

  @override
  String get dateRange => 'Rango de Fecha';

  @override
  String get specificMonth => 'Mes Específico';

  @override
  String get selectMonth => 'SELECCIONAR MES (ESCOGE CUALQUIER DIA)';

  @override
  String get deleteDrinkTitle => 'Eliminar Bebida?';

  @override
  String deleteDrinkContent(Object drinkName) {
    return '¿Estás seguro de que quieres eliminar \"$drinkName\"?';
  }

  @override
  String confirmAddTitle(Object drinkName) {
    return 'Añadir $drinkName?';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get editDefaultDrink => 'Editar Bebida Predeterminada';

  @override
  String get invalidCaffeineNumber =>
      'Por favor ingresa un número válido para la cafeína';

  @override
  String get errorSavingDrink =>
      'Error al guardar la bebida. Por favor intenta de nuevo.';

  @override
  String get deleteDrinkTooltip => 'Eliminar bebida';

  @override
  String get quickAdd => 'Añadir rápidamente';

  @override
  String get manualAdd => 'Añadir Manualmente';

  @override
  String get manualReduce => 'Reducción Manual';

  @override
  String get remaining => 'Restante';

  @override
  String get statusOverLimit => 'Por encima del límite';

  @override
  String dailyGoalPercent(Object percent) {
    return '$percent% del Objetivo Diario';
  }

  @override
  String get chooseIcon => 'Seleccionar icono';

  @override
  String get editDrinkIcon => 'Editar icono de bebida';
}
