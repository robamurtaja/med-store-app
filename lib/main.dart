import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medical_devices_app/modules/bnb/controller/bnb_controller.dart';
import 'package:medical_devices_app/modules/home/controller/favorite_controller.dart';
import 'core/router/router.dart';
import 'core/router/routers_name.dart';
import 'core/router/routes.dart';
import 'core/services/local_services/shared_perf.dart';
import 'core/utils/theme_controller.dart';
import 'core/utils/theme_manager.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medical_devices_app/modules/category/controller/category_controller.dart';
import 'package:medical_devices_app/modules/home/controller/home_controller.dart';
import 'package:medical_devices_app/modules/order/controller/order_controller.dart';
import 'package:medical_devices_app/modules/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';
import 'core/services/remote_services/firebase_init.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => BnbController()),

        ChangeNotifierProvider(
          create: (context) => FavoriteController()..loadFavorites(),
        ),
        ChangeNotifierProvider(create: (context) => OrderController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
      ],
      child: ProviderScope(child: const MyApp()),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: SharedPrefController().getOnBoarding()
          ? (SharedPrefController().getLoggedIn() ||
                    SharedPrefController().getGuestUser())
                ? RouteName.mainAppView
                : RouteName.auth
          : RouteName.onboarding,
      onGenerateRoute: RouteGenerator.generateRoutes,
      navigatorKey: NavigationManager.navigatorKey,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ar'),
    );
  }
}
