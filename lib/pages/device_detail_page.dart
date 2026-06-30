import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'profile_page.dart';

class DeviceDetailPage extends StatefulWidget {
  const DeviceDetailPage({super.key});

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  // Currently selected image thumbnail (0, 1, or 2)
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageCarousel(),
                    const SizedBox(height: 10),
                    _buildThumbnails(),
                    const SizedBox(height: 24),
                    _buildTitleSection(),
                    const SizedBox(height: 12),
                    _buildDivider(),
                    _buildSellerCard(),
                    _buildDivider(),
                    const SizedBox(height: 12),
                    _buildSpecsSection(),
                    const SizedBox(height: 16),
                    _buildDescriptionSection(),
                    const SizedBox(height: 16),
                    _buildLookingForCard(),
                    const SizedBox(height: 100), // Space for fixed bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(),
    );
  }

  // ---------- APP BAR ----------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.pageBackground,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Device Details',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _buildHeaderIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        _buildHeaderIconButton(
          icon: Icons.favorite_border,
          onTap: () {
            // TODO: Toggle favorite
          },
        ),
        const SizedBox(width: 8),
        _buildHeaderIconButton(
          icon: Icons.share_outlined,
          onTap: () {
            // TODO: Share listing
          },
        ),
        const SizedBox(width: 12),
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
            color: AppColors.primaryBlue.withOpacity(0.2),
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

  // ---------- IMAGE CAROUSEL ----------
  Widget _buildImageCarousel() {
    return Container(
      height: 280,
      width: double.infinity,
      color: AppColors.cardSurface,
      child: Stack(
        children: [
          // Phone icon (placeholder)
          const Center(
            child: Icon(
              Icons.phone_iphone,
              color: AppColors.textWhite,
              size: 110,
            ),
          ),
          // "Like New" badge (top-right)
          Positioned(
            top: 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.success,
                  width: 1,
                ),
              ),
              child: const Text(
                'Like New',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          // Image indicator dots (bottom-center)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _selectedImageIndex
                        ? Colors.blue
                        : AppColors.textWhite.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- THUMBNAILS ----------
  Widget _buildThumbnails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(3, (index) {
          final isSelected = index == _selectedImageIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : const Color(0xF5132437),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : AppColors.primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.phone_iphone,
                  color: AppColors.textWhite,
                  size: 32,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- TITLE SECTION ----------
  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'iPhone 13 Pro Max',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Apple • 256GB • Space Gray',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xF5132437),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Phone',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- DIVIDER ----------
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 1,
        color: AppColors.border.withOpacity(0.5),
      ),
    );
  }

  // ---------- SELLER CARD ----------
  Widget _buildSellerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xF5132437),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.28),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'KA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Kwame Asante',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '4.8 • 12 swaps',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // View Profile button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xF5132437),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: const Text(
                'View Profile',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- SPECS SECTION ----------
  Widget _buildSpecsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device specs',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 10),
          // First row: Brand + Storage
          Row(
            children: [
              Expanded(
                child: _buildSpecCard(label: 'Brand', value: 'Apple'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSpecCard(label: 'Storage', value: '256GB'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Second row: Condition + Location
          Row(
            children: [
              Expanded(
                child: _buildSpecCard(label: 'Condition', value: 'Like New'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSpecCard(label: 'Location', value: 'Accra, Ghana'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard({required String label, required String value}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xF5132437),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- DESCRIPTION ----------
  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'iPhone 13 Pro Max in excellent condition. Comes with original box, charger and case. Battery health at 94%. No scratches or dents.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- LOOKING FOR ----------
  Widget _buildLookingForCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Looking for',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(
                  Icons.swap_horiz,
                  color: Colors.blue,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Samsung Galaxy S23 or newer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- BOTTOM ACTION BAR ----------
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Message button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to ChatThreadPage when built
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xF5132437),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.message_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Propose Swap button
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to CounterOfferPage (or MakeSwapOfferPage)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: AppColors.textWhite,
                elevation: 0,
                minimumSize: const Size(0, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Propose Swap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}