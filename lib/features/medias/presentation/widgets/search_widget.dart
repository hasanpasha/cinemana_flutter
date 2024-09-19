import 'dart:collection';

import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias_bloc.dart';
import 'package:cinemana/features/medias/presentation/widgets/medias_list.dart';
import 'package:cinemana/features/medias/presentation/widgets/media_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    this.height = 250,
  });

  final double height;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final pagingController = PagingController<int, Media>(firstPageKey: 1);
  bool showResultsList = false;
  String query = "";
  MediaKind? mediaKind;
  late MediasBloc bloc;
  Function(int) mediasFetcher = (page) {
    debugPrint("BLANK SEARCH");
  };

  @override
  void initState() {
    bloc = BlocProvider.of<MediasBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: MediaSearchBar(
        onSubmitted: _search,
        onClear: () => setState(() {
          showResultsList = false;
        }),
        showSearchInputField: showResultsList,
        // defaultMediaKind: mediaKind,
      ),
      primary: true,
      centerTitle: true,
      snap: true,
      floating: true,
      backgroundColor: Colors.transparent,
      bottom: showResultsList
          ? PreferredSize(
              preferredSize: Size(
                double.maxFinite,
                widget.height,
              ),
              child: SizedBox(
                height: widget.height,
                child: MediasList<LoadedSearchMediasState>(
                  viewType: ViewType.slider,
                  pagingController: pagingController,
                  mediasFetcher: mediasFetcher,
                  mediasStream:
                      BlocProvider.of<MediasBloc>(context).getStateStream(),
                ),
              ),
            )
          : null,
    );
  }

  void _search(String query, MediaKind? mediaKind) {
    setState(() {
      mediasFetcher = (page) {
        debugPrint("searching for $query page: $page, kind: $mediaKind");
        bloc.add(
          GetMediasBySearch(query: query, page: page, kind: mediaKind),
        );
      };
    });
    if (!showResultsList) {
      setState(() {
        showResultsList = true;
      });
    }
    debugPrint("submit search $query");
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
