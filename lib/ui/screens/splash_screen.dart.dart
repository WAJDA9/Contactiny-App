import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpmobile/const/assets.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/services/database.dart';
import 'package:tpmobile/ui/screens/home_screen.dart';
import 'package:tpmobile/ui/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: AppColors.backGroundColor,
      duration: const Duration(seconds: 2),
      childWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.logo),
          SizedBox(height: 20.h),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            backgroundColor: AppColors.secondaryColor,
          ),
        ],
      ),
      onInit: () async {
        await DatabaseHelper.instance.database;
        await DatabaseHelper.instance.createInitialUserIfNotExists();
      },
      onAnimationEnd: () async {
        final loggedInUser = await DatabaseHelper.instance.getLoggedInUser();
        final rememberMe = await DatabaseHelper.instance.isRememberMeChecked();

        if (loggedInUser != null && rememberMe) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // User is not logged in or remember me is not checked
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
    );
  }
}