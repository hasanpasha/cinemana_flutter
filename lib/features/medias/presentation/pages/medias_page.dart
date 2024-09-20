import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/media.dart';
import '../bloc/medias_bloc.dart';
import '../widgets/medias_list.dart';

class MediasPage extends StatefulWidget {
  const MediasPage({super.key});

  @override
  State<MediasPage> createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  String query = "";
  Function(int) fetcher = (_) {};
  final pagingController = PagingController<int, Media>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController
        .addStatusListener((status) => debugPrint(status.toString()));
  }

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
                  onPressed: () => showSearch(
                        context: context,
                        delegate:
                            CustomSearchDelegate(BlocProvider.of(context)),
                      ),
                  icon: const Icon(Icons.search))
            ],
          ),
          body: const Placeholder(),
        );
      }),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate(this._bloc) : stream = _bloc.getStateStream();

  final MediasBloc _bloc;
  final Stream<LoadedSearchMediasState> stream;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
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
    debugPrint("building search results for $query");

    return buildSearchMediasList(isSuggestions: false);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchMediasList(isSuggestions: true);
  }

  MediasList<LoadedSearchMediasState> buildSearchMediasList({
    bool isSuggestions = false,
  }) {
    return MediasList<LoadedSearchMediasState>(
      viewType: isSuggestions ? ViewType.list : ViewType.grid,
      notify: isSuggestions,
      mediasFetcher: (page) {
        debugPrint("searching for query: $query, page: $page");
        _bloc.add(GetMediasBySearch(query: query, page: page));
      },
      // mediasStream: _bloc.getStateStream(),
      mediasStream: stream,
    );
  }
}
