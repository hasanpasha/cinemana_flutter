import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_provider/go_provider.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart' show Player, PlayerConfiguration;
import 'package:sealed_languages/sealed_languages.dart';

import '../../domain/entities/entities.dart';
import '../bloc/media_info/media_info_bloc.dart';
import '../bloc/media_player_data/media_player_data_bloc.dart';
import '../bloc/media_seasons/media_seasons_bloc.dart';
import '../widgets/bloc_shimmer_loading.dart';
import '../widgets/description_text.dart';
import '../widgets/media_video_player_controller/media_controller.dart';
import '../widgets/media_video_player.dart';

import '../widgets/media_video_player_controller/media_video_player_controller.dart';
import '../widgets/media_video_player_controller/player_subtitle_controller.dart';
import '../widgets/media_video_player_controller/player_video_controller.dart';
import '../widgets/models/series_state.dart';
import '../widgets/shimmer.dart';
import '../widgets/tabbed_seasons.dart';

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
  final logger = Logger('_MediaDetailPageState');

  late final TabbedSeasonsController tabbedSeasonsController;
  late final MediaController mediaController;
  late final PlayerVideoController playerVideoController;
  late final PlayerSubtitleController playerSubtitleController;
  late final MediaVideoPlayerController mediaVideoPlayerController;

  final player = Player(
    configuration: const PlayerConfiguration(
      libass: true,
      libassAndroidFont: "assets/fonts/AdobeArabic-Regular.ttf",
      libassAndroidFontName: "Adobe Arabic",
    ),
  );

  Media get rootMedia => widget.media;

  late Media currentMedia = rootMedia;

  SeriesState? seriesState;
  Episode? currentEpisode;

  @override
  void initState() {
    super.initState();
    tabbedSeasonsController = TabbedSeasonsController();

    mediaController = MediaController();
    playerVideoController =
        PlayerVideoController(defaultVideoResolution: VideoResolution.p1080);
    playerSubtitleController = PlayerSubtitleController(
        defaultSubtitleLanguage: const LangAra(),
        defaultSubtitleExtension: 'ssa');
    mediaVideoPlayerController = MediaVideoPlayerController(
      mediaController: mediaController,
      playerVideoController: playerVideoController,
      playerSubtitleController: playerSubtitleController,
    );

    mediaVideoPlayerController.openMedia(widget.media);

    // BlocProvider.of<MediaInfoBloc>(context).add(MediaInfoRequested(rootMedia));
    // BlocProvider.of<MediaPlayerDataBloc>(context)
    //     .add(MediaPlayerDataRequested(rootMedia));
    // if (rootMedia.kind == MediaKind.series) {
    //   BlocProvider.of<MediaSeasonsBloc>(context)
    //       .add(MediaSeasonsRequested(rootMedia));
    // }
  }

  @override
  void dispose() {
    // player.dispose();
    player.stop();
    mediaVideoPlayerController.dispose();
    mediaController.dispose();
    playerVideoController.dispose();
    playerSubtitleController.dispose();
    tabbedSeasonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slivers = [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocShimmerLoading<MediaInfoBloc, MediaInfoState,
              MediaInfoLoaded>(
            onLoaded: (state) => Text(
              state.media.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            minLoadingWidth: 300,
            minLoadingHeight: 40,
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlocProvider<MediaInfoBloc>.value(
              value: BlocProvider.of(context),
              child: BlocShimmerLoading<MediaInfoBloc, MediaInfoState,
                  MediaInfoLoaded>(
                onLoaded: (state) {
                  return DescriptionText(state.media.description);
                },
                minLoadingHeight: 200,
              ),
            ),
          ),
        ),
      ),
    ];

    final smallScreenView = Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: buildVideo(currentMedia)),
          ...slivers,
          if (rootMedia.kind == MediaKind.series)
            SliverFillRemaining(
              child: buildSeasonsTabs(),
            ),
        ],
      ),
    );

    final bigScreenView = Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
                flex: 2,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            buildVideo(currentMedia),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: GoPopButton(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...slivers,
                  ],
                )),
            if (rootMedia.kind == MediaKind.series)
              Flexible(child: buildSeasonsTabs()),
          ],
        ),
      ),
    );

    // return Shimmer(
    //   linearGradient: shimmerGradient,
    //   child: smallScreenView,
    // );
    return requestMediaSeasonsIfSeries(
      child: Shimmer(
        linearGradient: shimmerGradient,
        child: MediaQuery.sizeOf(context).width <= 600
            ? smallScreenView
            : bigScreenView,
      ),
    );
  }

  Widget requestMediaSeasonsIfSeries({Widget? child}) {
    // if (rootMedia.kind == MediaKind.movies) {
    return Container(
      child: child,
    );
    // }

    // return BlocProvider<MediaSeasonsBloc>.value(
    //   value: BlocProvider.of(context),
    //   child: BlocListener<MediaSeasonsBloc, MediaSeasonsState>(
    //     // listenWhen: (_, current) => current is MediaSeasonsState,
    //     listener: (context, state) {
    //       if (state is MediaSeasonsLoaded) {
    //         seriesState = SeriesState.fromSeriesSeasons(
    //           seasons: state.seasons,
    //           onMediaChanged: (media) {
    //             logger.info("media changed $media");
    //             setState(() => currentMedia = media);
    //             tabbedSeasonsController.setCurrentEpisode(media as Episode);

    //             // int? seasonIdx = seriesState?.currentSeason.number;
    //             // if (seasonIdx != null) {
    //             //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //             //     tabbedSeasonsController
    //             //         .setCurrentSeasonIndex(seasonIdx - 1);
    //             //   });
    //             // }
    //             BlocProvider.of<MediaPlayerDataBloc>(context)
    //                 .add(MediaPlayerDataRequested(currentMedia));
    //           },
    //         );
    //         setState(() {});
    //       }
    //     },
    //     child: child,
    //   ),
    // );
  }

  Widget videoPlayer(Media media) {
    return MediaVideoPlayer(
      player: player,
      // videoController: videoController,
      controller: mediaVideoPlayerController,
      // videos: state.videos,
      // subtitles: state.subtitles,
      media: currentMedia,
      // onNext: onNext,
      // onPrevious: onPrevious,
    );

    // return Shimmer(
    //   linearGradient: shimmerGradient,
    //   child: BlocProvider<MediaPlayerDataBloc>.value(
    //     value: BlocProvider.of(context),
    //     child: BlocShimmerLoading<MediaPlayerDataBloc, MediaPlayerDataState,
    //         MediaPlayerDataLoaded>(
    //       onLoaded: (state) {
    //         // logger.info("got media player data $state for $media");

    //         Function()? onNext;
    //         Function()? onPrevious;

    //         if (seriesState?.hasNext ?? false) {
    //           onNext = () => seriesState?.switchToNextEpisode();
    //         }

    //         if (seriesState?.hasPrevious ?? false) {
    //           onPrevious = () => seriesState?.switchToPreviousEpisode();
    //         }

    //         return MediaVideoPlayer(
    //           player: player,
    //           // videoController: videoController,
    //           controller: mediaVideoPlayerController,
    //           videos: state.videos,
    //           subtitles: state.subtitles,
    //           media: currentMedia,
    //           onNext: onNext,
    //           onPrevious: onPrevious,
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  Widget buildVideo(Media media) {
    late final Widget videoWidget;
    videoWidget = videoPlayer(media);
    // if (rootMedia.kind == MediaKind.movies) {
    // } else {
    //   videoWidget = BlocShimmerLoading<MediaSeasonsBloc, MediaSeasonsState,
    //       MediaSeasonsLoaded>(
    //     onLoaded: (state) {
    //       return videoPlayer(media);
    //     },
    //   );
    // }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: videoWidget,
    );
  }

  Widget buildSeasonsTabs() {
    if (rootMedia.kind == MediaKind.movies) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: mediaVideoPlayerController.seasonsNotifier,
      builder: (BuildContext context, List<Season>? value, Widget? child) {
        if (value != null) {
          return TabbedSeasons(
            controller: tabbedSeasonsController,
            // selectedEpisode: currentEpisode,
            seasons: value,
            // onEpisodeSelect: (episode) => seriesState?.setCurrentEpisode(episode),
            onEpisodePlay: (episode) {
              mediaVideoPlayerController.openMedia(episode);
              // logger.info("seriesState == null ${seriesState == null}");
              // logger.info("playing $episode");
              // final changed = seriesState?.setCurrentEpisode(episode);
              // logger.info("switched to another page: $changed");
            },
          );
        } else {
          return Placeholder();
        }
      },
    );

    // return BlocShimmerLoading<MediaSeasonsBloc, MediaSeasonsState,
    //     MediaSeasonsLoaded>(
    //   onLoaded: (state) {
    //     return TabbedSeasons(
    //       controller: tabbedSeasonsController,
    //       // selectedEpisode: currentEpisode,
    //       seasons: state.seasons,
    //       // onEpisodeSelect: (episode) => seriesState?.setCurrentEpisode(episode),
    //       onEpisodePlay: (episode) {
    //         logger.info("seriesState == null ${seriesState == null}");
    //         logger.info("playing $episode");
    //         final changed = seriesState?.setCurrentEpisode(episode);
    //         logger.info("switched to another page: $changed");
    //       },
    //     );
    //   },
    // );
  }
}
