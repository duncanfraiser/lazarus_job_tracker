import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class NoDataView extends StatelessWidget {
  final String title;
  final String message;

  const NoDataView({required this.title, required this.message, super.key});

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
      body: Center(child: Text(message)),
    );
  }
}
