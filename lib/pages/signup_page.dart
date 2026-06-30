import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_page.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Password visibility
  bool _passwordVisibility = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _locationFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Validators
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!value.trim().contains(' ')) {
      return 'Please enter your full name (first + last)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your location';
    }
    if (value.trim().length < 3) {
      return 'Location must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null;
  }

  // Handle Create Account
  void _handleCreateAccount() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SIGN UP label
                  const Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.avatarGreen,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Trade your gadgets with the community',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Continue with Google
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Google signup
                      },
                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 28,
                        color: AppColors.textWhite,
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textWhite,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.cardSurface,
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // OR divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: AppColors.border)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Full name field
                  _buildFieldLabel('Full name'),
                  const SizedBox(height: 10),
                  _buildValidatedField(
                    controller: _fullNameController,
                    focusNode: _fullNameFocusNode,
                    hintText: 'Your full name',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: _validateFullName,
                  ),

                  const SizedBox(height: 18),

                  // Email field
                  _buildFieldLabel('Email'),
                  const SizedBox(height: 10),
                  _buildValidatedField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    hintText: 'example@email.com',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 18),

                  // Location field
                  _buildFieldLabel('Location'),
                  const SizedBox(height: 10),
                  _buildValidatedField(
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                    hintText: 'e.g. Accra, Ghana',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.text,
                    validator: _validateLocation,
                  ),

                  const SizedBox(height: 18),

                  // Password field
                  _buildFieldLabel('Password'),
                  const SizedBox(height: 10),
                  _buildPasswordField(),

                  const SizedBox(height: 28),

                  // Create account button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleCreateAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: AppColors.textWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Already have account
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Terms and Privacy
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(text: 'By signing up you agree to our '),
                        TextSpan(
                          text: 'Terms',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Field label
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: AppColors.textWhite,
      ),
    );
  }

  // Reusable validated text field
  Widget _buildValidatedField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textWhite,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8899AA),
        ),
        filled: true,
        fillColor: const Color(0xF5132437),
        prefixIcon: Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 24,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColors.danger,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  // Password field with visibility toggle
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_passwordVisibility,
      validator: _validatePassword,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textWhite,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF8899AA),
          letterSpacing: 4,
        ),
        filled: true,
        fillColor: const Color(0xF5132437),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColors.primaryBlue,
          size: 24,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textMuted,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _passwordVisibility = !_passwordVisibility;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: AppColors.danger,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}