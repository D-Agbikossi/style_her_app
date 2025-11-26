/**
 * Profile Picture Widget
 * 
 * A reusable widget for displaying user profile pictures with:
 * - Cached network image loading
 * - Error handling and fallback
 * - Loading state
 * - Customizable size
 */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    this.radius = 30,
    this.fallbackIcon = Icons.person,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided background color or default grey
    final bgColor = backgroundColor ?? Colors.grey[300]!;
    // Only show border if both color and width are provided
    final border = borderColor != null && borderWidth != null
        ? Border.all(color: borderColor!, width: borderWidth!)
        : null;

    return Container(
      width: radius * 2, // Diameter = 2 * radius
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      child: ClipOval(
        // Show network image if URL provided, otherwise show placeholder icon
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover, // Fill circle while maintaining aspect ratio
                // Show loading indicator while image loads
                placeholder: (context, url) => Container(
                  color: bgColor,
                  child: Center(
                    child: SizedBox(
                      width: radius * 0.5, // Loading indicator size proportional to radius
                      height: radius * 0.5,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[600]!,
                        ),
                      ),
                    ),
                  ),
                ),
                // Show fallback icon if image fails to load
                errorWidget: (context, url, error) => Container(
                  color: bgColor,
                  child: Icon(
                    fallbackIcon,
                    color: Colors.grey[600],
                    size: radius * 0.8, // Icon size proportional to radius
                  ),
                ),
              )
            // No URL provided - show placeholder icon
            : Container(
                color: bgColor,
                child: Icon(
                  fallbackIcon,
                  color: Colors.grey[600],
                  size: radius * 0.8,
                ),
              ),
      ),
    );
  }
}


