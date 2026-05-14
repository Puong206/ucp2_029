import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class CarCard extends StatelessWidget {
  final String brand;
  final String model;
  final int year;
  final String? imageUrl;
  final String transmisi;
  final int kapasitas;
  final String status;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final String _baseServerUrl = "http://192.168.10.130:3000"; // Update dengan IP machine Anda

  const CarCard({
    super.key,
    required this.brand,
    required this.model,
    required this.year,
    this.imageUrl,
    required this.transmisi,
    required this.kapasitas,
    required this.status,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  // Resolve image URL - handle relative path atau full URL
  String _resolveImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl; // Already full URL
    return '$_baseServerUrl$imageUrl'; // Prepend base URL untuk relative path
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'tersedia':
        return const Color(0xFF27AE60);
      case 'tidak tersedia':
        return const Color(0xFFE74C3C);
      case 'perbaikan':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF7A7A7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Print image URL
    print('CarCard - brand: $brand, imageUrl: $imageUrl, resolved: ${_resolveImageUrl(imageUrl)}');
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Column + Expanded agar konten tidak overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Section ─────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image container (pakai Expanded, tidak fixed height)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      color: const Color(0xFFF0F0F5),
                      child: _resolveImageUrl(imageUrl).isNotEmpty
                          ? Image.network(
                              _resolveImageUrl(imageUrl),
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
                                print('Image load error for $brand: $error');
                                return _carPlaceholder();
                              },
                            )
                          : _carPlaceholder(),
                    ),
                  ),
                ],
              ),
            ),

            // ── Details Section ──────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand + Model
                  Text(
                    '$brand $model',
                    style: const TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Year
                  Text(
                    year.toString(),
                    style: const TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Transmisi & Kapasitas
                  Row(
                    children: [
                      const Icon(Icons.settings_outlined,
                          size: 12, color: AppTheme.textTertiary),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          transmisi,
                          style: const TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 10,
                            color: AppTheme.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.speed_outlined,
                          size: 12, color: AppTheme.textTertiary),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '$kapasitas cc',
                          style: const TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 10,
                            color: AppTheme.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carPlaceholder() {
    return const Center(
      child: Icon(
        Icons.directions_car_outlined,
        size: 40,
        color: AppTheme.textTertiary,
      ),
    );
  }
}