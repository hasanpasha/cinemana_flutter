import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'features/medias/presentation/pages/medias_page.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinemana',
      home: const MediasPage(),
      // home: SvgPicture.asset("assets/images/cinemana.svg"),
    );
  }
}
