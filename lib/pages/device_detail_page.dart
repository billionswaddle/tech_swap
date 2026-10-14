import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_colors.dart';
import '../utils/account_gate.dart';
import 'contact_admin_page.dart';

class DeviceDetailPage extends StatefulWidget {
  final String deviceId;

  const DeviceDetailPage({super.key, required this.deviceId});

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  bool _isInCart = false;
  bool _isLoadingCart = false;

  @override
  void initState() {
    super.initState();
    _checkIfInCart();
  }

  // ADDED: Check if device is already in cart
  Future<void> _checkIfInCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('cart')
          .get();

      if (!cartDoc.exists) {
        setState(() => _isInCart = false);
        return;
      }

      final cartData = cartDoc.data() as Map<String, dynamic>;
      final cartItems = cartData['items'] as List<dynamic>? ?? [];
      final isInCart = cartItems.any((item) => item['deviceId'] == widget.deviceId);

      setState(() => _isInCart = isInCart);
    } catch (e) {
      print('Error checking cart: $e');
    }
  }

  // ADDED: Add device to cart
  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoadingCart = true);

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('cart');

      // Get current cart or create new one
      final cartSnapshot = await cartRef.get();
      List<dynamic> cartItems = [];

      if (cartSnapshot.exists) {
        final cartData = cartSnapshot.data() as Map<String, dynamic>;
        cartItems = List<dynamic>.from(cartData['items'] ?? []);
      }

      // Check if device already in cart
      final alreadyExists = cartItems.any((item) => item['deviceId'] == widget.deviceId);
      if (alreadyExists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device already in cart'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() => _isLoadingCart = false);
        return;
      }

      // Get device data to save with cart item
      final deviceSnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .doc(widget.deviceId)
          .get();

      if (!deviceSnapshot.exists) {
        throw Exception('Device not found');
      }

      final deviceData = deviceSnapshot.data() as Map<String, dynamic>;

      // Add to cart
      cartItems.add({
        'deviceId': widget.deviceId,
        'deviceName': deviceData['name'] ?? 'Unknown',
        'brand': deviceData['brand'] ?? 'Unknown',
        'storage': deviceData['storage'] ?? 'N/A',
        'condition': deviceData['condition'] ?? 'N/A',
        'addedAt': FieldValue.serverTimestamp(),
      });

      await cartRef.set({
        'items': cartItems,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      setState(() => _isInCart = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingCart = false);
      }
    }
  }

  // ADDED: Remove device from cart
  Future<void> _removeFromCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoadingCart = true);

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('cart');

      final cartSnapshot = await cartRef.get();
      if (!cartSnapshot.exists) return;

      final cartData = cartSnapshot.data() as Map<String, dynamic>;
      List<dynamic> cartItems = List<dynamic>.from(cartData['items'] ?? []);

      cartItems.removeWhere((item) => item['deviceId'] == widget.deviceId);

      await cartRef.update({'items': cartItems});

      if (!mounted) return;
      setState(() => _isInCart = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from cart'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingCart = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('devices').doc(widget.deviceId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'Device not found',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(),
                  const SizedBox(height: 20),
                  _buildDeviceInfo(data),
                  const SizedBox(height: 20),
                  _buildStoreInfoCard(data['location'] ?? 'Unknown location'),
                  const SizedBox(height: 20),
                  _buildDescriptionSection(data),
                  const SizedBox(height: 20),
                  _buildWantsSection(data),
                  const SizedBox(height: 20),
                  _buildBottomActionBar(data),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
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
        'Device Details',
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
                color: AppColors.primaryBlue.withOpacity(0.2),
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

  Widget _buildImageCarousel() {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A5F),
      ),
      child: const Center(
        child: Icon(Icons.phone_iphone, color: Colors.blue, size: 80),
      ),
    );
  }

  Widget _buildDeviceInfo(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['name'] ?? 'Unknown Device',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['brand'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['condition'] ?? 'N/A',
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${data['storage'] ?? 'N/A'} Storage',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfoCard(String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xF5132437),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
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
              child: const Icon(Icons.storefront_outlined, color: Colors.blue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tech Swap Store',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  Text(
                    'Verified store • $location',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this device',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data['description'] ?? 'No description available',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWantsSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What they want',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xF5132437),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
            ),
            child: Text(
              data['lookingFor'] ?? 'Open to offers',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CHANGED: Updated bottom action bar with Add to Cart and Contact Us buttons
  Widget _buildBottomActionBar(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // CHANGED: Add to Cart button
          Expanded(
            child: GestureDetector(
              onTap: _isLoadingCart
                  ? null
                  : () {
                if (_isInCart) {
                  _removeFromCart();
                } else {
                  _addToCart();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isInCart ? AppColors.danger : const Color(0xF5132437),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isInCart ? AppColors.danger : AppColors.primaryBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: _isLoadingCart
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                      : Text(
                    _isInCart ? 'Remove from Cart' : 'Add to Cart',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _isInCart ? AppColors.textWhite : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // CHANGED: Contact Us button
          Expanded(
            child: GestureDetector(
              onTap: () {
                AccountGate.requireLogin(
                  context,
                  onAuthenticated: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContactAdminPage(
                          deviceId: widget.deviceId,
                          deviceName: data['name'] ?? 'Device',
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: const Center(
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}