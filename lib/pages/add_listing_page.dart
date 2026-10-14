import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dart:io'; // Needed for File
import 'package:image_picker/image_picker.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  // ----------------------------------------------------
  // PHOTO PICKER STATE
  // ----------------------------------------------------
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = []; // Stores the selected image files

  // ----------------------------------------------------
  // FORM KEY & CONTROLLERS
  // ----------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _wantsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // ----------------------------------------------------
  // DROPDOWN & SELECTION STATES
  // ----------------------------------------------------
  String? _selectedBrand;
  String? _selectedStorage;
  String _selectedCategory = '';
  String _selectedCondition = '';

  // ----------------------------------------------------
  // ERROR TRACKING FLAGS
  // ----------------------------------------------------
  bool _brandError = false;
  bool _storageError = false;
  bool _categoryError = false;
  bool _conditionError = false;

  final List<String> _brands = [
    'Apple', 'Samsung', 'Huawei', 'Google Pixel', 'Infinix', 'OnePlus', 'Other'
  ];

  final List<String> _storageOptions = [
    '8GB', '16GB', '32GB', '64GB', '128GB', '256GB', '512GB', '1TB'
  ];

  final List<String> _categories = ['Phone', 'Laptop', 'Tablet', 'Watch'];

  // ----------------------------------------------------
  // PHOTO PICKER LOGIC
  // ----------------------------------------------------
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      _showErrorSnackBar('You can only add up to 5 photos');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress for better performance
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _wantsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _brandError = _selectedBrand == null;
      _storageError = _selectedStorage == null;
      _categoryError = _selectedCategory.isEmpty;
      _conditionError = _selectedCondition.isEmpty;
    });

    final textFieldsValid = _formKey.currentState!.validate();

    if (!textFieldsValid || _brandError || _storageError || _categoryError || _conditionError) {
      _showErrorSnackBar('Please complete all required fields');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listing posted successfully!'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Device photos (up to 5)'),
                const SizedBox(height: 12),
                _buildPhotoUploadSection(),

                const SizedBox(height: 24),
                _buildSectionHeader('Device name'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'e.g. iPhone 13 Pro Max',
                  icon: Icons.phone_iphone,
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDropdownColumn('Brand', _selectedBrand, _brands, _brandError, (val) {
                        setState(() {
                          _selectedBrand = val;
                          _brandError = false;
                        });
                      }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownColumn('Storage', _selectedStorage, _storageOptions, _storageError, (val) {
                        setState(() {
                          _selectedStorage = val;
                          _storageError = false;
                        });
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Category'),
                _buildCategoryChips(),
                if (_categoryError) _buildErrorMessage('Please select a category'),

                const SizedBox(height: 24),
                _buildSectionHeader('Condition'),
                _buildConditionGrid(),
                if (_conditionError) _buildErrorMessage('Please select a condition'),

                const SizedBox(height: 24),
                _buildSectionHeader('Description'),
                _buildLargeTextField(
                  controller: _descriptionController,
                  hintText: 'Describe your device...',
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Looking for'),
                _buildTextField(
                  controller: _wantsController,
                  hintText: 'e.g. Samsung s23',
                  icon: Icons.swap_horiz,
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Location'),
                _buildLocationField(),

                const SizedBox(height: 40),
                _buildPostButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Post a listing', style: TextStyle(color: AppColors.textWhite, fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(color: AppColors.textWhite, fontSize: 15, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Row(
      children: [
        // Main Photo (Index 0)
        Expanded(
          flex: 2,
          child: _buildPhotoBox(0, height: 230, isLarge: true),
        ),
        const SizedBox(width: 12),
        // Side Photos (Index 1 and 2)
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPhotoBox(1, height: 109),
              const SizedBox(height: 12),
              _buildPhotoBox(2, height: 109),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoBox(int index, {required double height, bool isLarge = false}) {
    bool hasImage = _selectedImages.length > index;

    return GestureDetector(
      onTap: _pickImage,
      onLongPress: hasImage ? () => _removeImage(index) : null,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: hasImage ? 0.4 : 0.1)),
          image: hasImage
              ? DecorationImage(image: FileImage(_selectedImages[index]), fit: BoxFit.cover)
              : null,
        ),
        child: !hasImage
            ? Icon(
          isLarge ? Icons.photo_camera_outlined : Icons.add,
          color: AppColors.textMuted,
          size: isLarge ? 40 : 24,
        )
            : null,
      ),
    );
  }

  Widget _buildDropdownColumn(String label, String? val, List<String> items, bool error, Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(label),
        _buildDropdown(value: val, hint: 'Select $label', items: items, hasError: error, onChanged: onChange),
        if (error) _buildErrorMessage('Required'),
      ],
    );
  }

  Widget _buildErrorMessage(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(msg, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
    );
  }

  // Reusable Dropdown, TextField, Chips methods follow same logic as before but cleaned up...
  // (Assuming you have these defined as per your original file structure)

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: AppColors.textWhite),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 22),
        filled: true,
        fillColor: const Color(0xF5132437),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLargeTextField({required TextEditingController controller, required String hintText, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: 4,
      style: const TextStyle(color: AppColors.textWhite),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xF5132437),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required String hint, required List<String> items, required Function(String?) onChanged, bool hasError = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xF5132437),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hasError ? AppColors.danger : AppColors.primaryBlue.withValues(alpha: 0.15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
          dropdownColor: const Color(0xFF152238),
          isExpanded: true,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(color: AppColors.textWhite)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          bool sel = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: sel,
              onSelected: (s) => setState(() { _selectedCategory = cat; _categoryError = false; }),
              selectedColor: AppColors.primaryBlue,
              backgroundColor: const Color(0xF5132437),
              labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textMuted),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConditionGrid() {
    final conds = ['New', 'Like New', 'Good', 'Fair'];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3,
      children: conds.map((c) {
        bool sel = _selectedCondition == c;
        return GestureDetector(
          onTap: () => setState(() { _selectedCondition = c; _conditionError = false; }),
          child: Container(
            decoration: BoxDecoration(
              color: sel ? AppColors.primaryBlue.withValues(alpha: 0.2) : const Color(0xF5132437),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: sel ? AppColors.primaryBlue : AppColors.primaryBlue.withValues(alpha: 0.1)),
            ),
            child: Center(child: Text(c, style: TextStyle(color: sel ? Colors.white : AppColors.textMuted))),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationField() {
    return _buildTextField(controller: _locationController, hintText: 'Accra, Ghana', icon: Icons.location_on_outlined);
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _handleSubmit,
        icon: const Icon(Icons.file_upload_outlined),
        label: const Text('Post listing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}