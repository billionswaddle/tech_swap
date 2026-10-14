import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import 'device_detail_page.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['iPhone', 'MacBook', 'Samsung'];

  String _selectedCategory = 'All';
  String _selectedCondition = 'All';
  String _selectedLocation = 'All';

  final List<String> _categories = ['All', 'Phones', 'Laptops', 'Tablets', 'Others'];
  final List<String> _conditions = ['All', 'New', 'Like New', 'Good', 'Fair'];
  final List<String> _locations = ['All', 'Accra', 'Kumasi', 'Tema', 'Cape Coast'];

  bool _showFilters = false;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      Query<Map<String, dynamic>> firebaseQuery =
          FirebaseFirestore.instance.collection('devices');

      // Apply category filter
      if (_selectedCategory != 'All') {
        firebaseQuery = firebaseQuery.where('category', isEqualTo: _selectedCategory);
      }

      // Apply condition filter
      if (_selectedCondition != 'All') {
        firebaseQuery = firebaseQuery.where('condition', isEqualTo: _selectedCondition);
      }

      // Apply location filter
      if (_selectedLocation != 'All') {
        firebaseQuery = firebaseQuery.where('location', isEqualTo: _selectedLocation);
      }

      final snapshot = await firebaseQuery.get();

      // Filter by search query client-side (name, brand, description)
      final results = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return {
              ...data,
              'id': doc.id,
            };
          })
          .where((device) {
            final name = (device['name'] ?? '').toString().toLowerCase();
            final brand = (device['brand'] ?? '').toString().toLowerCase();
            final description = (device['description'] ?? '').toString().toLowerCase();
            final searchQuery = query.toLowerCase();

            return name.contains(searchQuery) ||
                brand.contains(searchQuery) ||
                description.contains(searchQuery);
          })
          .toList();

      // Add to recent searches if not already there
      if (query.isNotEmpty && !_recentSearches.contains(query)) {
        setState(() {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        });
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      debugPrint('Error searching: $e');
      setState(() => _isSearching = false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _selectedCategory = 'All';
      _selectedCondition = 'All';
      _selectedLocation = 'All';
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _openDeviceDetail(String deviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailPage(deviceId: deviceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              if (_showFilters) _buildFilterSection(),
              Expanded(
                child: _buildResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Search Devices',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
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
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xF5132437),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _performSearch(value);
                      } else {
                        _clearSearch();
                      }
                    },
                    style: const TextStyle(color: AppColors.textWhite, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search phones, laptops...',
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: _clearSearch,
                              child: const Icon(Icons.close, color: AppColors.textMuted),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _showFilters = !_showFilters),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _showFilters ? Colors.blue : const Color(0xF5132437),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showFilters
                          ? Colors.blue
                          : AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.textWhite, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xF5132437),
        border: Border(
          bottom: BorderSide(
              color: AppColors.border.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterLabel('Category'),
          const SizedBox(height: 10),
          _buildFilterChips(_categories, _selectedCategory, (val) {
            setState(() => _selectedCategory = val);
            _performSearch(_searchController.text);
          }),
          const SizedBox(height: 16),
          _buildFilterLabel('Condition'),
          const SizedBox(height: 10),
          _buildFilterChips(_conditions, _selectedCondition, (val) {
            setState(() => _selectedCondition = val);
            _performSearch(_searchController.text);
          }),
          const SizedBox(height: 16),
          _buildFilterLabel('Location'),
          const SizedBox(height: 10),
          _buildFilterChips(_locations, _selectedLocation, (val) {
            setState(() => _selectedLocation = val);
            _performSearch(_searchController.text);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _buildFilterChips(List<String> options, String selectedValue, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : const Color(0xFF1E3A5F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.blue : AppColors.primaryBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResults() {
    if (_searchController.text.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textWhite),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xF5132437),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: AppColors.textMuted, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          search,
                          style: const TextStyle(color: AppColors.textWhite, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: AppColors.textMuted, size: 48),
            SizedBox(height: 12),
            Text(
              'No devices found',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final device = _searchResults[index];
        return _buildSearchResultCard(device);
      },
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> device) {
    final deviceId = device['id']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _openDeviceDetail(deviceId),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                device['name'].toString().toLowerCase().contains('phone')
                    ? Icons.phone_iphone
                    : device['name'].toString().toLowerCase().contains('laptop')
                        ? Icons.laptop_rounded
                        : Icons.tablet_outlined,
                color: Colors.blue,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device['name'] ?? 'Unknown',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${device['brand'] ?? 'Unknown'} • ${device['storage'] ?? 'N/A'}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      device['condition'] ?? 'N/A',
                      style: const TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
