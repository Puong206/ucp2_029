import 'package:flutter/material.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/ui/theme/app_theme.dart';
import 'package:ucp2/ui/widgets/feature_highlight.dart';
import 'package:ucp2/ui/widgets/auth_button.dart';

class CarPage extends StatefulWidget {
  final KatalogModel katalog;

  const CarPage({required this.katalog});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  bool _isFavorite = false;
  int _selectedTabIndex = 0;

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTabIndex = index);
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 8),
              height: 2,
              width: 40,
              color: AppTheme.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildSpecsTab();
      case 2:
        return _buildReviewsTab();
      default:
        return Container();
    }
  }

  Widget _buildOverviewTab() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sorotan Fitur',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            children: [
              FeatureHighlight(
                icon: Icons.speed,
                label: 'Kecepatan',
                value: '180 km/h',
              ),
              FeatureHighlight(
                icon: Icons.local_gas_station,
                label: 'Bahan Bakar',
                value: 'Bensin',
              ),
              FeatureHighlight(
                icon: Icons.speed,
                label: 'Kapasitas',
                value: '${widget.katalog.kapasitas} cc',
              ),
              FeatureHighlight(
                icon: Icons.settings,
                label: 'Transmisi',
                value: widget.katalog.transmisi,
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Deskripsi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 12),
          Text(
            'Sedan mewah dengan fitur premium dan kenyamanan. Sempurna untuk perjalanan bisnis dan perjalanan jauh.',
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsTab() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _specRow('Merek', widget.katalog.brand),
          _specRow('Model', widget.katalog.model),
          _specRow('Tahun', widget.katalog.year.toString()),
          _specRow('Transmisi', widget.katalog.transmisi),
          _specRow('Kapasitas', '${widget.katalog.kapasitas} cc'),
          _specRow('Status', widget.katalog.status),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ulasan Pelanggan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          // Placeholder for reviews
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontFamily: 'Mont',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: AppTheme.secondaryColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Mobil yang luar biasa! Bersih, nyaman, dan terawat dengan baik. Sangat direkomendasikan!',
                  style: TextStyle(
                    fontFamily: 'Mont',
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Car Image
                  Container(
                    color: Color(0xFFF5F5F5),
                    child: widget.katalog.imageUrl != null
                        ? Image.network(
                            widget.katalog.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Icon(
                              Icons.directions_car,
                              size: 80,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite
                        ? AppTheme.accentColor
                        : AppTheme.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                  },
                ),
              ),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.katalog.brand} ${widget.katalog.model}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppTheme.secondaryColor, size: 18),
                          SizedBox(width: 4),
                          Text(
                            '4.8 (320 reviews)',
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.katalog.status == 'tersedia'
                              ? Color(0xFF27AE60).withOpacity(0.1)
                              : widget.katalog.status == 'perbaikan'
                                  ? Color(0xFFF39C12).withOpacity(0.1)
                                  : Color(0xFFE74C3C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.katalog.status,
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: widget.katalog.status == 'tersedia'
                                ? Color(0xFF27AE60)
                                : widget.katalog.status == 'perbaikan'
                                    ? Color(0xFFF39C12)
                                    : Color(0xFFE74C3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildTab('Ulasan', 0),
                      SizedBox(width: 16),
                      _buildTab('Spesifikasi', 1),
                      SizedBox(width: 16),
                      _buildTab('Komentar', 2),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Tab Content
                _buildTabContent(),

                SizedBox(height: 24),

                // Booking Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthButton(
                        label: 'Pesan Sekarang',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Booking for ${widget.katalog.brand} ${widget.katalog.model}',
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      AuthButton(
                        label: 'Hubungi Dukungan',
                        isOutlined: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}