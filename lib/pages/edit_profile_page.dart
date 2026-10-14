import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fullName': _displayNameController.text.trim(),
          'bio': _bioController.text.trim(),
          'location': _locationController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists && !_isInitialized) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          _displayNameController.text = data['fullName'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _locationController.text = data['location'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _emailController.text = data['email'] ?? '';
          _isInitialized = true;
        }

        return Scaffold(
          backgroundColor: AppColors.pageBackground,
          appBar: _buildAppBar(),
          body: SafeArea(
            child: snapshot.connectionState == ConnectionState.waiting && !_isInitialized
                ? const Center(child: CircularProgressIndicator())
                : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildAvatarSection(_displayNameController.text),
                    const SizedBox(height: 24),
                    _buildFieldLabel('Display Name', required: true),
                    const SizedBox(height: 8),
                    _buildDisplayNameField(),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Bio'),
                    const SizedBox(height: 8),
                    _buildBioField(),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Location', required: true),
                    const SizedBox(height: 8),
                    _buildLocationField(),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    _buildPhoneField(),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Email'),
                    const SizedBox(height: 8),
                    _buildEmailField(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            child: const Icon(Icons.arrow_back, color: AppColors.textWhite, size: 22),
          ),
        ),
      ),
      title: const Text(
        'Edit Profile',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textWhite),
      ),
    );
  }

  // ---------- AVATAR SECTION ----------
  Widget _buildAvatarSection(String name) {
    String initials = "??";
    if (name.isNotEmpty) {
      List<String> parts = name.trim().split(' ');
      initials = parts.length >= 2
          ? (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
          : parts[0][0].toUpperCase();
    }

    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textWhite),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Avatar managed by profile name', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  // ---------- FIELD LABEL ----------
  Widget _buildFieldLabel(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textWhite),
        children: required ? [const TextSpan(text: ' *', style: TextStyle(color: AppColors.danger, fontSize: 14))] : [],
      ),
    );
  }

  // ---------- FIELDS ----------
  Widget _buildDisplayNameField() {
    return _buildTextField(
      controller: _displayNameController,
      hintText: 'Your name',
      prefixIcon: Icons.person_outline,
      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name' : null,
    );
  }

  Widget _buildBioField() {
    return _buildTextField(controller: _bioController, hintText: 'Tell people about yourself...', maxLines: 3);
  }

  Widget _buildLocationField() {
    return _buildTextField(
      controller: _locationController,
      hintText: 'e.g. Accra, Ghana',
      prefixIcon: Icons.location_on_outlined,
      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your location' : null,
    );
  }

  Widget _buildPhoneField() {
    return _buildTextField(controller: _phoneController, hintText: 'e.g. +233 55 123 4567', keyboardType: TextInputType.phone);
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      hintText: 'you@example.com',
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      validator: (val) {
        if (val == null || val.isEmpty) return 'Please enter email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Invalid email';
        return null;
      },
    );
  }

  // ---------- REUSABLE TEXT FIELD ----------
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textWhite, fontSize: 15),
      cursorColor: Colors.blue,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted, size: 22) : null,
        filled: true,
        fillColor: const Color(0xF5132437),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  // ---------- SAVE BUTTON ----------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isSaving
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Save Changes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
