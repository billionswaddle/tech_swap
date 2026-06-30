import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'device_detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Currently selected category chip
  String _selectedCategory = '';

  // List of categories
  final List<String> _categories = ['All', 'Phones', 'Laptops', 'Tablets', 'Others'];

  // Reusable navigation method
  void _openDeviceDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeviceDetailPage()),
    );
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
                    _buildNearYouHeader(),
                    const SizedBox(height: 12),
                    _buildNearYouGrid(),
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

  // ---------- APP BAR ----------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          // Profile Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'KA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                'Kwame 👋',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Notifications
        _buildHeaderIconButton(
          icon: Icons.notifications_outlined,
          onTap: () {
            // TODO: Navigate to NotificationsPage when built
          },
          showRedDot: true,
        ),
        const SizedBox(width: 10),
        // Messages
        _buildHeaderIconButton(
          icon: Icons.message_outlined,
          onTap: () {
            // TODO: Navigate to MessagesPage when built
          },
          badgeCount: 3,
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

  // ---------- SEARCH BAR ----------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to SearchFilterPage when built
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
                  // TODO: Navigate to SearchFilterPage when built
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- CATEGORIES ----------
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

  // ---------- TRENDING SECTION ----------
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
              // TODO: Navigate to CategoriesPage when built
            },
            child: const Text('See all', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCards() {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTrendingCard(
            title: 'iPhone 14 Pro',
            spec: '128GB • Like New',
            wants: 'Samsung S23',
            icon: Icons.phone_iphone,
            gradient: const LinearGradient(colors: [Color(0xFF1E3A5F), Colors.blue]),
            showHot: true,
          ),
          const SizedBox(width: 15),
          _buildTrendingCard(
            title: 'MacBook Air M2',
            spec: '512GB • Excellent',
            wants: 'iPad Pro',
            icon: Icons.laptop_rounded,
            gradient: const LinearGradient(colors: [Color(0xD50881DE), Color(0xFF8B5CF6)]),
          ),
        ],
      ),
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
    return GestureDetector(
      onTap: _openDeviceDetail,
      child: Container(
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
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(spec, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text('Wants: $wants', style: const TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- NEAR YOU SECTION ----------
  Widget _buildNearYouHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          const Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 16),
          const Text(' Accra', style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildNearYouGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.75,
        children: [
          _buildNearCard('iPhone 13 Pro Max', '256GB • New', '2.4 km', '4.8', true),
          _buildNearCard('Samsung S26', '256GB • Excellent', '5.1 km', '4.9', false),
          _buildNearCard('iPhone 16', '256GB • New', '8.7 km', '4.6', true),
          _buildNearCard('iPhone 14 Pro Max', '256GB • Used', '12 km', '4.4', false),
        ],
      ),
    );
  }

  Widget _buildNearCard(String name, String spec, String dist, String rating, bool isNew) {
    return GestureDetector(
      onTap: _openDeviceDetail,
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
                    const Center(child: Icon(Icons.phone_iphone, color: Colors.blue, size: 40)),
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
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1),
                  Text(spec, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dist, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 10), Text(' $rating', style: const TextStyle(color: AppColors.textMuted, fontSize: 10))]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}