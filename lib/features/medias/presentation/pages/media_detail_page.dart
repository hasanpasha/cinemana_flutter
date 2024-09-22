import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/media.dart';

class MediaDetailPage extends StatefulWidget {
  const MediaDetailPage({
    super.key,
    required this.media,
  });

  final Media media;

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            // leading: IconButton(
            //     onPressed: () {
            //       GoRouter.of(context).pop();
            //     },
            //     icon: const Icon(Icons.arrow_back)),
            elevation: 8,
            expandedHeight: 500,
            pinned: false,
            floating: false,
            snap: false,
            primary: true,
            title: Text(
              widget.media.title,
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: widget.media.poster != null
                    ? CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) =>
                            SizedBox(
                          height: 50,
                          width: 50,
                          child: FittedBox(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                        ),
                        imageUrl: widget.media.poster!,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Play",
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (widget.media.isMovie)
                    const Column(
                      children: [
                        Placeholder(),
                        Placeholder(),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
