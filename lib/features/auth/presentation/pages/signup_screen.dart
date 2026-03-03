import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/utils/snackbar_utils.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';
import 'package:futal_booking_system/features/auth/presentation/view_models/auth_viewmodel.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const green = Color(0xFF16A34A);

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _handleSignup() async {
    if (formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).register(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? "Required" : null;

  String? _emailValidator(String? val) {
    if (val == null || val.trim().isEmpty) return "Email cannot be empty";
    if (!val.contains("@") || !val.contains(".com")) return "Enter a valid email";
    return null;
  }

  String? _passwordValidator(String? val) {
    if (val == null || val.isEmpty) return "Password cannot be empty";
    if (val.length < 6) return "Minimum 6 characters";
    return null;
  }

  String? _confirmValidator(String? val) {
    if (val == null || val.isEmpty) return "Confirm Password cannot be empty";
    if (val != passwordController.text) return "Passwords do not match";
    return null;
  }

  InputDecoration _inputDec({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.black54),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF3F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(context, 'Registration successful! Please login.');
        goToLogin();
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

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
                          child: Icon(Icons.person_add_alt_1, color: Colors.white, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Join and start booking your futsal slots",
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
                      child: Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            Text(
                              "Personal Info",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Fill the details below to create your account.",
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 18),

                            const Text("Your Name", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: firstNameController,
                                    validator: _req,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDec(hint: "First name", icon: Icons.person_outline),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: lastNameController,
                                    validator: _req,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDec(hint: "Last name", icon: Icons.person_outline),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const Text("Email Address", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: _emailValidator,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDec(hint: "example@gmail.com", icon: Icons.email_outlined),
                            ),

                            const SizedBox(height: 16),

                            const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              validator: _passwordValidator,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDec(
                                hint: "Create password",
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text("Confirm Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: obscureConfirmPassword,
                              validator: _confirmValidator,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleSignup(),
                              decoration: _inputDec(
                                hint: "Re-enter password",
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                                  icon: Icon(
                                    obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? ", style: TextStyle(fontSize: 13)),
                                  GestureDetector(
                                    onTap: goToLogin,
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: green,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 6),
                          ],
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