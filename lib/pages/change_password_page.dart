import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'forgot_password_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Visibility toggles
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  // Live password requirement checks
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    // Listen to new password changes to update requirements + strength meter
    _newPasswordController.addListener(_updatePasswordChecks);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_updatePasswordChecks);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update requirement checks whenever new password changes
  void _updatePasswordChecks() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Count how many requirements are met (0-4) for strength meter
  int get _strengthLevel {
    int count = 0;
    if (_hasMinLength) count++;
    if (_hasNumber) count++;
    if (_hasUppercase) count++;
    if (_hasSpecialChar) count++;
    return count;
  }

  // Get strength label ("Weak", "Fair", "Good", "Strong")
  String get _strengthLabel {
    switch (_strengthLevel) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  // Get strength color
  Color get _strengthColor {
    switch (_strengthLevel) {
      case 0:
      case 1:
        return AppColors.danger;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.info;
      case 4:
        return AppColors.success;
      default:
        return AppColors.danger;
    }
  }

  // Handle save button
  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check all password requirements are met
    if (_strengthLevel < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password does not meet all requirements'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Check passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildIconHeader(),
                const SizedBox(height: 12),
                _buildDescription(),
                const SizedBox(height: 24),
                _buildFieldLabel('Current Password'),
                const SizedBox(height: 8),
                _buildCurrentPasswordField(),
                const SizedBox(height: 6),
                _buildForgotPasswordLink(),
                const SizedBox(height: 16),
                _buildFieldLabel('New Password'),
                const SizedBox(height: 8),
                _buildNewPasswordField(),
                if (_newPasswordController.text.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildStrengthMeter(),
                ],
                const SizedBox(height: 16),
                _buildFieldLabel('Confirm New Password'),
                const SizedBox(height: 8),
                _buildConfirmPasswordField(),
                const SizedBox(height: 16),
                _buildRequirementsCard(),
                const SizedBox(height: 24),
                _buildSaveButton(),
                const SizedBox(height: 12),
                _buildCancelButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- APP BAR ----------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, top: 4),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xF5132437),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textWhite,
              size: 22,
            ),
          ),
        ),
      ),
      title: const Text(
        'Change Password',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  // ---------- ICON HEADER ----------
  Widget _buildIconHeader() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.lock_outline,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );
  }

  // ---------- DESCRIPTION ----------
  Widget _buildDescription() {
    return const Center(
      child: Text(
        'Choose a strong password to keep your account safe',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textMuted,
          height: 1.4,
        ),
      ),
    );
  }

  // ---------- FIELD LABEL ----------
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      ),
    );
  }

  // ---------- CURRENT PASSWORD FIELD ----------
  Widget _buildCurrentPasswordField() {
    return _buildPasswordField(
      controller: _currentPasswordController,
      hintText: 'Enter current password',
      isVisible: _currentPasswordVisible,
      onToggleVisibility: () {
        setState(() {
          _currentPasswordVisible = !_currentPasswordVisible;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password';
        }
        return null;
      },
    );
  }

  // ---------- NEW PASSWORD FIELD ----------
  Widget _buildNewPasswordField() {
    return _buildPasswordField(
      controller: _newPasswordController,
      hintText: 'Enter new password',
      isVisible: _newPasswordVisible,
      onToggleVisibility: () {
        setState(() {
          _newPasswordVisible = !_newPasswordVisible;
        });
      },
      // Highlight border with strength color when typing
      borderColor: _newPasswordController.text.isNotEmpty ? _strengthColor : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a new password';
        }
        return null;
      },
    );
  }

  // ---------- CONFIRM PASSWORD FIELD ----------
  Widget _buildConfirmPasswordField() {
    return _buildPasswordField(
      controller: _confirmPasswordController,
      hintText: 'Re-enter new password',
      isVisible: _confirmPasswordVisible,
      onToggleVisibility: () {
        setState(() {
          _confirmPasswordVisible = !_confirmPasswordVisible;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // ---------- REUSABLE PASSWORD FIELD ----------
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    Color? borderColor,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(
        color: AppColors.textWhite,
        fontSize: 15,
      ),
      cursorColor: Colors.blue,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: AppColors.textMuted,
          size: 22,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 22,
            ),
          ),
        ),
        filled: true,
        fillColor: AppColors.cardSurface,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.primaryBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.primaryBlue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor ?? Colors.blue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: AppColors.danger,
          fontSize: 12,
        ),
      ),
    );
  }

  // ---------- FORGOT PASSWORD LINK ----------
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  // ---------- STRENGTH METER ----------
  Widget _buildStrengthMeter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Password strength',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const Spacer(),
            Text(
              _strengthLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _strengthColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 4 bars showing strength level
        Row(
          children: List.generate(4, (index) {
            final isActive = index < _strengthLevel;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(
                  right: index < 3 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: isActive ? _strengthColor : const Color(0xFF1C2D4B),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ---------- REQUIREMENTS CARD ----------
  Widget _buildRequirementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PASSWORD REQUIREMENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          _buildRequirement('At least 8 characters', _hasMinLength),
          const SizedBox(height: 6),
          _buildRequirement('Contains a number', _hasNumber),
          const SizedBox(height: 6),
          _buildRequirement('Contains an uppercase letter', _hasUppercase),
          const SizedBox(height: 6),
          _buildRequirement('Contains a special character (!@#\$)', _hasSpecialChar),
        ],
      ),
    );
  }

  // ---------- INDIVIDUAL REQUIREMENT ROW ----------
  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          color: isMet ? AppColors.success : AppColors.textMuted,
          size: 16,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isMet ? AppColors.textWhite : AppColors.textLight,
            decoration: isMet ? null : null,
          ),
        ),
      ],
    );
  }

  // ---------- SAVE BUTTON ----------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check, size: 22),
            SizedBox(width: 8),
            Text(
              'Save Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- CANCEL BUTTON ----------
  Widget _buildCancelButton() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}