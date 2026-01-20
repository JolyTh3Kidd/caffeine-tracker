import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/storage_service.dart';
import 'ui/home_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const CaffeineTrackerApp());
}

class CaffeineTrackerApp extends StatefulWidget {
  const CaffeineTrackerApp({super.key});

  @override
  State<CaffeineTrackerApp> createState() => _CaffeineTrackerAppState();
}

class _CaffeineTrackerAppState extends State<CaffeineTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caffeine Tracker',
      themeMode: _themeMode,
      locale: _locale, // Apply the selected locale
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6F4E37),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Colors.black87,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6F4E37),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6F4E37),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6F4E37),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6F4E37),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6F4E37),
          ),
        ),
      ),
      supportedLocales: const [
        Locale('en'), // English
        Locale('kk'), // Kazakh
        Locale('vi'), // Vietnamese
        Locale('zh'), // Chinese
        Locale('es'), // Spanish
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(
        onThemeChanged: (mode) => setState(() => _themeMode = mode),
        // Pass this callback to HomeScreen so the user can change language from Settings
        onLocaleChanged: (locale) => setState(() => _locale = locale),
      ),
    );
  }
}