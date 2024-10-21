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
  Media get media => widget.media;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => widget.onPress?.call(widget.media),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  fit: StackFit.expand,
                  children: [
                    MediaThumbnailImage(
                      url: media.thumbnail,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 2.0,
                              right: 2.0,
                            ),
                            child: Text(
                              media.year.toString(),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // if (widget.showTitleText)
            Visibility(
              visible: widget.showTitleText,
              child: Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    media.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
