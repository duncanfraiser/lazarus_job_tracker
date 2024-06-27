import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class LoadingView extends StatelessWidget {
  final String title;

  const LoadingView({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppStyles.backgroundColor,
        flexibleSpace: Container(
          decoration: AppStyles.appBarDecoration,
        ),
        iconTheme: AppStyles.iconTheme,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
