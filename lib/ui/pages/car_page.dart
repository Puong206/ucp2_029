import 'package:flutter/material.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class CarPage extends StatefulWidget {
  final KatalogModel katalog;

  const CarPage({required this.katalog});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final String _baseServerUrl = "http://192.168.10.130:3000"; // Update sesuai IP machine Anda

  // Resolve image URL - handle relative path atau full URL
  String _resolveImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl; // Already full URL
    return '$_baseServerUrl$imageUrl'; // Prepend base URL untuk relative path
  }

  // Get status badge color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return AppTheme.successColor;
      case 'perbaikan':
        return AppTheme.warningColor;
      case 'tidak tersedia':
        return AppTheme.errorColor;
      default:
        return AppTheme.textTertiary;
    }
  }

  // Build info card
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.secondaryColor, size: 24),
          SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.textTertiary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
          // App Bar with Car Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
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
            
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Car Image
                  Container(
                    color: Color(0xFFF5F5F5),
                    child: _resolveImageUrl(widget.katalog.imageUrl).isNotEmpty
                        ? Image.network(
                            _resolveImageUrl(widget.katalog.imageUrl),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppTheme.secondaryColor,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Image load error: $error');
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      size: 80,
                                      color: AppTheme.textTertiary,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Gagal memuat gambar',
                                      style: TextStyle(
                                        fontFamily: 'Mont',
                                        color: AppTheme.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand and Model
                      Text(
                        widget.katalog.brand,
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.katalog.model,
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Status Badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.katalog.status)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.katalog.status,
                          style: TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _getStatusColor(widget.katalog.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Cards Grid (2x2)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildInfoCard(
                        icon: Icons.category,
                        label: 'Kategori',
                        value: widget.katalog.namaKategori ?? 'Umum',
                      ),
                      _buildInfoCard(
                        icon: Icons.settings,
                        label: 'Transmisi',
                        value: widget.katalog.transmisi,
                      ),
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        label: 'Tahun',
                        value: widget.katalog.year.toString(),
                      ),
                      _buildInfoCard(
                        icon: Icons.speed,
                        label: 'Kapasitas',
                        value: '${widget.katalog.kapasitas} cc',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}