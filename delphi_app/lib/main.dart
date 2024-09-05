import 'package:flutter/material.dart';
import 'skeleton_page/skeleton_page.dart';

void main() {
  runApp(const DelphiApp());
}

class DelphiApp extends StatelessWidget {
  const DelphiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delphi App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SkeletonPage(),
    );
  }
}
