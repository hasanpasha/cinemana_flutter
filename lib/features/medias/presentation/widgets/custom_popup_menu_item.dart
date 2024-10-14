import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  const CustomPopupMenuItem({
    super.onTap,
    super.key,
    super.value,
    super.enabled,
    super.child,
    this.isSelected = false,
    this.selectedBackgroundColor = Colors.green,
    this.selectedBorder,
  });

  final bool isSelected;
  final Color selectedBackgroundColor;
  final BoxBorder? selectedBorder;

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() =>
      _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isSelected
          ? BoxDecoration(
              border: widget.selectedBorder,
              color: widget.selectedBackgroundColor,
            )
          : null,
      // color: widget.isSelected ? widget.selectedColor : null,
      child: super.build(context),
    );
  }
}
