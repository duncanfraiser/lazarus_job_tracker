import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String errorMessage;

  const ErrorView({required this.title, required this.errorMessage, super.key});

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
      body: Center(child: Text('Error: $errorMessage')),
    );
  }
}
