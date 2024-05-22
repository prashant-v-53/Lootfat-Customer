import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lootfat_user/utils/localization/app_language.dart';
import 'package:lootfat_user/utils/localization/app_localizations.dart';
import 'package:lootfat_user/utils/theme/dark_theme_provider.dart';
import 'package:lootfat_user/utils/theme/dark_themedata.dart';
import 'package:lootfat_user/view/splash_screen.dart';
import 'package:lootfat_user/viewModel/auth_view_model.dart';
import 'package:lootfat_user/viewModel/splash_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguageProvider appLanguage = AppLanguageProvider();
  await appLanguage.fetchLocale();
  runApp(
    MyApp(appLanguage: appLanguage),
  );
}

class MyApp extends StatefulWidget {
  final AppLanguageProvider appLanguage;
  const MyApp({super.key, required this.appLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: Consumer2<AppLanguageProvider, DarkThemeProvider>(
        builder: (BuildContext context, language, theme, Widget? child) {
          return MaterialApp(
            title: 'LootFat',
            theme: Styles.themeData(theme.darkTheme, context),
            debugShowCheckedModeBanner: false,
            locale: language.appLocal,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     var appLanguage = Provider.of<AppLanguageProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppLocalizations.of(context).translate('title'),
//         ),
//       ),
//       body: Center(
//         child: Text(
//           AppLocalizations.of(context).translate('description'),
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _onTap(themeChange, appLanguage),
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _onTap(themeChange, languageChange) {
//     themeChange.darkTheme = !themeChange.darkTheme;
//     if (languageChange.appLocal == const Locale("en")) {
//       languageChange.changeLanguage(const Locale("ar"));
//     } else {
//       languageChange.changeLanguage(const Locale("en"));
//     }
//     setState(() {});
//   }
// }
