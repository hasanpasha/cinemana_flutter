import 'package:flutter/material.dart';

import '../../domain/entities/media.dart';
import 'media_thumbnail_image.dart';

class MediaPoster extends StatefulWidget {
  const MediaPoster({
    super.key,
    required this.media,
    this.onPress,
    this.showTitleText = false,
  });

  final bool showTitleText;
  final Media media;
  final Function(Media)? onPress;

  @override
  State<MediaPoster> createState() => _MediaPosterState();
}

class _MediaPosterState extends State<MediaPoster> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => widget.onPress?.call(widget.media),
        child: AspectRatio(
          aspectRatio: 0.66,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: Card(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MediaThumbnailImage(
                        url: widget.media.thumbnail,
                      ),
                    ),
                  ),
                ),
                if (widget.showTitleText)
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        widget.media.title,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
