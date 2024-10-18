import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpmobile/services/database.dart';
import 'package:tpmobile/ui/screens/login_screen.dart';
import 'package:tpmobile/ui/screens/splash_screen.dart.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   try {
    await DatabaseHelper.instance.initializeDatabase();
  } catch (e) {
    print("Error during database initialization: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (_, child) => MaterialApp(
              title: 'Cintactiny App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: SplashScreen(),
            ));
  }
}
