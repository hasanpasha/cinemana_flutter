import 'package:cinemana/features/medias/domain/entities/media_kind.dart';
import 'package:flutter/material.dart';

class MediaSearchBar extends StatefulWidget {
  const MediaSearchBar({
    super.key,
    required this.onSubmitted,
    required this.onClear,
    this.showSearchInputField = false,
    // this.defaultQuery = "",
    // this.defaultMediaKind,
  });

  final Function(String, MediaKind?) onSubmitted;
  final Function() onClear;
  final bool showSearchInputField;
  // final String defaultQuery;
  // final MediaKind? defaultMediaKind;

  @override
  State<MediaSearchBar> createState() => _MediaSearchBarState();
}

class _MediaSearchBarState extends State<MediaSearchBar> {
  final textFieldController = TextEditingController();
  late bool showSearchInputField;
  String query = "";
  MediaKind? mediaKind;

  @override
  void initState() {
    showSearchInputField = widget.showSearchInputField;
    // query = widget.defaultQuery;
    // mediaKind = widget.defaultMediaKind;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !showSearchInputField
        ? IconButton(
            onPressed: () {
              setState(() {
                showSearchInputField = true;
              });
            },
            icon: const Icon(Icons.search),
          )
        : SearchBar(
            hintText: 'Search something',
            // onEditingComplete: () => widget.onSubmitted(query, mediaKind),
            onChanged: (text) => query = text,
            onSubmitted: (text) => widget.onSubmitted(text, mediaKind),
            controller: textFieldController,
            leading: SizedBox(
              width: 100,
              child: DropdownButton<MediaKind>(
                isExpanded: true,
                value: mediaKind,
                items: MediaKind.values
                    .map(
                      (kind) => DropdownMenuItem<MediaKind>(
                        value: kind,
                        child: Text(kind.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (kind) {
                  setState(() {
                    mediaKind = kind;
                  });
                  if (query.isNotEmpty) {
                    widget.onSubmitted(query, mediaKind);
                  }
                },
              ),
            ),
            trailing: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],

            // decoration: InputDecoration(
            //   label: const Text('search something'),
            //   prefixIcon: IconButton(
            //     onPressed: () => widget.onSubmitted(query, mediaKind),
            //     icon: const Icon(Icons.search),
            //   ),
            //   suffixIcon: IconButton(
            //     onPressed: () {
            //       textFieldController.clear();
            //       setState(() {
            //         showSearchInputField = false;
            //       });
            //       widget.onClear();
            //     },
            //     icon: const Icon(Icons.clear),
            //   ),
            // ),
          );
  }
}
