import 'package:akash_siwisoft/app_state.dart';
import 'package:akash_siwisoft/auth/auth_manager.dart';
import 'package:akash_siwisoft/conversion/conversion_manager.dart';
import 'package:akash_siwisoft/ui/base_select_screen.dart';
import 'package:akash_siwisoft/ui/conversion_screen.dart';
import 'package:akash_siwisoft/ui/login_sreen.dart';
import 'package:akash_siwisoft/ui/target_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthState authState = AuthState();
    AuthManager authManager = AuthManager(authState);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authState),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ConversionManager()),
        ChangeNotifierProvider(create: (context) => authManager),
      ],
      child: buildMaterialApp(),
    );
  }

  Widget buildMaterialApp() {
    return MaterialApp(
      title: 'Sivisoft Demo',
      initialRoute: "/login",
      routes: {
        '/login': (context) => LoginScreen(),
        '/baseSelector': (context) => BaseSelectScreen(),
        '/baseEditor': (context) => BaseSelectScreen(isEditingMode: true),
        '/targetSelector': (context) => TargetSelectScreen(),
        '/targetAdder': (context) => TargetSelectScreen(isEditingMode: true),
        '/conversionScreen': (context) => ConversionScreen(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Color(0xFF225c96),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
