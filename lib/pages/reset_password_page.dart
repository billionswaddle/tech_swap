import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Focus nodes
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // Password visibility
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes to update requirement icons live
    _newPasswordController.addListener(_updateValidation);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _updateValidation() {
    setState(() {});
  }

  // Password requirement checks (for the visual indicators)
  bool _hasMinLength() => _newPasswordController.text.length >= 8;
  bool _hasNumber() => _newPasswordController.text.contains(RegExp(r'[0-9]'));
  bool _hasSpecialChar() => _newPasswordController.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  // Validators
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Handle Reset Password
  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      // TODO: Real reset password (Firebase Auth)

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated! Please sign in.'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Pop all the way back to LoginPage
      Navigator.popUntil(context, (route) => route.isFirst);
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
        appBar: AppBar(
          backgroundColor: AppColors.pageBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textWhite,
                  size: 22,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: const Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),

                    // Lock icon
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xF5132437),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryBlue,
                          size: 50,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        'Create new password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Center(
                      child: Text(
                        'Your new password must be different from your previous one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // New Password label
                    const Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // New Password field
                    _buildPasswordField(
                      controller: _newPasswordController,
                      focusNode: _newPasswordFocusNode,
                      isVisible: _newPasswordVisible,
                      validator: _validateNewPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                      hintText: '••••••••',
                    ),

                    const SizedBox(height: 18),

                    // Confirm Password label
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Confirm Password field
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      isVisible: _confirmPasswordVisible,
                      validator: _validateConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      hintText: 'Re-enter password',
                    ),

                    const SizedBox(height: 24),

                    // Requirements
                    _buildRequirementRow(
                      'At least 8 characters',
                      _hasMinLength(),
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementRow(
                      'Contains a number',
                      _hasNumber(),
                    ),
                    const SizedBox(height: 8),
                    _buildRequirementRow(
                      'Contains a special character',
                      _hasSpecialChar(),
                    ),

                    const SizedBox(height: 28),

                    // Reset Password button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _handleReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: AppColors.textWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Remember password link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textWhite,
                            ),
                            children: [
                              TextSpan(text: 'Remember your password?'),
                              TextSpan(
                                text: ' Sign In',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Password field with validation
  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.textWhite,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFF8899AA),
          letterSpacing: 2,
        ),
        filled: true,
        fillColor: const Color(0xF5132437),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColors.textMuted,
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textMuted,
            size: 22,
          ),
          onPressed: onToggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.25),
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

  // Single requirement row (visual indicator)
  Widget _buildRequirementRow(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? AppColors.success : AppColors.textMuted,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isMet ? AppColors.textWhite : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}