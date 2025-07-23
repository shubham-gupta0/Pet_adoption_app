import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const PlatformAwareImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
  });

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Widget _buildFallbackWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, color: Colors.grey[400], size: 40),
          const SizedBox(height: 8),
          Text(
            'Image unavailable',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return fallback immediately if URL is invalid
    if (!_isValidImageUrl(imageUrl)) {
      return _buildFallbackWidget();
    }

    if (kIsWeb) {
      // Use standard Image.network for web to avoid CORS and decoding issues.
      // The browser's native caching will handle performance.
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Image loading error for URL $imageUrl: $error');
          return _buildFallbackWidget();
        },
      );
    } else {
      // Use CachedNetworkImage for mobile for better performance and caching.
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) {
          print('CachedNetworkImage error for URL $url: $error');
          return _buildFallbackWidget();
        },
      );
    }
  }
}
