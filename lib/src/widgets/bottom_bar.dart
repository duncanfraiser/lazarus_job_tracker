import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onHomePressed;

  const BottomBar({required this.onHomePressed, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: AppStyles.bottomAppBarTheme.shape,
      notchMargin: 8.0,
      color: AppStyles.bottomAppBarTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            iconSize: AppStyles.bottomIconTheme.size!,
            color: AppStyles.bottomIconTheme.color,
            onPressed: onHomePressed,
          ),
        ],
      ),
    );
  }
}
