import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/providers/providers.dart';

class SeriesWidget extends ConsumerWidget {
  const SeriesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonsValue = ref.watch(allSeasonsProvider);
    final seasons = seasonsValue.valueOrNull;
    final seriesState = ref.watch(seriesControllerProvider);

    if (seasons == null) return const SizedBox.shrink();

    final currentSeasonNumber = seriesState?.season.number;
    final currentEpisodeNumber = seriesState?.episode.number;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            color: Theme.of(context).colorScheme.primaryFixedDim,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Season:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "$currentSeasonNumber",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 12),
                Text(
                  "Episode:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "$currentEpisodeNumber",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: seasons.map(
                (season) {
                  return ExpansionTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Text(season.episodes.length.toString()),
                    ),
                    title: Text("Season ${season.number}"),
                    children: season.episodes.map((episode) {
                      final isSelected = seriesState?.episode == episode;

                      return ListTile(
                        enabled: !isSelected,
                        selected: isSelected,
                        selectedTileColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        leading: IconButton(
                          onPressed: () {
                            seriesState?.episode = episode;
                            // onEpisodePlay?.call(episode);
                          },
                          icon: const Icon(Icons.play_arrow_sharp),
                        ),
                        title: Text("Episode ${episode.number}"),
                        onTap: () {
                          // onEpisodeSelect?.call(episode);
                        },
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                        ),
                      );
                    }).toList(),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
