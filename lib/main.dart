import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science/firebase_options.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/screens/splash/splash_screen.dart';
import 'package:science/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) =>  ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeNotifier>(
        builder: (context,ThemeNotifier theme, _) => MaterialApp(
          title: 'Science Jobs',
          theme: theme.getTheme(),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
    );
  }
}
