import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'mail_sent_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
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

  void _handleSendReset() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MailSentPage(email: _emailController.text.trim()),
        ),
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
        appBar: AppBar(
          backgroundColor: AppColors.pageBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textWhite,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: const Text(
            'FORGOT PASSWORD',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
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

                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_open,
                          color: AppColors.primaryBlue,
                          size: 56,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Center(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: AppColors.avatarGreen,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Center(
                      child: Text(
                        "No worries! Enter your email and we'll send you a reset link.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Email address',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Email field with validation
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: _validateEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textWhite,
                      ),
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8899AA),
                        ),
                        filled: true,
                        fillColor: const Color(0xF5132437),
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: AppColors.textMuted,
                          size: 22,
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
                    ),

                    const SizedBox(height: 25),

                    // Send reset link button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _handleSendReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: AppColors.textWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Send reset link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryBlue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(text: 'Back to '),
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}