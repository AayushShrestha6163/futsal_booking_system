import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/app/routes/app_routes.dart';
import 'package:futal_booking_system/core/utils/snackbar_utils.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';
import 'package:futal_booking_system/features/auth/presentation/view_models/auth_viewmodel.dart';
import 'package:futal_booking_system/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:futal_booking_system/widget/my_button.dart';
import 'package:futal_booking_system/widget/my_textformfield.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool savePassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  Future<void> _handleLogin() async {
    if (formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }
  }

  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Email cannot be empty";
    }
    if (!val.contains("@") || !val.contains(".com")) {
      return "Enter a valid email must be @gmail.com";
    }
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return "Password cannot be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, const DashboardScreen());
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // TOP TEXTS
              const Text(
                "Hello",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              const Text(
                "Login Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email Address :",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        MyTextFormField(
                          label: "Yours Email Address",
                          controller: emailController,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Password :",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          validator: validatePassword,
                          decoration: InputDecoration(
                            labelText: "Enter your password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.lock_outline
                                    : Icons.lock_open,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: savePassword,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    setState(() {
                                      savePassword = val ?? false;
                                    });
                                  },
                                ),
                                const Text("save password"),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: SizedBox(
                            width: 220,
                            height: 52,
                            child: MyButton(
                              onPressed: _handleLogin,
                              text: "Login Account",
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Center(
                          child: GestureDetector(
                            onTap: goToSignUp,
                            child: const Text(
                              "Create New Account",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
