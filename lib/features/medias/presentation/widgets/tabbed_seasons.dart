import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:logging/logging.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';

import '../../domain/entities/entities.dart';
import 'models/series_state.dart';

class TabbedSeasonsController extends ChangeNotifier {
  Episode? currentEpisode;
  int currentSeasonIndex = 0;

  void setCurrentEpisode(Episode episode) {
    currentEpisode = episode;
    notifyListeners();
  }

  void setCurrentSeasonIndex(int index) {
    currentSeasonIndex = index;
    notifyListeners();
  }
}

class TabbedSeasons extends StatefulWidget {
  const TabbedSeasons({
    super.key,
    required this.seasons,
    required this.controller,
    this.onEpisodeSelect,
    this.onEpisodePlay,
    // this.selectedEpisode,
  });

  final List<Season> seasons;
  final TabbedSeasonsController controller;
  // final Episode? selectedEpisode;
  final Function(Episode)? onEpisodeSelect;
  final Function(Episode)? onEpisodePlay;

  @override
  State<TabbedSeasons> createState() => _TabbedSeasonsState();
}

class _TabbedSeasonsState extends State<TabbedSeasons>
    with SingleTickerProviderStateMixin {
  static final logger = Logger('_TabbedSeasonsState');

  // late final TabController tabsController;

  TabbedSeasonsController get controller => widget.controller;

  List<Season> get seasons => widget.seasons;

  Episode? selectedEpisode;

  void controllerListener() => () {
        if (controller.currentEpisode != null) {
          setState(() => selectedEpisode = controller.currentEpisode);
        }
      };

  @override
  void initState() {
    controller.addListener(controllerListener);

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(controllerListener);
    // tabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final tabs = seasons
    //     .map((season) => Tab(
    //           // text: "season ${season.number}",
    //           icon: Row(
    //             children: [
    //               Text("season ${season.number}"),
    //               const SizedBox(width: 10),
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: Theme.of(context).colorScheme.primaryContainer,
    //                   shape: BoxShape.circle,
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(4),
    //                   child: Text(
    //                     textAlign: TextAlign.center,
    //                     season.episodes.length.toString(),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ))
    //     .toList();
    // final tabViews = seasons.map(
    //   (season) {
    //     final episodes = season.episodes;
    //     return ListView.builder(
    //       scrollDirection: Axis.vertical,
    //       itemCount: episodes.length,
    //       itemBuilder: (context, idx) {
    //         final episode = episodes[idx];
    //         final isSelected = selectedEpisode == episode;

    //         return ListTile(
    //           selected: isSelected,
    //           // selectedColor: Colors.amber,
    //           selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    //           leading: IconButton(
    //             onPressed: () {
    //               widget.onEpisodePlay?.call(episode);
    //               setState(() => selectedEpisode = episode);
    //             },
    //             icon: const Icon(Icons.play_arrow_sharp),
    //           ),
    //           title: Text("episode ${episode.number}"),
    //           onTap: () {
    //             setState(() => selectedEpisode = episode);
    //             widget.onEpisodeSelect?.call(episode);
    //           },
    //           trailing: IconButton(
    //             onPressed: () {},
    //             icon: const Icon(Icons.download),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // ).toList();
    // return Column(
    //   children: [
    //     TabBar(
    //       controller: tabsController,
    //       isScrollable: true,
    //       tabs: tabs,
    //     ),
    //     Expanded(
    //       child: TabBarView(
    //         controller: tabsController,
    //         children: tabViews,
    //       ),
    //     ),
    //   ],
    // );
    // final List<SeasonEpisodePair> episodes =
    //     seasons.mapToSeasonEpisodePairList();
    // return Card(
    //   child: GroupedListView(
    //     elements: episodes,
    //     groupBy: (element) => element.$1,
    //     groupComparator: (value1, value2) =>
    //         value1.number.compareTo(value2.number),
    //     itemComparator: (element1, element2) =>
    //         element1.$2.number.compareTo(element2.$2.number),
    //     floatingHeader: true,
    //     useStickyGroupSeparators: true,
    //     stickyHeaderBackgroundColor: Colors.black12,
    //     groupStickyHeaderBuilder: (element) {
    //       return Center(
    //         child: Card(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text(
    //               "season ${element.$1.number}",
    //               style: Theme.of(context).textTheme.headlineMedium,
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     groupHeaderBuilder: (element) {
    //       return Center(
    //         child: Card(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text(
    //               "season ${element.$1.number}",
    //               style: Theme.of(context).textTheme.headlineMedium,
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     itemBuilder: (context, element) {
    //       final (season, episode) = element;
    //       final isSelected = selectedEpisode == episode;

    //       return ListTile(
    //         selected: isSelected,
    //         // selectedColor: Colors.amber,
    //         selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    //         leading: IconButton(
    //           onPressed: () {
    //             widget.onEpisodePlay?.call(episode);
    //             setState(() => selectedEpisode = episode);
    //           },
    //           icon: const Icon(Icons.play_arrow_sharp),
    //         ),
    //         title: Text("episode ${episode.number}"),
    //         onTap: () {
    //           setState(() => selectedEpisode = episode);
    //           widget.onEpisodeSelect?.call(episode);
    //         },
    //         trailing: IconButton(
    //           onPressed: () {},
    //           icon: const Icon(Icons.download),
    //         ),
    //       );
    //     },
    //   ),
    // );
    return ListView.builder(
      itemCount: seasons.length,
      itemBuilder: (context, idx) {
        final season = seasons[idx];
        return ExpansionTile(
          title: Text("Season ${season.number}"),
          children: season.episodes.map((episode) {
            final isSelected = selectedEpisode == episode;

            return ListTile(
              enabled: !isSelected,
              selected: isSelected,
              // selectedColor: Colors.amber,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
              leading: IconButton(
                onPressed: () {
                  // setState(() => selectedEpisode = episode);
                  controller.currentEpisode = episode;
                  widget.onEpisodePlay?.call(episode);
                },
                icon: const Icon(Icons.play_arrow_sharp),
              ),
              title: Text("Episode ${episode.number}"),
              onTap: () {
                // setState(() => selectedEpisode = episode);
                controller.currentEpisode = episode;
                widget.onEpisodeSelect?.call(episode);
              },
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
