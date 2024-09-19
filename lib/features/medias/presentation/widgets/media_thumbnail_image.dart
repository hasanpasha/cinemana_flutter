import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaThumbnailImage extends StatelessWidget {
  const MediaThumbnailImage({
    super.key,
    required this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.66,
      child: url != null
          ? CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => Center(
                  child: CircularProgressIndicator(value: progress.progress)),
              imageUrl: url!,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 10, maxWidth: 10),
              child: Image.asset(
                "assets/images/cinemana.png",
              ),
            ),
    );
  }
}
