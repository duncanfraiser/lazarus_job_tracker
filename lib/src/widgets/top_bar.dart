import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String companyName;
  final String userName;
  final List<Widget>? actions;

  const TopBar({
    required this.companyName,
    required this.userName,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              companyName,
              style: AppStyles.appBarCompanyStyle.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              userName,
              style: AppStyles.appBarUserNameStyle.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      backgroundColor: AppStyles.backgroundColor,
      flexibleSpace: Container(
        decoration: AppStyles.appBarDecoration,
      ),
      iconTheme: AppStyles.iconTheme,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);  // Adjust height as needed
}
