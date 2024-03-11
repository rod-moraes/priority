import 'package:flutter/material.dart';

const kAlertHeight = 80.0;

enum AlertPriority {
  error(2, Colors.red, Icons.error),
  warning(1, Colors.amber, Icons.warning),
  info(0, Colors.green, Icons.info);

  const AlertPriority(this.value, this.color, this.icon);
  final int value;
  final Color color;
  final IconData icon;
}
