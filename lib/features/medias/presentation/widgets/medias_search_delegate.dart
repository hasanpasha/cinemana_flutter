import 'dart:async';

import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias/medias_bloc.dart';
import 'package:cinemana/features/medias/presentation/widgets/media_poster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logging/logging.dart';

class MediasSearchDelegate extends SearchDelegate {
  final log = Logger('MediasSearchDelegate');

  MediasSearchDelegate();

  final _tabIndex = ValueNotifier<int>(0);
  final _kind = ValueNotifier<MediaKind>(MediaKind.movies);
  final _searchHistory = ValueNotifier<Set<String>>({});

  final Set<String> searchHistory = {};

  void addToHistory(String query) {
    if (query.isNotEmpty) {
      final newValue = <String>{};
      newValue.addAll(_searchHistory.value);
      newValue.add(query);
      _searchHistory.value = newValue;
    }
  }

  void removeFromHistory(String query) {
    final newValue = <String>{};
    newValue.addAll(_searchHistory.value);
    newValue.remove(query);
    _searchHistory.value = newValue;
  }

  void clearHistory() {
    _searchHistory.value = {};
  }

  List<String> filterHistory(String query) {
    return _searchHistory.value
        .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      IconButton(
        onPressed: () => showResults(context),
        icon: const Icon(Icons.search),
      ),
      ValueListenableBuilder(
        valueListenable: _tabIndex,
        builder: (BuildContext context, int value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlutterToggleTab(
              iconSize: 20,
              width: 20,
              height: 40,
              // labels: MediaKind.values.map((e) => e.name).toList(),
              labels: const ["movies", "series"],
              isScroll: false,
              // begin: Alignment.topRight,
              icons: const [Icons.movie, Icons.tv],
              selectedLabelIndex: (idx) {
                _tabIndex.value = idx;
                _kind.value = MediaKind.values[idx];
              },
              selectedIndex: value,
              marginSelected: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              unSelectedTextStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      addToHistory(query);
    }

    return ValueListenableBuilder(
      valueListenable: _kind,
      builder: (BuildContext context, MediaKind mediaKind, Widget? child) {
        log.info("building search for $mediaKind");
        return SearchListView(query: query, mediaKind: mediaKind);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _searchHistory,
      builder: (BuildContext context, Set<String> value, Widget? child) {
        final suggestions = filterHistory(query);
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            final current = suggestions[index];
            return ListTile(
              onTap: () {
                query = current;
                showResults(context);
              },
              title: Text(current),
              trailing: IconButton(
                onPressed: () {
                  removeFromHistory(current);
                },
                icon: const Icon(Icons.remove),
              ),
            );
          },
        );
      },
    );
  }
}

class SearchListView extends StatefulWidget {
  const SearchListView({
    super.key,
    required this.query,
    required this.mediaKind,
  });

  final MediaKind mediaKind;
  final String query;

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  final log = Logger('_SearchListViewState');

  final controller = PagingController<int, Media>(firstPageKey: 1);
  late final bloc = BlocProvider.of<MediasBloc>(context);
  late final StreamSubscription<SearchMediasState> subscription;
  late Function(SearchMediasState) mediasListener = (state) {
    log.fine("got result for paged list $state");
    if (state.status == LoadMediasStatus.success) {
      if (state.hasNext) {
        controller.appendPage(state.medias, state.page + 1);
      } else {
        controller.appendLastPage(state.medias);
      }
    } else if (state.status == LoadMediasStatus.failure) {
      controller.error = "failure";
    }
  };
  late Function(int) fetcher = (int page) => bloc.add(GetMediasBySearch(
        query: query,
        page: page,
        kind: mediaKind,
      ));

  MediaKind get mediaKind => widget.mediaKind;
  String get query => widget.query;

  @override
  void initState() {
    log.info("initializing state");
    subscription =
        bloc.getStateStream<SearchMediasState>().listen(mediasListener);
    controller.addPageRequestListener(fetcher);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    log.info(
        "new update: mediaKind: old=${oldWidget.mediaKind}, new=${widget.mediaKind}");
    if (oldWidget.query != widget.query ||
        oldWidget.mediaKind != widget.mediaKind) {
      // subscription.cancel();
      controller.removePageRequestListener(fetcher);
      fetcher = (page) => bloc.add(GetMediasBySearch(
            query: query,
            page: page,
            kind: mediaKind,
          ));
      controller.addPageRequestListener(fetcher);
      controller.refresh();
    }
  }

  @override
  void dispose() {
    log.info("dispose");
    subscription.cancel();
    controller.removePageRequestListener(fetcher);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("search something"),
      );
    }

    // controller.refresh();
    return PagedGridView(
      physics: const BouncingScrollPhysics(),
      pagingController: controller,
      builderDelegate: PagedChildBuilderDelegate<Media>(
        itemBuilder: (context, media, idx) => MediaPoster(
          media: media,
          showTitleText: true,
          onPress: (media) => context.pushNamed('mediaDetail', extra: media),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width.toInt() ~/ 150,
        childAspectRatio: 0.66,
      ),
    );
  }
}
