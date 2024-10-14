import 'package:flutter/material.dart';
import 'package:go_provider/go_provider.dart';
import 'package:logging/logging.dart';
import 'package:media_kit_video/media_kit_video.dart';

class CustomAdaptiveVideoControls extends StatefulWidget {
  const CustomAdaptiveVideoControls({
    super.key,
    required this.videoState,
    required this.title,
    // required this.playerMediaList,
    // required this.playerSubtitleList,
    this.onNext,
    this.onPrevious,
  });

  final VideoState videoState;

  final String title;

  // final PlayerMediaList playerMediaList;
  // final PlayerSubtitleList playerSubtitleList;

  final Function()? onNext;
  final Function()? onPrevious;

  @override
  State<CustomAdaptiveVideoControls> createState() =>
      _CustomAdaptiveVideoControlsState();
}

class _CustomAdaptiveVideoControlsState
    extends State<CustomAdaptiveVideoControls> {
  final log = Logger('_CustomAdaptiveVideoControlsState');

  // PlayerMediaList get mediaList => widget.playerMediaList;
  // PlayerSubtitleList get subtitleList => widget.playerSubtitleList;

  VideoState get videoState => widget.videoState;

  TargetPlatform get platform => Theme.of(context).platform;
  bool get isPhone =>
      (platform == TargetPlatform.android || platform == TargetPlatform.iOS);

  bool get isDesktop => (platform == TargetPlatform.linux ||
      platform == TargetPlatform.macOS ||
      platform == TargetPlatform.windows);

  @override
  Widget build(BuildContext context) {
    if (isPhone) {
      return _buildForPhone();
    } else if (isDesktop) {
      return _buildForDesktop();
    } else {
      return NoVideoControls(videoState);
    }
  }

  Widget _buildForPhone() {
    final themeData = MaterialVideoControlsThemeData(
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      volumeGesture: true,
      brightnessGesture: true,
      seekGesture: true,
      seekOnDoubleTap: true,
      // buttonBarButtonSize: 24.0,
      // buttonBarButtonColor: Colors.white,
      displaySeekBar: true,
      seekBarMargin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      seekBarThumbSize: 18,
      primaryButtonBar: [
        const Spacer(flex: 2),
        if (widget.onPrevious != null)
          MaterialCustomButton(
            onPressed: () {
              widget.onPrevious?.call();
            },
            icon: const Icon(Icons.skip_previous),
          ),

        // const MaterialSkipPreviousButton(),
        const Spacer(),
        const MaterialPlayOrPauseButton(iconSize: 48.0),
        const Spacer(),
        if (widget.onNext != null)
          MaterialCustomButton(
            onPressed: () => widget.onNext?.call(),
            icon: const Icon(Icons.skip_next),
          ),
        // const MaterialSkipNextButton(),
        const Spacer(flex: 2),
      ],
      topButtonBar: [
        const Spacer(),
        // MaterialCustomButton(
        //   onPressed: showSettingsModalBottomSheet,
        //   icon: const Icon(Icons.settings),
        // ),
      ],
      // seekBar
      bottomButtonBarMargin: const EdgeInsets.all(12),
      bottomButtonBar: [
        const MaterialPositionIndicator(),
        const Spacer(),
        const MaterialFullscreenButton(),
      ],
    );

    return MaterialVideoControlsTheme(
      normal: themeData.copyWith(
        topButtonBarMargin: const EdgeInsets.only(top: 16, right: 10),
        topButtonBar: [
          const GoPopButton(),
          ...themeData.topButtonBar,
        ],
      ),
      fullscreen: themeData.copyWith(
        topButtonBarMargin: const EdgeInsets.only(top: 10, right: 16),
        topButtonBar: [
          const BackButton(),
          FittedBox(
            child: Text(
              widget.title,
              softWrap: true,
              // style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...themeData.topButtonBar,
        ],
      ),
      child: MaterialVideoControls(widget.videoState),
    );
  }

  Widget _buildForDesktop() {
    final themeData = MaterialDesktopVideoControlsThemeData(
      // seekBarThumbColor: Colors.blue,
      // seekBarPositionColor: Colors.blue,
      toggleFullscreenOnDoublePress: true,
      hideMouseOnControlsRemoval: true,

      topButtonBar: [
        // const GoPopButton(),
        // Text(
        //   widget.title,
        //   style: Theme.of(context).textTheme.titleLarge,
        // ),
        // const Spacer(),
      ],
      bottomButtonBar: [
        const MaterialDesktopPlayOrPauseButton(),
        if (widget.onPrevious != null)
          MaterialDesktopCustomButton(
            onPressed: () => widget.onPrevious?.call(),
            icon: const Icon(Icons.skip_previous),
          ),
        if (widget.onNext != null)
          MaterialDesktopCustomButton(
            onPressed: () => widget.onNext?.call(),
            icon: const Icon(Icons.skip_next),
          ),
        const MaterialDesktopVolumeButton(),
        const MaterialDesktopPositionIndicator(),
        const Spacer(),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              // PopupMenuItem(child: videoResolutionPopupMenu()),
              // PopupMenuItem(child: subtitlesPopupMenu()),
            ];
          },
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
        const MaterialDesktopFullscreenButton(),
      ],
    );

    return MaterialDesktopVideoControlsTheme(
      normal: themeData.copyWith(),
      fullscreen: themeData.copyWith(),
      child: MaterialDesktopVideoControls(videoState),
    );
  }

  // void showSubtitleModalBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ListView.builder(
  //         clipBehavior: Clip.hardEdge,
  //         itemCount: widget.playerSubtitleList.subtitles.length,
  //         itemBuilder: (context, index) {
  //           final subtitle =
  //               widget.playerSubtitleList.subtitles.toList()[index];
  //           return ListTile(
  //             selected: widget.playerSubtitleList.currentSubtitle == subtitle,
  //             title: Text(subtitle.toString()),
  //             onTap: () {
  //               widget.playerSubtitleList.currentSubtitle = subtitle;
  //               Navigator.pop(context);
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void showQualityModalBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ListView.builder(
  //         clipBehavior: Clip.hardEdge,
  //         itemCount: widget.playerMediaList.medias.length,
  //         itemBuilder: (context, index) {
  //           final media = widget.playerMediaList.medias[index];
  //           return ListTile(
  //             selected: widget.playerMediaList.currentMedia == media,
  //             title: Text(media.toString()),
  //             onTap: () {
  //               mediaList.currentMedia = media;
  //               Navigator.pop(context);
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void showSettingsModalBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ListView(
  //         clipBehavior: Clip.hardEdge,
  //         children: [
  //           ListTile(
  //             title: const Text("Quality"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               showQualityModalBottomSheet();
  //             },
  //           ),
  //           ListTile(
  //             title: const Text("Subtitle"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               showSubtitleModalBottomSheet();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget subtitlesPopupMenu() {
  //   final currentSubtitleTrack = subtitleList.currentSubtitle;
  //   return PopupMenuButton(
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         onTap: () {
  //           subtitleList.currentSubtitle = null;
  //           Navigator.pop(context);
  //         },
  //         child: const Text("No Subtitle"),
  //       ),
  //       ...subtitleList.subtitles.map(
  //         (subtitle) => CustomPopupMenuItem(
  //           isSelected: currentSubtitleTrack == subtitle,
  //           child: Text(subtitle.toString()),
  //           onTap: () {
  //             subtitleList.currentSubtitle = subtitle;
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //       PopupMenuItem(
  //         onTap: () {
  //           _pickLocalSubtitle();
  //           Navigator.pop(context);
  //         },
  //         child: const Text("select external subtitle"),
  //       ),
  //     ],
  //     child: ListTile(
  //       title: const Text("Subtitle"),
  //       subtitle: Text(currentSubtitleTrack.toString()),
  //     ),
  //   );
  // }

  // void _pickLocalSubtitle() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.custom,
  //     allowedExtensions: ['ass', 'ssa', 'srt', 'vtt'],
  //   );
  //   if (result == null) return null;
  //   final selectedFile = result.files.single;

  //   final fileTrack = PlayerSubtitle.fromLocalFile(selectedFile);

  //   subtitleList.currentSubtitle = fileTrack;
  // }

  // Widget videoResolutionPopupMenu() {
  //   return PopupMenuButton<PlayerVideo>(
  //     itemBuilder: (context) => mediaList.medias.map((media) {
  //       return CustomPopupMenuItem<PlayerVideo>(
  //         isSelected: media == mediaList.currentMedia,
  //         selectedBackgroundColor: Colors.green.shade400,
  //         onTap: () {
  //           mediaList.currentMedia = media;
  //           Navigator.pop(context);
  //         },
  //         child: Text(media.toString()),
  //       );
  //     }).toList(),
  //     child: ListTile(
  //       title: const Text("Quality"),
  //       subtitle: Text(mediaList.currentMedia.toString()),
  //     ),
  //   );
  // }

  // void _openSelectedMedia(int idx) {
  //   final currentSubtitleTrack = player.state.track.subtitle;
  //   final currentPosition = player.state.position;
  //   player.jump(idx).then((_) {
  //     player.stream.playing.firstWhere((playing) => playing).then((_) async {
  //       log.info("selecting subtitle $currentSubtitleTrack");
  //       await player.setSubtitleTrack(currentSubtitleTrack);
  //     });
  //     if (currentPosition > const Duration(seconds: 30)) {
  //       player.stream.position
  //           .firstWhere((duration) => duration > Durations.short1)
  //           .then((_) async {
  //         log.info("seeking to $currentPosition");
  //         player.seek(currentPosition);
  //       });
  //     }
  //   });
  // }
}
