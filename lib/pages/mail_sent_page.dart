import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'reset_password_page.dart';

class MailSentPage extends StatelessWidget {
  // The email address that was used for the reset (passed in)
  final String email;

  const MailSentPage({
    super.key,
    this.email = 'example@email.com',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'CHECK YOUR EMAIL',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email sent success icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.7),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: AppColors.success,
                    size: 56,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Heading
              const Center(
                child: Text(
                  'Check your email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle with email
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'We sent a password reset link to\n',
                      ),
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Info card about link expiration
              _buildInfoCard(),

              const SizedBox(height: 24),

              // Open email app button
              _buildOpenEmailButton(context),

              const SizedBox(height: 20),

              // Didn't receive it? Resend link
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Resend the email
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset link resent!'),
                        backgroundColor: AppColors.success,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(text: "Didn't receive it? "),
                        TextSpan(
                          text: 'Resend link',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Back to Login link
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Pop both MailSentPage AND ForgotPasswordPage
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
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
    );
  }

  // Info card about link expiration
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xF5132437),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 12),
            child: Icon(
              Icons.info_outline,
              color: AppColors.primaryBlue,
              size: 22,
            ),
          ),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: 'The link expires in '),
                  TextSpan(
                    text: '30 minutes.',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' Check your spam folder if you don\'t see it.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Open email app button
  Widget _buildOpenEmailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // For now, simulate clicking the email link
          // In production, the user clicks the link in their email,
          // which deep-links them to this page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Open email app',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}
