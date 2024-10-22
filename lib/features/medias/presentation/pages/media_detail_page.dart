import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart';

import '../../../../core/presentation/extensions.dart';
import '../../../../core/presentation/providers/providers.dart';
import '../../domain/entities/media_kind.dart';
import '../widgets/custom_adaptive_video_controls.dart';
import '../widgets/series_widget.dart';

class MediaDetailPage extends ConsumerStatefulWidget {
  const MediaDetailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MediaDetailPageState();
}

class _MediaDetailPageState extends ConsumerState<MediaDetailPage> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) {
      KeepScreenOn.turnOn();

      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
      );
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid || Platform.isIOS) {
      KeepScreenOn.turnOff();
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = ref.watch(mediaProvider);
    final showSeasons = media?.kind == MediaKind.series;

    final phoneView = CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: MediaVideoPlayer(),
          ),
        ),
        const SliverToBoxAdapter(
          child: MediaDetailView(),
        ),
        if (showSeasons)
          const SliverFillRemaining(
            child: SeriesWidget(),
          ),
      ],
    );

    const desktopMainView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 2,
          child: MediaVideoPlayer(),
        ),
        Flexible(child: MediaDetailView()),
      ],
    );

    final desktopView = Padding(
      padding: const EdgeInsets.all(8.0),
      child: showSeasons
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: desktopMainView,
                ),
                SizedBox(width: 25),
                Flexible(
                  child: SeriesWidget(),
                ),
              ],
            )
          : desktopMainView,
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Hero(
        tag: media?.id ?? 'NO_MEDIA',
        child: context.isPhone ? phoneView : desktopView,
      ),
    );
  }
}

class MediaDetailView extends ConsumerWidget {
  const MediaDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(mediaDetailProvider);
    return detail.when(
      data: (data) {
        final num rate = data?.rate ?? 0;

        return ExpansionTile(
          minTileHeight: 25,
          title: Text(
            data?.title ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          collapsedBackgroundColor: Colors.black12,
          backgroundColor: Colors.grey.shade400,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data?.description ?? '',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Rate: $rate⭐",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        );
      },
      error: (error, _) => Text("ERROR: $error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class MediaVideoPlayer extends ConsumerStatefulWidget {
  const MediaVideoPlayer({
    super.key,
    this.showControls = true,
  });

  final bool showControls;

  @override
  ConsumerState<MediaVideoPlayer> createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends ConsumerState<MediaVideoPlayer> {
  static final _logger = Logger('_MediaVideoPlayerState');

  @override
  void initState() {
    super.initState();

    ref.listenManual(
      videoProvider,
      fireImmediately: false,
      (prev, next) async {
        if (prev == next) return;

        _logger.info("new video: $next");
        final player = ref.read(videoPlayerProvider);
        if (next != null) {
          await player.open(next);
          if (ref.context.mounted) {
            final subtitle = ref.read(subtitleProvider);
            if (subtitle != null) {
              await player.setSubtitleTrack(subtitle);
            }
          }
        } else {
          await player.stop();
        }
      },
    );

    ref.listenManual(
      subtitleProvider,
      fireImmediately: false,
      (prev, next) async {
        if (prev == next) return;

        _logger.info("new subtitle: $next");
        final player = ref.read(videoPlayerProvider);
        if (next != null) {
          await player.setSubtitleTrack(next);
        } else {
          await player.setSubtitleTrack(media_kit.SubtitleTrack.no());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoController = ref.watch(videoPlayerControllerProvider);
    final videoBoxFit = ref.watch(videoBoxFitStateProvider);

    return Video(
      fit: videoBoxFit,
      controller: videoController,
      controls:
          widget.showControls ? customAdaptiveVideoControls : NoVideoControls,
    );
  }
}
