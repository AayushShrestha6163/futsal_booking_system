import 'package:flutter/material.dart';
import 'package:futal_booking_system/common/my_snackbar.dart';
import 'package:futal_booking_system/screen/dashboard_screen.dart';
import 'package:futal_booking_system/screen/signup_screen.dart';
import 'package:futal_booking_system/widget/my_button.dart';
import 'package:futal_booking_system/widget/my_textformfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void login() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      mySnackBar(
        context: context,
        message: "Login successful!",
        color: Colors.green,
      );
      Future.delayed(const Duration(seconds: 1), goToDashboard);
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
                              onPressed: login,
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
