import 'dart:collection';

import 'package:cinemana/features/medias/domain/entities/entities.dart';
import 'package:flutter/material.dart';

double width(BuildContext context) => MediaQuery.of(context).size.width;

extension ContextExtension on BuildContext {
  bool get isPhone => width(this) < 600;
  bool get isTablet => width(this) > 600 && width(this) < 1200;
  bool get isDesktop => width(this) > 1200;
}
