import '../../domain/entities/media.dart';
import '../bloc/medias_bloc.dart';
import '../widgets/medias_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchMediasPage extends StatefulWidget {
  const SearchMediasPage({super.key});

  @override
  State<SearchMediasPage> createState() => _SearchMediasPageState();
}

class _SearchMediasPageState extends State<SearchMediasPage> {
  String query = "";
  final queryInputController = TextEditingController();
  final pagingController = PagingController<int, Media>(firstPageKey: 1);

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: queryInputController,
          onChanged: (value) {
            query = value;
          },
          onSubmitted: (value) {
            pagingController.refresh();
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body: query.isEmpty
          ? const Center(
              child: Text('search something'),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: MediasList<LoadedSearchMediasState>(
                    viewType: ViewType.grid,
                    pagingController: pagingController,
                    mediasFetcher: (page) {
                      debugPrint("searching for $query page: $page");
                      BlocProvider.of<MediasBloc>(context).add(
                        GetMediasBySearch(query: query, page: page),
                      );
                    },
                    mediasStream:
                        BlocProvider.of<MediasBloc>(context).getStateStream(),
                  ),
                ),
              ],
            ),
    );
  }
}
