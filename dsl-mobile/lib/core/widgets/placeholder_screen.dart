import 'package:flutter/material.dart';

import 'state_views.dart';

/// Stand-in for a tab whose feature slice hasn't been built yet. Each slice
/// replaces its placeholder (docs/mobile/mobile-roadmap.md).
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    required this.message,
    super.key,
    this.actions = const [],
  });

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: EmptyView(title: 'Coming soon', message: message),
          ),
          ...actions,
        ],
      ),
    );
  }
}
