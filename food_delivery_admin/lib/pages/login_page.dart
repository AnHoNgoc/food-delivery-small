import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../utils/app_validator.dart';
import '../utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      String? result = await authService.loginUserWithRoleCheck(
        email: email,
        password: password,
        requiredRole: "admin", // chỉ admin mới vào được
      );

      setState(() => _isLoading = false);

      if (result == null) {
        print('🔹DANG O TRANG LOGIN');
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
              (route) => false,
        );
      } else {
        showAppSnackBar(context, result, Colors.red);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🔹MOI VAO TRANG LOGIN');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/delivery.json',
                  width: 250.sp,   // responsive size, giống Icon
                  height: 250.sp,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Welcome Back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp, // responsive font size
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.h),
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                ),
                SizedBox(height: 10.h),
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 25.h),
                MyButton(
                  text: "Login",
                  onTap: _login,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}