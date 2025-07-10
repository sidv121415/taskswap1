import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/theme.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final bool isOnline;
  final double size;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.isOnline = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildFallbackAvatar(),
                  )
                : _buildFallbackAvatar(),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: AppTheme.primaryColor,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}