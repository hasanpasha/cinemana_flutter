import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

import '../../domain/entities/media_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/media.dart';
import '../bloc/medias_bloc.dart';
import '../widgets/media_poster.dart';

class MediasPage extends StatefulWidget {
  const MediasPage({super.key});

  @override
  State<MediasPage> createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediasBloc>(
      create: (context) => sl(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('cinemana'),
            actions: [
              IconButton(
                onPressed: () async {
                  final selectedMedia = await showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(BlocProvider.of(context)),
                  );
                  if (selectedMedia != null) {
                    if (context.mounted) {
                      context.pushNamed('mediaDetail', extra: selectedMedia);
                    }
                  }
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          body: const Placeholder(),
        );
      }),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate(this._bloc) {
    _bloc.getStateStream<SearchMediasState>().listen((state) {
      debugPrint("got result for paged list $state");
      if (state.status == LoadMediasStatus.success) {
        if (state.hasNext) {
          _controller.appendPage(state.medias, state.page + 1);
        } else {
          _controller.appendLastPage(state.medias);
        }
      } else if (state.status == LoadMediasStatus.failure) {
        _controller.error = "failure";
      }

      _tabIndex.addListener(() {
        _kind.value = MediaKind.values[_tabIndex.value];
      });
    });
  }

  final MediasBloc _bloc;
  final _controller = PagingController<int, Media>(firstPageKey: 1);
  Function(int)? _fetcher;

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
              labels: const ["", ""],
              isScroll: false,
              // begin: Alignment.topRight,
              icons: const [Icons.movie, Icons.tv],
              selectedLabelIndex: (idx) {
                _tabIndex.value = idx;
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
    if (query.isEmpty) {
      return const Center(
        child: Text("search something"),
      );
    }

    addToHistory(query);

    return ValueListenableBuilder(
      valueListenable: _kind,
      builder: (BuildContext context, MediaKind mediaKind, Widget? child) {
        if (_fetcher != null) {
          _controller.removePageRequestListener(_fetcher!);
        }
        _fetcher = (page) => _bloc
            .add(GetMediasBySearch(query: query, page: page, kind: mediaKind));
        _controller.addPageRequestListener(_fetcher!);
        _controller.refresh();
        return PagedGridView(
          physics: const BouncingScrollPhysics(),
          pagingController: _controller,
          builderDelegate: PagedChildBuilderDelegate<Media>(
            itemBuilder: (context, media, idx) => MediaPoster(
              media: media,
              showTitleText: true,
              // onPress: (media) => close(context, media),
              onPress: (media) =>
                  context.pushNamed('mediaDetail', extra: media),
            ),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width.toInt() ~/ 150,
            childAspectRatio: 0.66,
          ),
        );
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
