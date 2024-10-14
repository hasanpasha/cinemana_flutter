import 'package:cinemana/features/medias/presentation/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class BlocShimmerLoading<B extends StateStreamable<S>, S, X extends S>
    extends StatelessWidget {
  const BlocShimmerLoading({
    super.key,
    required this.onLoaded,
    this.buildWhen,
    this.placeholder,
    this.minLoadingWidth,
    this.minLoadingHeight,
  });

  static final log = Logger('BlocShimmerLoading');

  final Widget Function(X) onLoaded;
  final bool Function(S, S)? buildWhen;
  final Widget? placeholder;
  final double? minLoadingWidth;
  final double? minLoadingHeight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (BuildContext context, S state) {
        log.info("new bloc state: $state");

        late final Widget child;
        if (state is X) {
          child = onLoaded(state);
        } else {
          child = buildLoadingPlaceholder();
        }

        // return child;
        return ShimmerLoading(
          isLoading: state is! X,
          child: child,
        );
      },
    );
  }

  Widget buildLoadingPlaceholder() {
    final child = placeholder ??
        SizedBox(
          width: minLoadingWidth ?? 0,
          height: minLoadingHeight ?? 0,
        );

    return Container(
      color: Colors.black,
      child: child,
    );
  }
}
