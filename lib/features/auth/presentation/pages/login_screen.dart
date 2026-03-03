import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/app/routes/app_routes.dart';
import 'package:futal_booking_system/core/services/biometrics/biomertic_service.dart';
import 'package:futal_booking_system/core/utils/snackbar_utils.dart';
import 'package:futal_booking_system/features/auth/presentation/pages/forgot_password_page.dart';
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

  Future<void> _handleLogin() async {
    if (formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).login(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }
  }

  Future<void> _handleFingerprintLogin() async {
    final bio = BiometricService();

    final available = await bio.isAvailable();
    if (!available) {
      SnackbarUtils.showError(context, "Fingerprint not available on this device.");
      return;
    }

    final ok = await bio.authenticateForLogin();
    if (!ok) return;

    await ref.read(authViewModelProvider.notifier).fingerprintLogin();
  }

  String? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return "Email cannot be empty";
    if (!val.contains("@") || !val.contains(".com")) {
      return "Enter a valid email must be @gmail.com";
    }
    return null;
  }

  String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return "Password cannot be empty";
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

    const green = Color(0xFF16A34A); // ✅ nice green

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const SizedBox(height: 14),

                
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 10),
                          color: Color(0x22000000),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0x33FFFFFF),
                          child: Icon(Icons.sports_soccer, color: Colors.white, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Login to continue your booking",
                                style: TextStyle(
                                  color: Color(0xDFFFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            offset: Offset(0, 10),
                            color: Color(0x14000000),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Login Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Enter your email and password to login.",
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 18),

                              const Text("Email Address", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              MyTextFormField(
                                label: "example@gmail.com",
                                controller: emailController,
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 16),

                              const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                validator: validatePassword,
                                decoration: InputDecoration(
                                  labelText: "Enter your password",
                                  filled: true,
                                  fillColor: const Color(0xFFF3F5F9),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: savePassword,
                                        activeColor: green,
                                        onChanged: (val) => setState(() => savePassword = val ?? false),
                                      ),
                                      const Text("Remember me"),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(color: green, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                          
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: _handleFingerprintLogin,
                                  icon: const Icon(Icons.fingerprint, color: green),
                                  label: const Text(
                                    "Login with Fingerprint",
                                    style: TextStyle(color: green, fontWeight: FontWeight.w700),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFB7E4C7)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Center(
                                child: GestureDetector(
                                  onTap: goToSignUp,
                                  child: const Text(
                                    "Create New Account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: green,
                                      fontWeight: FontWeight.w700,
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
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}