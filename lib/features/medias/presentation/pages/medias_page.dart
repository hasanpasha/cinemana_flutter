import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/medias_search_delegate.dart';

class MediasPage extends StatefulWidget {
  const MediasPage({super.key});

  @override
  State<MediasPage> createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('cinemana'),
          actions: [
            IconButton(
              onPressed: () async {
                // final selectedMedia = await
                showSearch(
                  context: context,
                  delegate: MediasSearchDelegate(),
                );
                // if (selectedMedia != null) {
                //   if (context.mounted) {
                //     context.pushNamed('mediaDetail', extra: selectedMedia);
                //   }
                // }
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: const Placeholder(),
      );
    });
  }
}
