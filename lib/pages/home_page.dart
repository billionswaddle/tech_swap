import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import 'device_detail_page.dart';
import 'search_filter_page.dart';
import 'submit_device_page.dart';
import 'notifications_page.dart';
import '../utils/account_gate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = '';
  final List<String> _categories = ['All', 'Phones', 'Laptops', 'Tablets', 'Others'];

  void _openDeviceDetail(String deviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceDetailPage(deviceId: deviceId),
      ),
    );
  }

  void _openAccount() {
    AccountGate.openAccount(context);
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
  }

  void _openSubmitDevice() {
    AccountGate.requireLogin(
      context,
      onAuthenticated: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubmitDevicePage()),
        );
      },
    );
  }

  IconData _getDeviceIcon(String deviceName) {
    final name = deviceName.toLowerCase();
    if (name.contains('macbook') || name.contains('laptop') || name.contains('dell')) {
      return Icons.laptop_rounded;
    } else if (name.contains('ipad') || name.contains('tablet')) {
      return Icons.tablet_outlined;
    }
    return Icons.phone_iphone;
  }

  // ADDED: Filter devices by category
  String _getCategoryFilter(String category) {
    switch (category) {
      case 'Phones':
        return 'phone';
      case 'Laptops':
        return 'laptop';
      case 'Tablets':
        return 'tablet';
      case 'Others':
        return 'other';
      default:
        return '';
    }
  }

  // ADDED: Check if device matches selected category
  bool _matchesCategory(String deviceName, String category) {
    if (category.isEmpty) return true;
    final name = deviceName.toLowerCase();
    switch (category) {
      case 'Phones':
        return name.contains('iphone') || name.contains('samsung') || name.contains('google') || name.contains('pixel') || name.contains('phone');
      case 'Laptops':
        return name.contains('macbook') || name.contains('laptop') || name.contains('dell') || name.contains('hp') || name.contains('lenovo');
      case 'Tablets':
        return name.contains('ipad') || name.contains('tablet');
      case 'Others':
        return true;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 14),
            _buildAddDeviceBanner(),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildTrendingHeader(),
                    const SizedBox(height: 10),
                    _buildTrendingCards(),
                    const SizedBox(height: 24),
                    _buildNewArrivalsHeader(),
                    const SizedBox(height: 12),
                    _buildNewArrivalsGrid(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tech Swap',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          Text(
            'Find your next device',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
      actions: [
        _buildHeaderIconButton(
          icon: Icons.notifications_outlined,
          onTap: _openNotifications,
          showRedDot: true,
        ),
        const SizedBox(width: 10),
        _buildHeaderIconButton(
          icon: Icons.person_outline,
          onTap: _openAccount,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showRedDot = false,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.textWhite, size: 24),
            if (showRedDot)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.pageBackground, width: 1.5),
                  ),
                ),
              ),
            if (badgeCount != null)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchFilterPage()),
          );
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xF5132437),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.search, color: AppColors.textMuted),
              ),
              const Expanded(
                child: Text(
                  'Search phones, laptops, tablets...',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchFilterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = (category == 'All' && _selectedCategory.isEmpty) ||
              (_selectedCategory == category);

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category == 'All' ? '' : category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : const Color(0xF5132437),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppColors.textWhite : AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddDeviceBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _openSubmitDevice,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xF5132437),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have a device to swap?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Submit its details and we\'ll review it for posting.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_outlined, color: AppColors.danger),
          const SizedBox(width: 8),
          const Text(
            'Trending Now',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textWhite),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('View all trending devices in New Arrivals below'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('See all', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('devices')
          .orderBy('requestCount', descending: true)
          .limit(2)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 230,
            child: Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(height: 230);
        }

        final trendingDevices = snapshot.data!.docs;

        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingDevices.length,
            itemBuilder: (context, index) {
              final device = trendingDevices[index];
              final data = device.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () => _openDeviceDetail(device.id),
                  child: _buildTrendingCard(
                    title: data['name'] ?? 'Unknown',
                    spec: '${data['storage'] ?? 'N/A'} • ${data['condition'] ?? 'N/A'}',
                    wants: data['lookingFor'] ?? 'Unknown',
                    icon: _getDeviceIcon(data['name'] ?? ''),
                    gradient: const LinearGradient(colors: [Color(0xFF1E3A5F), Colors.blue]),
                    showHot: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingCard({
    required String title,
    required String spec,
    required String wants,
    required IconData icon,
    required Gradient gradient,
    bool showHot = false,
  }) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: const Color(0xC7152238),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                if (showHot)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: const Text('🔥 HOT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                const Positioned(top: 10, right: 10, child: Icon(Icons.favorite_border, color: Colors.white)),
                Center(child: Icon(icon, color: Colors.white, size: 50)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  spec,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Wants: $wants',
                  style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('New Arrivals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Spacer(),
          Icon(Icons.storefront_outlined, color: AppColors.textMuted, size: 16),
          SizedBox(width: 4),
          Text('Tech Swap Store', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('devices').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );
          }

          if (snapshot.hasError) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'Error loading devices',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'No devices available yet',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            );
          }

          // CHANGED: Filter devices by selected category
          final filteredDevices = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final deviceName = data['name'] ?? '';
            return _matchesCategory(deviceName, _selectedCategory);
          }).toList();

          // CHANGED: Show message if no devices match selected category
          if (filteredDevices.isEmpty && _selectedCategory.isNotEmpty) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'No $_selectedCategory devices available',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.75,
            children: filteredDevices.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return _buildArrivalCard(
                deviceId: doc.id,
                name: data['name'] ?? 'Unknown',
                spec: '${data['storage'] ?? ''} • ${data['condition'] ?? 'N/A'}'.replaceAll('null', '').trim(),
                addedLabel: 'Added recently',
                isNew: data['condition'] == 'New',
                icon: _getDeviceIcon(data['name'] ?? ''),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildArrivalCard({
    required String deviceId,
    required String name,
    required String spec,
    required String addedLabel,
    required bool isNew,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _openDeviceDetail(deviceId),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xC7152238),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    Center(child: Icon(icon, color: Colors.blue, size: 40)),
                    if (isNew)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text('New', style: TextStyle(color: Colors.green, fontSize: 10)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    spec,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(addedLabel, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}