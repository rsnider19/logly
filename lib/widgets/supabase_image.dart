import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/services/env_service.dart';

/// A widget that displays an image from a Supabase Storage bucket.
///
/// It constructs the public URL based on the current environment's supabaseUrl
/// and uses [CachedNetworkImage] for performance and caching.
class SupabaseImage extends ConsumerWidget {
  const SupabaseImage({
    required this.bucketName,
    required this.path,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  /// The name of the storage bucket (e.g., 'activity_icons').
  final String bucketName;

  /// The path to the file within the bucket (e.g., 'activity_id.png').
  final String path;

  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dynamically get the base URL from the environment provider
    final baseUrl = EnvService.supabaseUrl;

    // Construct the public storage URL
    // Format: https://[PROJECT_ID].supabase.co/storage/v1/object/public/[BUCKET]/[PATH]
    final imageUrl = '$baseUrl/storage/v1/object/public/$bucketName/$path';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder ?? (context, url) => const SizedBox.shrink(),
      errorWidget:
          errorWidget ??
          (context, url, error) => const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
    );
  }
}
