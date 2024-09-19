import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/medias_bloc.dart';
import '../widgets/search_widget.dart';
import 'search_medias_page.dart';

class MediasPage extends StatefulWidget {
  const MediasPage({super.key});

  @override
  State<MediasPage> createState() => _MediasPageState();
}

class _MediasPageState extends State<MediasPage> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MediasBloc>(
      create: (_) => sl<MediasBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cinemana',
          ),
          centerTitle: true,
        ),
        floatingActionButton: Builder(
          builder: (context) => IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<MediasBloc>(),
                  child: const SearchMediasPage(),
                ),
              ),
            ),
            icon: const Icon(Icons.search),
          ),
        ),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SearchWidget(),
            SliverList.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
