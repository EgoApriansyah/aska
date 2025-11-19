import 'package:aska/constants/app_colors.dart';
import 'package:aska/constants/app_routes.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: "Siapa sajakah yang masuk dalam Anggota Keluarga?",
      answer:
          "Anggota Keluarga adalah istri/suami yang sah, anak kandung, anak tiri dari perkawinan yang sah, dan anak angkat yang sah",
      searchCount: "738 rb",
    ),
    FAQItem(
      question: "Berapa besaran iuran PBI?",
      answer:
          "Informasi mengenai besaran iuran PBI akan diupdate secara berkala melalui aplikasi Mobile JKN",
      searchCount: "4.4 jt",
    ),
    FAQItem(
      question: "Berapa besaran iuran Peserta PBPU/Mandiri/Perseorangan?",
      answer:
          "Besaran iuran untuk peserta PBPU/Mandiri/Perseorangan dapat dilihat pada menu informasi iuran di aplikasi",
      searchCount: "3.7 jt",
    ),
    FAQItem(
      question: "Cara Perubahan Data Melalui Aplikasi Mobile JKN?",
      answer:
          "Perubahan data dapat dilakukan melalui menu profil > ubah data dengan mengikuti langkah-langkah yang tersedia",
      searchCount: "2.9 jt",
    ),
    FAQItem(
      question: "Bagaimana Jika Kartu Peserta Hilang?",
      answer:
          "Jika kartu peserta hilang, dapat mengajukan permohonan cetak ulang melalui aplikasi Mobile JKN atau kantor BPJS terdekat",
      searchCount: "2.39 jt",
    ),
    FAQItem(
      question: "Aplikasi Mobile JKN",
      answer:
          "Aplikasi Mobile JKN adalah aplikasi resmi BPJS Kesehatan untuk memudahkan peserta mengakses layanan",
      searchCount: "2.24 jt",
    ),
    FAQItem(
      question:
          "Siapa saja anggota keluarga yang ditanggung oleh Pekerja Penerima Upah?",
      answer:
          "Pekerja penerima upah menanggung istri/suami dan maksimal 2 anak, atau orang tua jika belum menikah",
      searchCount: "215 jt",
    ),
    FAQItem(
      question: "Apa Hak Peserta",
      answer:
          "Hak peserta meliputi pelayanan kesehatan sesuai standar, informasi yang jelas, dan pengaduan layanan",
      searchCount: "15.7 jt",
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = faqItems;
  }

  void _filterFAQs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = faqItems;
      } else {
        _filteredItems = faqItems.where((item) {
          return item.question.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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
              _buildNavBarItem(Icons.help_outline, 'FAQ', true),
              _buildNavBarItem(Icons.person, 'Profile', false),
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
            // Navigator.pushNamed(context, AppRoutes.faq);
            break;
          case 'Profile':
            Navigator.pushNamed(context, AppRoutes.profile);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "FAQ (Frequently Ask Question)",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGrey, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search, color: AppColors.textLight, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterFAQs,
                      decoration: const InputDecoration(
                        hintText: "Cari pertanyaan...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textLight,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _filterFAQs('');
                      },
                    ),
                ],
              ),
            ),
          ),

          // FAQ List
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tidak ada hasil ditemukan",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return FAQListItem(faqItem: _filteredItems[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }
}

class FAQListItem extends StatefulWidget {
  final FAQItem faqItem;

  const FAQListItem({super.key, required this.faqItem});

  @override
  State<FAQListItem> createState() => _FAQListItemState();
}

class _FAQListItemState extends State<FAQListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        collapsedIconColor: AppColors.textLight,
        iconColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.faqItem.question,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.visibility, size: 12, color: AppColors.lightGrey),
                const SizedBox(width: 4),
                Text(
                  widget.faqItem.searchCount,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.faqItem.answer,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String searchCount;

  FAQItem({
    required this.question,
    required this.answer,
    required this.searchCount,
  });
}
