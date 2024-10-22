import 'package:flutter/material.dart';

import '../../domain/entities/media_kind.dart';

class MediaKindSelector extends StatefulWidget {
  const MediaKindSelector({
    super.key,
    this.initialKind = MediaKind.movies,
    this.moviesIcon,
    this.seriesIcon,
    this.selectedDecoration,
    this.onSelected,
  });

  /// Initially selected Media Kind
  final MediaKind initialKind;

  /// The icon that is used for movies kind
  final Widget? moviesIcon;

  /// The icon that is used for series kind
  final Widget? seriesIcon;

  /// decorations around currently selected kind icon
  final Decoration? selectedDecoration;

  /// called when media kind changes
  final Function(MediaKind)? onSelected;

  @override
  State<MediaKindSelector> createState() => _MediaKindSelectorState();
}

class _MediaKindSelectorState extends State<MediaKindSelector> {
  late MediaKind mediaKind = widget.initialKind;

  @override
  Widget build(BuildContext context) {
    const kinds = MediaKind.values;
    final selectedColor = Theme.of(context).colorScheme.primary;
    final moviesIcon = widget.moviesIcon ?? const Icon(Icons.movie);
    final seriesIcon = widget.seriesIcon ?? const Icon(Icons.tv);

    return Row(
      children: kinds.map((kind) {
        final isSelected = mediaKind == kind;

        return Container(
          decoration: isSelected
              ? widget.selectedDecoration ??
                  BoxDecoration(
                    border: Border(bottom: BorderSide(color: selectedColor)),
                  )
              : null,
          child: IconButton(
            tooltip: kind.name,
            icon: kind == MediaKind.movies ? moviesIcon : seriesIcon,
            color: isSelected ? selectedColor : null,
            onPressed: () {
              widget.onSelected?.call(kind);
              setState(() {
                mediaKind = kind;
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
