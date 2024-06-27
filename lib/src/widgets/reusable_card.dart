import 'package:flutter/material.dart';
import 'package:lazarus_job_tracker/src/app_styles.dart';

class ReusableCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? iconSize;

  const ReusableCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.elevation,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        height: AppStyles.cardHeight,
        child: Card(
          color: backgroundColor ?? AppStyles.cardBackgroundColor,
          elevation: elevation ?? AppStyles.cardElevation,
          shape: AppStyles.cardShape,
          child: Center(
            child: ListTile(
              contentPadding: AppStyles.cardContentPadding,
              leading: Icon(icon, color: Colors.white, size: iconSize ?? AppStyles.cardIconSize),
              title: Text(title, style: titleStyle ?? AppStyles.cardTitleStyle),
              subtitle: child ?? Text(subtitle, style: subtitleStyle ?? AppStyles.cardSubtitleStyle),
              onTap: onTap,
              onLongPress: onLongPress,
            ),
          ),
        ),
      ),
    );
  }
}
