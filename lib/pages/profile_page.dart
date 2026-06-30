import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'device_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Tab selection (0 = Listings, 1 = Reviews)
  int _selectedTab = 0;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildAvatar(),
              const SizedBox(height: 12),
              _buildNameAndLocation(),
              const SizedBox(height: 20),
              _buildStatsCard(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildAboutSection(),
              const SizedBox(height: 24),
              _buildTabs(),
              const SizedBox(height: 16),
              _buildTabContent(),
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
        child: _buildHeaderIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _buildHeaderIconButton(
            icon: Icons.settings_outlined,
            onTap: () {
              // TODO: Navigate to SettingsPage when built
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.textWhite,
          size: 22,
        ),
      ),
    );
  }

  // ---------- AVATAR ----------
  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'KA',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }

  // ---------- NAME + LOCATION ----------
  Widget _buildNameAndLocation() {
    return Column(
      children: [
        const Text(
          'Kwame Asante',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.textMuted,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              'Accra, Ghana',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- STATS CARD ----------
  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.18),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Swaps
            Expanded(
              child: _buildStat(value: '12', label: 'Swaps'),
            ),
            _buildStatDivider(),
            // Listings
            Expanded(
              child: _buildStat(value: '5', label: 'Listings'),
            ),
            _buildStatDivider(),
            // Rating
            Expanded(
              child: _buildStat(
                value: '4.8',
                label: 'Rating',
                showStar: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required String value,
    required String label,
    bool showStar = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
            if (showStar) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.star,
                color: AppColors.warning,
                size: 22,
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.primaryBlue.withOpacity(0.25),
    );
  }

  // ---------- ACTION BUTTONS ----------
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Edit Profile button
          Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to EditProfilePage when built
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.textWhite,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Share button
          GestureDetector(
            onTap: () {
              // TODO: Share profile
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xF5132437),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.textWhite,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- ABOUT SECTION ----------
  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tech enthusiast based in Accra. Love trading phones and laptops. Quick responses guaranteed.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textWhite,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- TABS ----------
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildTab(label: 'Listings (3)', index: 0),
              const SizedBox(width: 30),
              _buildTab(label: 'Reviews (12)', index: 1),
            ],
          ),
          const SizedBox(height: 8),
          // Divider line
          Container(
            height: 1,
            color: AppColors.border.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({required String label, required int index}) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.blue : AppColors.textMuted,
              ),
            ),
          ),
          // Active underline (positioned just below the text)
          Container(
            height: 3,
            width: 60,
            color: isActive ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // ---------- TAB CONTENT ----------
  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      return _buildListingsTab();
    } else {
      return _buildReviewsTab();
    }
  }

  Widget _buildListingsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildListingItem(
            title: 'iPhone 13 Pro Max',
            subtitle: '256GB • Like New',
            icon: Icons.phone_iphone,
          ),
          const SizedBox(height: 10),
          _buildListingItem(
            title: 'iPhone 14 Max',
            subtitle: '256GB • Like New',
            icon: Icons.laptop_rounded,
          ),
          const SizedBox(height: 10),
          _buildListingItem(
            title: 'AirPods Pro 2',
            subtitle: 'New • Sealed',
            icon: Icons.headphones_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildListingItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: _openDeviceDetail,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.21),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.pageBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.21),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.star_border,
              color: AppColors.warning,
              size: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Reviews will appear here after your swaps are completed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}