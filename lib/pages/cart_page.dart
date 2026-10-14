import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import 'device_detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.pageBackground,
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, color: AppColors.textMuted, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Please log in to view your cart',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildCartList(user.uid),
            ),
            _buildCartBottom(user.uid),
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
      title: const Text(
        'My Cart',
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

  // FIXED: Corrected stream to point to the 'cart' document and updated error handling
  Widget _buildCartList(String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Cart error: ${snapshot.error}');
          return _buildEmptyState();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        // If user document doesn't exist, show empty cart
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildEmptyState();
        }

        final cartData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final cartItems = cartData['items'] as List<dynamic>? ?? [];

        if (cartItems.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: cartItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = cartItems[index] as Map<String, dynamic>;
            return _buildCartItem(item, index, userId);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart_outlined, color: AppColors.textMuted, size: 48),
          SizedBox(height: 12),
          Text(
            'Your cart is empty',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Individual cart item card
  Widget _buildCartItem(Map<String, dynamic> item, int index, String userId) {
    final deviceId = item['deviceId'] ?? '';
    final deviceName = item['deviceName'] ?? 'Unknown';
    final deviceSpec = '${item['storage'] ?? 'N/A'} • ${item['condition'] ?? 'N/A'}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeviceDetailPage(deviceId: deviceId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
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
                _getDeviceIcon(deviceName),
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
                    deviceName,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deviceSpec,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Added to cart',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
            // Remove from cart button
            GestureDetector(
              onTap: () => _removeFromCart(userId, index),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close, color: AppColors.danger, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIXED: Corrected stream to point to the 'cart' document
  Widget _buildCartBottom(String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('cart')
          .snapshots(),
      builder: (context, snapshot) {
        final cartData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final cartItems = cartData['items'] as List<dynamic>? ?? [];
        final itemCount = cartItems.length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xF5132437),
            border: Border(
              top: BorderSide(color: AppColors.border.withValues(alpha: 0.3), width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Items',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                  Text(
                    '$itemCount',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: itemCount > 0
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contact admin to finalize swaps'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
                    foregroundColor: AppColors.textWhite,
                    elevation: 0,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Request Swaps',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Remove item from cart
  Future<void> _removeFromCart(String userId, int index) async {
    try {
      final cartDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('cart');

      final snapshot = await cartDoc.get();
      if (!snapshot.exists) return;

      final cartData = snapshot.data() as Map<String, dynamic>;
      final cartItems = List<dynamic>.from(cartData['items'] ?? []);

      if (index < cartItems.length) {
        cartItems.removeAt(index);
        await cartDoc.update({'items': cartItems});
      }
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
      );
    }
  }

  // Get device icon based on name
  IconData _getDeviceIcon(String deviceName) {
    final name = deviceName.toLowerCase();
    if (name.contains('macbook') || name.contains('laptop') || name.contains('dell')) {
      return Icons.laptop_rounded;
    } else if (name.contains('ipad') || name.contains('tablet')) {
      return Icons.tablet_outlined;
    }
    return Icons.phone_iphone;
  }
}
