import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const HomeCard({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Adding consistent bottom padding
      child: SizedBox(
        height: AppStyles.cardHeight,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16), // Adjusting margin
          color: AppStyles.cardBackgroundColor,
          elevation: 4.0,
          shape: AppStyles.cardShape,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Padding(
                padding: AppStyles.cardPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 45),
                    const SizedBox(width: 10),
                    Text(title, style: AppStyles.cardTitleStyle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
