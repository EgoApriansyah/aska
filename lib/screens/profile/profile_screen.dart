// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../constants/app_routes.dart';
import '../../widgets/common/aska_logo_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'NAUFAL WAFI';
  String referralCode = 'ASKA123456';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Profile Header
          const SizedBox(height: 70),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                // User Info
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'naufalwafi@email.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit Button
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Edit profile
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Referral Code
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard, color: AppColors.primary),
                      const SizedBox(width: 12),
                      const Text(
                        'Kode Referal',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        referralCode,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          // TODO: Copy referral code
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode referal disalin!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildMenuItem(
                  icon: Icons.calculate,
                  title: 'Kalkulator Kesehatan',
                  onTap: () {
                    // TODO: Navigate to health calculator
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock,
                  title: 'Ubah PIN',
                  onTap: () {
                    _showChangePINDialog();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.password,
                  title: 'Ubah Kata Sandi',
                  onTap: () {
                    _showChangePasswordDialog();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Riwayat Pemeriksaan',
                  onTap: () {
                    // TODO: Navigate to medical history
                  },
                ),
                _buildMenuItem(
                  icon: Icons.local_hospital,
                  title: 'Faskes Terdaftar',
                  onTap: () {
                    // TODO: Navigate to registered healthcare facilities
                  },
                ),
                _buildMenuItem(
                  icon: Icons.document_scanner,
                  title: 'E-Claim',
                  onTap: () {
                    // TODO: Navigate to e-claim
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Bantuan',
                  onTap: () {
                    // TODO: Navigate to help/FAQ
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang ASKA',
                  onTap: () {
                    // TODO: Show about dialog
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Keluar',
                  color: Colors.red,
                  onTap: () {
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: const BoxDecoration(color: Colors.white),
      child: ListTile(
        leading: Icon(icon, color: color, size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCustomNavBar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavBarItem(Icons.home_filled, 'Beranda', false),
              _buildNavBarItem(Icons.newspaper, 'Berita', false),
              const SizedBox(width: 56),
              _buildNavBarItem(Icons.help_outline, 'FAQ', false),
              _buildNavBarItem(Icons.person, 'Profile', true),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -28,
          child: Center(
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to card screen
                Navigator.pushNamed(context, '/card');
              },
              backgroundColor: const Color(0xFF0A6ED1),
              elevation: 8,
              child: const Icon(Icons.credit_card, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        // Handle navigation based on label
        switch (label) {
          case 'Beranda':
            Navigator.pushNamed(context, AppRoutes.home);
            break;
          case 'Berita':
            Navigator.pushNamed(context, AppRoutes.news);
            break;
          case 'FAQ':
            Navigator.pushNamed(context, AppRoutes.faq);
            break;
          case 'Profile':
            // Navigator.pushNamed(context, AppRoutes.profile);
            break;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? const Color(0xFF0A6ED1) : Colors.grey),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? const Color(0xFF0A6ED1) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePINDialog() {
    final TextEditingController currentPinController = TextEditingController();
    final TextEditingController newPinController = TextEditingController();
    final TextEditingController confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN Lama',
                hintText: 'Masukkan PIN lama Anda',
              ),
            ),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN Baru',
                hintText: 'Masukkan PIN baru (6 digit)',
              ),
            ),
            TextField(
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi PIN Baru',
                hintText: 'Konfirmasi PIN baru',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement PIN change logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN berhasil diubah!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Kata Sandi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Lama',
                hintText: 'Masukkan kata sandi lama',
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Baru',
                hintText: 'Masukkan kata sandi baru',
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Kata Sandi Baru',
                hintText: 'Konfirmasi kata sandi baru',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kata sandi berhasil diubah!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
