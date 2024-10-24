import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../../core/presentation/providers/providers.dart';
import '../../domain/entities/video_resolution.dart';
import 'custom_popup_menu_item.dart';
import '../../../../core/presentation/models/player_subtitle.dart';

Widget customAdaptiveVideoControls(VideoState state) {
  switch (Theme.of(state.context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return CustomMaterialVideoControls(state);
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return CustomMaterialDesktopVideoControls(state);
    default:
      return NoVideoControls(state);
  }
}

class CustomMaterialVideoControls extends StatelessWidget {
  const CustomMaterialVideoControls(this.state, {super.key});

  final VideoState state;

  @override
  Widget build(BuildContext context) {
    final themeData = MaterialVideoControlsThemeData(
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      volumeGesture: true,
      brightnessGesture: true,
      seekGesture: true,
      seekOnDoubleTap: true,
      displaySeekBar: true,
      seekBarMargin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      seekBarThumbSize: 18,
      primaryButtonBar: const [
        Spacer(flex: 2),
        PreviousButton(),
        Spacer(),
        MaterialPlayOrPauseButton(iconSize: 48.0),
        Spacer(),
        NextButton(),
        Spacer(flex: 2),
      ],
      topButtonBar: [
        const Spacer(),
        MaterialCustomButton(
          onPressed: () => showSettingsModalBottomSheet(context),
          icon: const Icon(Icons.settings),
        ),
      ],
      // seekBar
      bottomButtonBarMargin: const EdgeInsets.all(12),
      bottomButtonBar: const [
        MaterialPositionIndicator(),
        Spacer(),
        MaterialFullscreenButton(),
      ],
    );

    return MaterialVideoControlsTheme(
      normal: themeData.copyWith(
        // topButtonBarMargin: const EdgeInsets.only(top: 16, right: 10),
        topButtonBar: [
          ...themeData.topButtonBar,
        ],
      ),
      fullscreen: themeData.copyWith(
        topButtonBarMargin: const EdgeInsets.only(top: 10, right: 16),
        topButtonBar: [
          ...themeData.topButtonBar,
        ],
      ),
      child: MaterialVideoControls(state),
    );
  }

  void showSubtitleModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final availableSubtitles = ref.watch(availableSubtitlesProvider);
            final currentSubtitle = ref.watch(subtitleProvider);

            if (availableSubtitles == null) return const SizedBox.shrink();

            return ListView(
              clipBehavior: Clip.hardEdge,
              children: [
                ...availableSubtitles.map(
                  (subtitle) {
                    final isSelected = currentSubtitle == subtitle;

                    return ListTile(
                      selected: isSelected,
                      title: Text(subtitle.toString()),
                      onTap: () {
                        ref.read(subtitleProvider.notifier).state = subtitle;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Select Local subtitle"),
                  onTap: () async {
                    final newSubtitle = await _pickLocalSubtitle();
                    if (newSubtitle != null) {
                      ref
                          .read(availableSubtitlesProvider.notifier)
                          .add(newSubtitle);
                      ref.read(subtitleProvider.notifier).state = newSubtitle;
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  title: const Text("Hide subtitle"),
                  onTap: () {
                    ref.read(subtitleProvider.notifier).state = null;
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showResolutionModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final videos = ref.watch(availableVideosProvider);

            if (videos == null) return const SizedBox.shrink();

            return ListView.builder(
              clipBehavior: Clip.hardEdge,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final currentVideo = videos.elementAt(index);
                final isSelected = ref.read(videoResolutionProvider) ==
                    currentVideo.resolution;

                return ListTile(
                  selected: isSelected,
                  title: Text(currentVideo.toString()),
                  onTap: () {
                    ref.read(videoProvider.notifier).state = currentVideo;
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void showBoxFitModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final currentBoxFit = ref.watch(videoBoxFitStateProvider);
            const allBoxFitOptions = BoxFit.values;

            return ListView.builder(
              itemCount: allBoxFitOptions.length,
              itemBuilder: (BuildContext context, int index) {
                final value = allBoxFitOptions.elementAt(index);
                final isSelected = value == currentBoxFit;

                return ListTile(
                  selected: isSelected,
                  title: Text(value.name),
                  onTap: () {
                    ref.watch(videoBoxFitStateProvider.notifier).state = value;
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void showSettingsModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          clipBehavior: Clip.hardEdge,
          children: [
            ListTile(
              title: const Text("Resolution"),
              onTap: () {
                Navigator.pop(context);
                showResolutionModalBottomSheet(context);
              },
            ),
            ListTile(
              title: const Text("Subtitle"),
              onTap: () {
                Navigator.pop(context);
                showSubtitleModalBottomSheet(context);
              },
            ),
            ListTile(
              title: const Text("Fit"),
              onTap: () {
                Navigator.pop(context);
                showBoxFitModalBottomSheet(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomMaterialDesktopVideoControls extends StatelessWidget {
  const CustomMaterialDesktopVideoControls(this.state, {super.key});

  final VideoState state;

  @override
  Widget build(BuildContext context) {
    final themeData = MaterialDesktopVideoControlsThemeData(
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
        const PreviousButton(),
        const NextButton(),
        const MaterialDesktopVolumeButton(),
        const MaterialDesktopPositionIndicator(),
        const Spacer(),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(child: buildVideoResolutionsPopupMenu()),
              PopupMenuItem(child: buildSubtitlesPopupMenu()),
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
      child: MaterialDesktopVideoControls(state),
    );
  }

  Widget buildSubtitlesPopupMenu() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final subtitles = ref.watch(availableSubtitlesProvider);

        if (subtitles == null) return const SizedBox.shrink();

        return PopupMenuButton<PlayerSubtitle>(
          itemBuilder: (context) => [
            ...subtitles.map((subtitle) {
              final isSelected = ref.read(subtitleProvider) == subtitle;
              return CustomPopupMenuItem<PlayerSubtitle>(
                isSelected: isSelected,
                selectedBackgroundColor: Colors.green.shade400,
                onTap: () {
                  ref.read(subtitleProvider.notifier).state = subtitle;
                  Navigator.pop(context);
                },
                child: Text(subtitle.name),
              );
            }),
            PopupMenuItem(
              child: const Text("Select Local subtitle"),
              onTap: () async {
                final newSubtitle = await _pickLocalSubtitle();
                if (newSubtitle != null) {
                  ref
                      .read(availableSubtitlesProvider.notifier)
                      .add(newSubtitle);
                  ref.read(subtitleProvider.notifier).state = newSubtitle;
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            PopupMenuItem(
              child: const Text("No subtitle"),
              onTap: () {
                ref.read(subtitleProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
          ],
          child: ListTile(
            title: const Text("Subtitles"),
            subtitle: Text(ref.watch(subtitleProvider)?.name ?? ''),
          ),
        );
      },
    );
  }

  Widget buildVideoResolutionsPopupMenu() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final resolutions = ref.watch(availableVideoResolutionsProvider);

        if (resolutions == null) return const SizedBox.shrink();

        return PopupMenuButton<VideoResolution>(
          itemBuilder: (context) => resolutions.map((resolution) {
            final isSelected = ref.read(videoResolutionProvider) == resolution;
            return CustomPopupMenuItem<VideoResolution>(
              isSelected: isSelected,
              selectedBackgroundColor: Colors.green.shade400,
              onTap: () {
                ref.read(videoResolutionProvider.notifier).state = resolution;
                Navigator.pop(context);
              },
              child: Text(resolution.name),
            );
          }).toList(),
          child: ListTile(
            title: const Text("Resolutions"),
            subtitle: Text(ref.watch(videoResolutionProvider).name),
          ),
        );
      },
    );
  }
}

class PreviousButton extends ConsumerWidget {
  const PreviousButton({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeState = ref.watch(seriesControllerProvider);
    const icon = Icon(Icons.skip_previous);
    onPressed() => episodeState?.switchToPreviousEpisode();

    if (!(episodeState?.hasPrevious ?? false)) {
      return const SizedBox.shrink();
    }

    return MaterialCustomButton(
      onPressed: onPressed,
      icon: icon,
      iconColor: iconColor,
    );
  }
}

class NextButton extends ConsumerWidget {
  const NextButton({
    super.key,
    this.iconColor,
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeState = ref.watch(seriesControllerProvider);
    const icon = Icon(Icons.skip_next);
    onPressed() => episodeState?.switchToNextEpisode();

    if (!(episodeState?.hasNext ?? false)) {
      return const SizedBox.shrink();
    }

    return MaterialCustomButton(
      onPressed: onPressed,
      icon: icon,
      iconColor: iconColor,
    );
  }
}

Future<PlayerSubtitle?> _pickLocalSubtitle() async {
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['ass', 'ssa', 'srt', 'vtt'],
  );
  if (result == null) return null;
  final selectedFile = result.files.single;

  return PlayerSubtitle.fromLocalFile(selectedFile);
}
