import 'package:flutter/material.dart';
import 'package:ucp2/data/models/katalog_model.dart';

class CarCard extends StatelessWidget{
  final KatalogModel katalog;
  final Function()? onTap;
  final Function()? onFavoriteTap;

  const CarCard({
    required this.katalog,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: katalog.imageUrl != null
                      ? Image.network(
                          katalog.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.directions_car,
                            size: 40,
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Color(0xFFE74C3C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${katalog.brand} ${katalog.model}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${katalog.transmisi} • ${katalog.kapasitas} cc',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFFB84D),
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