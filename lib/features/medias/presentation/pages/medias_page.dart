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
          body: FloatingSearchAppBar(
            // bottom: const Text("hello"),
            title: const Text(
              "cinemana",
            ),
            // onQueryChanged: (query) => query = query,
            onSubmitted: (query) {
              setState(
                () => fetcher = (page) {
                  debugPrint("search for $query");
                  BlocProvider.of<MediasBloc>(context).add(
                    GetMediasBySearch(query: query, page: page),
                  );
                },
              );
            },
            body: Material(
              color: Colors.white,
              elevation: 4.0,
              child: MediasList<LoadedSearchMediasState>(
                viewType: ViewType.grid,
                pagingController: pagingController,
                mediasFetcher: fetcher,
                mediasStream:
                    BlocProvider.of<MediasBloc>(context).getStateStream(),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 200,
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: MediasList<LoadedSearchMediasState>(
                viewType: ViewType.slider,
                // pagingController: (page) {},
                mediasFetcher: (page) =>
                    BlocProvider.of<MediasBloc>(context).add(
                  GetMediasBySearch(query: "the day", page: page),
                ),
                mediasStream:
                    BlocProvider.of<MediasBloc>(context).getStateStream(),
              ),
            ),
          ),
        );
      },
    );
  }
}
