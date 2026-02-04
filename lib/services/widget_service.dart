import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:convert';
import 'storage_service.dart';

class WidgetService {
  // static const String _groupId = 'group.com.jolyth3kidd.caffeine_tracker';
  static const String _androidWidgetName =
      'com.jolyth3kidd.caffeine_tracker.CaffeineWidgetProvider';
  static const String _iosWidgetName = 'CaffeineWidget';

  static Future<void> updateWidget(
      {int? totalMg, int? limit, bool? isDarkMode}) async {
    final currentTotal = totalMg ?? StorageService.todayCaffeine;
    final currentLimit = limit ?? StorageService.caffeineLimit;
    final darkMode = isDarkMode ?? (StorageService.themeMode != 'light');

    debugPrint(
        'DEBUG: Syncing widget data: total=$currentTotal, limit=$currentLimit, dark=$darkMode');

    try {
      await HomeWidget.saveWidgetData<int>('totalMg', currentTotal);
      await HomeWidget.saveWidgetData<int>('limit', currentLimit);
      await HomeWidget.saveWidgetData<bool>('isDarkMode', darkMode);

      // Save today's entries for decay calculation in Kotlin
      final now = DateTime.now();
      final entries = StorageService.getDrinkEntriesForDate(now);
      final entriesJson = jsonEncode(entries.map((e) => e.toJson()).toList());
      final entriesKey = 'drinks_${now.year}_${now.month}_${now.day}';
      await HomeWidget.saveWidgetData<String>(entriesKey, entriesJson);

      final result = await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
      debugPrint('DEBUG: HomeWidget.updateWidget returned: $result');
    } catch (e) {
      debugPrint('ERROR: Failed to update HomeWidget: $e');
    }
  }

  static Future<void> initializeBackground() async {
    debugPrint('DEBUG: Initializing WidgetService background...');
    await HomeWidget.registerInteractivityCallback(backgroundCallback);
  }
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  debugPrint('DEBUG: Widget background callback triggered with URI: $uri');
  if (uri == null) return;

  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (uri.scheme == 'home_widget' || uri.scheme == 'homeWidget') {
      // Check host first, then path if host is empty
      final payload =
          (uri.host.isNotEmpty ? uri.host : uri.path).replaceAll('/', '');
      debugPrint('DEBUG: Detected widget payload: $payload');

      if (payload == 'refresh') {
        await StorageService.init();
        debugPrint('DEBUG: Refreshing widget data from background callback');
        await WidgetService.updateWidget();
        debugPrint('DEBUG: Widget updated via refresh button');
      } else {
        debugPrint('DEBUG: Unknown payload: $payload');
      }
    } else {
      debugPrint('DEBUG: Unsupported scheme: ${uri.scheme}');
    }
  } catch (e, stack) {
    debugPrint('ERROR: Exception in backgroundCallback: $e');
    debugPrint(stack.toString());
  }
}
