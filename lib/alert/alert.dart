import 'package:flutter/material.dart';

import 'alert_priority_enum.dart';

class Alert extends StatelessWidget {
  const Alert({
    super.key,
    required this.message,
    required this.priority,
    this.backgroundColor,
    this.leading,
  });

  const Alert.error({
    super.key,
    required this.message,
  })  : priority = AlertPriority.error,
        backgroundColor = null,
        leading = null;

  const Alert.warning({
    super.key,
    required this.message,
  })  : priority = AlertPriority.warning,
        backgroundColor = null,
        leading = null;

  const Alert.info({
    super.key,
    required this.message,
  })  : priority = AlertPriority.info,
        backgroundColor = null,
        leading = null;

  final String message;
  final AlertPriority priority;
  final Widget? leading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final statusbarHeight = MediaQuery.of(context).padding.top;
    return Material(
      child: Ink(
        color: backgroundColor ?? priority.color,
        height: kAlertHeight + statusbarHeight,
        child: Column(
          children: [
            SizedBox(height: statusbarHeight),
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 28.0),
                  IconTheme(
                    data: const IconThemeData(
                      color: Colors.white,
                      size: 36,
                    ),
                    child: leading ?? Icon(priority.icon),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: Text(message),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 28.0),
          ],
        ),
      ),
    );
  }
}
