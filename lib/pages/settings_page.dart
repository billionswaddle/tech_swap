import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Switch states
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ACCOUNT SECTION
              _buildSectionTitle('ACCOUNT'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildSettingsRow(
                    icon: Icons.person_2_outlined,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // NOTIFICATIONS SECTION
              _buildSectionTitle('NOTIFICATIONS'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildSwitchRow(
                    icon: Icons.notifications_none,
                    title: 'Push Notifications',
                    value: _pushNotifications,
                    onChanged: (val) {
                      setState(() => _pushNotifications = val);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchRow(
                    icon: Icons.mail_outline,
                    title: 'Email Notifications',
                    value: _emailNotifications,
                    onChanged: (val) {
                      setState(() => _emailNotifications = val);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    icon: Icons.settings_outlined,
                    title: 'Notification Preferences',
                    onTap: () {
                      // TODO: Navigate to NotificationPreferencesPage when built
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PREFERENCES SECTION
              _buildSectionTitle('PREFERENCES'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildSwitchRow(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    value: _darkMode,
                    onChanged: (val) {
                      setState(() => _darkMode = val);
                      if (!val) {
                        // Prevent turning off dark mode for now (only dark mode is designed)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Light mode coming soon'),
                            backgroundColor: AppColors.info,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        setState(() => _darkMode = true);
                      }
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    icon: Icons.language,
                    title: 'Language',
                    trailing: const Text(
                      'English',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to LanguagePickerPage when built
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ABOUT SECTION
              _buildSectionTitle('ABOUT'),
              const SizedBox(height: 10),
              _buildSettingsCard(
                children: [
                  _buildSettingsRow(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // TODO: Navigate to HelpSupportPage when built
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    icon: Icons.text_snippet_outlined,
                    title: 'Terms of Service',
                    onTap: () {
                      // TODO: Navigate to TermsOfServicePage when built
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // TODO: Navigate to PrivacyPolicyPage when built
                    },
                  ),
                  _buildDivider(),
                  // App version (no tap, just info)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        _buildIconBox(Icons.info_outline),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'App Version',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                        const Text(
                          '1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // LOG OUT BUTTON
              _buildLogOutButton(),

              const SizedBox(height: 30),
            ],
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
        'Settings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  // ---------- SECTION TITLE ----------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ---------- SETTINGS CARD (container for a group of rows) ----------
  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xF5132437),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.17),
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ---------- SETTINGS ROW (with icon + title, optional subtitle + trailing + tap) ----------
  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            _buildIconBox(icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- SWITCH ROW ----------
  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _buildIconBox(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textWhite,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.blue,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: const Color(0xFF1E3A5F),
          ),
        ],
      ),
    );
  }

  // ---------- ICON BOX (the blue-tinted square with the icon) ----------
  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: Colors.blue,
        size: 20,
      ),
    );
  }

  // ---------- STATUS BADGE (like "PENDING") ----------
  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ---------- DIVIDER (between rows inside a card) ----------
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.primaryBlue.withValues(alpha: 0.15),
    );
  }

  // ---------- LOG OUT BUTTON ----------
  Widget _buildLogOutButton() {
    return GestureDetector(
      onTap: _showLogoutConfirmation,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.danger.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.logout,
              color: AppColors.danger,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- LOGOUT CONFIRMATION DIALOG ----------
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Log out?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                // 1. Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;

                // 2. Navigate to Home and clear the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: $e'),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
