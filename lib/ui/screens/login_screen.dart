import 'package:flutter/material.dart';
import 'package:tpmobile/const/assets.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/const/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tpmobile/services/database.dart';
import 'package:tpmobile/ui/screens/home_screen.dart';
import 'package:tpmobile/ui/widgets/Buttons/button_widget.dart';
import 'package:tpmobile/ui/widgets/fields/input_field_widget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _stayConnected = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> validateForm() async {
    setState(() {
      _emailError = validateEmail(emailController.text);
      _passwordError = validatePassword(passwordController.text);
    });

    if (_emailError == null && _passwordError == null) {
      // Form is valid, proceed with login
      bool loginSuccess = await loginUser(emailController.text, passwordController.text);
      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error logging in. Please check your credentials."))
        );
      }
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      return DatabaseHelper.instance.authenticateUser(email, password);
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(child: Image.asset(AppAssets.logo)),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Your new way to connect with the world",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.infoText.copyWith(fontSize: 16.sp),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Column(
                    children: [
                      TextFieldWidget(
                        hintText: "Enter Email Address",
                        isPassword: false,
                        controller: emailController,
                        errorText: _emailError,
                      ),
                      SizedBox(height: 16.h),
                      TextFieldWidget(
                        hintText: "Enter Password",
                        isPassword: true,
                        controller: passwordController,
                        errorText: _passwordError,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColors.primaryColor,
                                value: _stayConnected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _stayConnected = value!;
                                  });
                                },
                              ),
                              Text(
                                'Stay connected',
                                style: AppTextStyle.infoText.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/forgot password screen');
                            },
                            child: Text(
                              'Forgot password',
                              style: AppTextStyle.infoText.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonWidget(
                          buttonText: "Sign in",
                          onClick:(){
                            validateForm();
                          } ,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}