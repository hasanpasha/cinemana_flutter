import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemana/features/medias/domain/entities/media.dart';
import 'package:cinemana/features/medias/presentation/bloc/medias_bloc.dart';
import 'package:cinemana/features/medias/presentation/widgets/media_poster.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum ViewType {
  list,
  slider,
  grid,
}

class MediasList<T extends MediasState> extends StatefulWidget {
  MediasList({
    super.key,
    required this.mediasFetcher,
    required this.mediasStream,
    ViewType? viewType,
    PagingController<int, Media>? pagingController,
  })  : pagingController =
            pagingController ?? PagingController(firstPageKey: 1),
        viewType = viewType ?? ViewType.slider {
    debugPrint("creating new MediasList");
  }

  final Function(int) mediasFetcher;
  final Stream<T> mediasStream;
  final PagingController<int, Media> pagingController;
  final ViewType viewType;

  @override
  State<MediasList> createState() => _MediasListState<T>();
}

class _MediasListState<T extends MediasState> extends State<MediasList> {
  late StreamSubscription<MediasState> streamSubscription;
  // final pagingController = PagingController<int, Media>(firstPageKey: 1);

  @override
  void initState() {
    debugPrint("SUBSCRIBING to medias state stream");
    streamSubscription = widget.mediasStream.listen((state) {
      if (state.status == LoadMediasStatus.success) {
        debugPrint(state.medias.toString());
        if (state.hasNext) {
          widget.pagingController.appendPage(state.medias, state.page + 1);
        } else {
          widget.pagingController.appendLastPage(state.medias);
        }
      } else if (state.status == LoadMediasStatus.failure) {
        widget.pagingController.error = "failure";
      }
    });
    widget.pagingController.addPageRequestListener(widget.mediasFetcher);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MediasList oldWidget) {
    // if (widget != oldWidget) {
    debugPrint("unsubscribe from medias state stream");
    // streamSubscription.cancel();
    // streamSubscription = widget.mediasStream.listen((state) {
    //   if (state.status == LoadMediasStatus.success) {
    //     debugPrint(state.medias.toString());
    //     if (state.hasNext) {
    //       widget.pagingController.appendPage(state.medias, state.page + 1);
    //     } else {
    //       widget.pagingController.appendLastPage(state.medias);
    //     }
    //   } else if (state.status == LoadMediasStatus.failure) {
    //     widget.pagingController.error = "failure";
    //   }
    // });
    oldWidget.pagingController
        .removePageRequestListener(oldWidget.mediasFetcher);
    widget.pagingController.addPageRequestListener(widget.mediasFetcher);

    widget.pagingController.refresh();
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    debugPrint("[DISPOSE] unsubscribe from medias state stream");
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building slider");
    return Center(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: switch (widget.viewType) {
          ViewType.list => PagedListView(
              scrollDirection: Axis.vertical,
              pagingController: widget.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Media>(
                itemBuilder: (context, media, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 200,
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.66,
                            child: CachedNetworkImage(
                              imageUrl: media.poster!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  "${media.title} (${media.year})",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Expanded(child: Text(media.year.toString()))
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "categories: ",
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Text(
                                            "category $index",
                                          ),
                                          itemCount: 7,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  Text(" * "),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ViewType.slider => PagedListView(
              scrollDirection: Axis.horizontal,
              pagingController: widget.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Media>(
                itemBuilder: (context, media, index) => MediaPoster(
                  showTitleText: true,
                  media: media,
                  onPress: (media) => debugPrint("selected $media"),
                ),
              ),
            ),
          ViewType.grid => PagedGridView(
              scrollDirection: Axis.vertical,
              pagingController: widget.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Media>(
                itemBuilder: (context, media, index) => MediaPoster(
                  showTitleText: true,
                  media: media,
                  onPress: (media) => debugPrint("selected $media"),
                ),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.66,
                crossAxisCount: 3,
              ),
            ),
        },
      ),
    );
  }
}
