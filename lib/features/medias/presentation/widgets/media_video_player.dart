import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../domain/entities/entities.dart' as et;
import 'custom_adaptive_video_controls.dart';
import 'media_video_player_controller/media_video_player_controller.dart';
import 'models/player_media.dart';
import 'models/player_media_list.dart';
import 'models/player_subtitle_list.dart';

class MediaVideoPlayer extends StatefulWidget {
  final log = Logger('VideoPlayerWidget');

  MediaVideoPlayer({
    super.key,
    required this.player,
    required this.controller,
    // required this.videoController,
    required this.media,
    // required this.videos,
    // required this.subtitles,
    this.defaultVideoResolution,
    this.onNext,
    this.onPrevious,
  }) {
    // log.info('playing videos: $videos');
  }

  final MediaVideoPlayerController controller;

  final Player player;
  // final VideoController videoController;
  final et.Media media;
  // final List<et.Video> videos;
  // final List<et.Subtitle> subtitles;
  final et.VideoResolution? defaultVideoResolution;
  final Function()? onNext;
  final Function()? onPrevious;

  @override
  State<MediaVideoPlayer> createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends State<MediaVideoPlayer> {
  final logger = Logger('_MediaVideoPlayerState');

  Player get player => widget.player;

  MediaVideoPlayerController get mediaPlayerController => widget.controller;

  late VideoController controller;

  late PlayerMediaList mediasList;

  late PlayerSubtitleList subtitlesList;

  @override
  void initState() {
    super.initState();
    controller = VideoController(player);
    mediaPlayerController.videoNotifier.addListener(_onNewVideo);
    mediaPlayerController.subtitleNotifier.addListener(_onNewSubtitle);
    // mediasList = PlayerMediaList.fromVideoEntityList(
    //   videos: widget.videos,
    //   resolution: et.VideoResolution.p1080,
    //   onChanged: _openNewMedia,
    //   onDefaultMediaSelected: (media) => player.open(media),
    // );
    // subtitlesList = PlayerSubtitleList.fromSubtitleEntityList(
    //   subtitles: widget.subtitles,
    //   defaultLanguage: const LangAra(),
    //   defaultSubtitleKind: 'ass',
    //   onChanged: _openNewSubtitle,
    // );
  }

  @override
  void dispose() {
    logger.info("DISPOSE");
    mediaPlayerController.videoNotifier.removeListener(_onNewVideo);
    super.dispose();
  }

  void _onNewVideo() {
    final video = mediaPlayerController.videoNotifier.value;
    logger.info("new player $video");
    if (video != null) {
      () async {
        await player.stop();
        await Future.delayed(const Duration(seconds: 1));
        await player.open(video);
      }();
      // setState(() {});
    }
  }

  void _onNewSubtitle() {
    final subtitle = mediaPlayerController.subtitleNotifier.value;
    logger.info("new subtitle $subtitle");
    if (subtitle != null) {
      () async {
        await Future.delayed(const Duration(seconds: 5));
        await player.stream.playing.firstWhere((playing) => playing);
        await player.setSubtitleTrack(subtitle);
      };
    }
  }

  @override
  void didUpdateWidget(covariant MediaVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.info("updated widget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.info("dependency changed");
    // controller = VideoController(player);
    // mediasList = PlayerMediaList.fromVideoEntityList(
    //   videos: widget.videos,
    //   resolution: et.VideoResolution.p1080,
    //   onChanged: _openNewMedia,
    //   onDefaultMediaSelected: (media) => player.open(media),
    // );
    // subtitlesList = PlayerSubtitleList.fromSubtitleEntityList(
    //   subtitles: widget.subtitles,
    //   defaultLanguage: const LangAra(),
    //   defaultSubtitleKind: 'ass',
    //   onChanged: _openNewSubtitle,
    // );
  }

  // void _openNewMedia(media) async {
  //   final currentPosition = player.state.position;

  //   await player.open(media);

  //   player.stream.playing.firstWhere((playing) => playing).then((_) async {
  //     if (subtitlesList.currentSubtitle != null) {
  //       logger.info("selecting subtitle ${subtitlesList.currentSubtitle}");
  //       await player.setSubtitleTrack(subtitlesList.currentSubtitle!);
  //     }
  //   });

  //   if (currentPosition > const Duration(seconds: 30)) {
  //     await player.stream.position
  //         .firstWhere((duration) => duration > Durations.short1);

  //     logger.info("seeking to $currentPosition");
  //     await player.seek(currentPosition);
  //   }
  // }

  // void _openNewSubtitle(subtitle) {
  //   if (subtitle != null) {
  //     player.setSubtitleTrack(subtitle);
  //   } else {
  //     player.setSubtitleTrack(SubtitleTrack.no());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    logger.info("building");
    return ValueListenableBuilder(
      valueListenable: mediaPlayerController.videoNotifier,
      builder: (BuildContext context, PlayerVideo? value, Widget? child) {
        return Container(
          child: child,
        );
      },
      child: Video(
        controller: controller,
        // controls: MaterialVideoControls,
        controls: (state) => CustomAdaptiveVideoControls(
          title: widget.media.title,
          videoState: state,
          // playerMediaList: mediasList,
          // playerSubtitleList: subtitlesList,
          onNext: widget.onNext,
          onPrevious: widget.onPrevious,
        ),
      ),
    );
  }
}