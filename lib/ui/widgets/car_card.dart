import 'package:flutter/material.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class CarCard extends StatelessWidget{
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

  const CarCard({
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

  Color _statusColor(String status) {
    switch (status) {
      case 'tersedia': return Color(0xFF27AE60);
      case 'tidak tersedia': return Color(0xFFE74C3C);
      case 'perbaikan': return Color(0xFFF39C12);
      default: return Color(0xFF7A7A7A);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Favorite Button
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Color(0xFFF5F5F5),
                  ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 48,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppTheme.accentColor
                            : AppTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details Section
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$brand $model',
                    // brand model dari tabel katalog
                    style: TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    year.toString(),
                    style: TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 14,
                            color: AppTheme.textTertiary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            transmisi,
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 11,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 14,
                            color: AppTheme.textTertiary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$kapasitas cc',
                            style: TextStyle(
                              fontFamily: 'Mont',
                              fontSize: 11,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 11,
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
}