import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';

class DescriptionText extends StatefulWidget {
  const DescriptionText(
    String? description, {
    super.key,
  }) : description = description ?? "N/A";

  final String description;

  @override
  State<DescriptionText> createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  String get description => widget.description;

  @override
  Widget build(BuildContext context) {
    final isCollapsedValue = ValueNotifier<bool>(false);

    return InkWell(
      onTap: () {
        isCollapsedValue.value = !isCollapsedValue.value;
        // isCollapsed
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: description));
      },
      child: ValueListenableBuilder(
        valueListenable: isCollapsedValue,
        builder: (BuildContext context, bool value, Widget? child) {
          return Container(
            color: Colors.black.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: ReadMoreText(
                widget.description,
                isCollapsed: isCollapsedValue,
                textAlign: TextAlign.start,
                trimLines: 2,
                trimMode: TrimMode.Line,
                // style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
