import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'alert.dart';
import 'alert_priority_enum.dart';

class AlertMessenger extends StatefulWidget {
  const AlertMessenger({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AlertMessenger> createState() => AlertMessengerState();

  static AlertMessengerState of(BuildContext context) {
    try {
      final scope = _AlertMessengerScope.of(context);
      return scope.state;
    } catch (error) {
      throw FlutterError.fromParts(
        [
          ErrorSummary('No AlertMessenger was found in the Element tree'),
          ErrorDescription(
              'AlertMessenger is required in order to show and hide alerts.'),
          ...context.describeMissingAncestor(
            expectedAncestorType: AlertMessenger,
          ),
        ],
      );
    }
  }
}

class AlertMessengerState extends State<AlertMessenger> {
  final PriorityQueue<Alert> _priorityQueue = PriorityQueue<Alert>(
    (a, b) => b.priority.value.compareTo(a.priority.value),
  );

  ValueNotifier<Alert?> lastAlertDropped = ValueNotifier(null);
  Alert? alertTop;
  List<Alert> alertBottom = [];

  void showAlert({required Alert alert}) {
    final lastAlert = _priorityQueue.isNotEmpty ? _priorityQueue.first : null;
    _priorityQueue.add(alert);
    if (lastAlert == null) {
      setState(() {
        alertBottom = [];
        alertTop = alert;
      });
    } else if (lastAlert != _priorityQueue.first) {
      setState(() {
        alertBottom = _priorityQueue.toList().skip(1).toList();
        alertTop = alert;
      });
    }
    _attLastAlertDropped();
    setState(() {});
  }

  void hideAlert() {
    if (_priorityQueue.isNotEmpty) {
      alertTop = _priorityQueue.first;
      _priorityQueue.removeFirst();
      alertBottom = _priorityQueue.toList();
      _attLastAlertDropped();
      setState(() {});
    }
  }

  void _attLastAlertDropped() {
    lastAlertDropped.value =
        _priorityQueue.isNotEmpty ? _priorityQueue.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimationCardWidget(
      lenght: _priorityQueue.length,
      alertTop: alertTop,
      alertBottom: alertBottom,
      child: _AlertMessengerScope(
        state: this,
        child: widget.child,
      ),
    );
  }
}

class AnimationCardWidget extends StatefulWidget {
  final int lenght;
  final Alert? alertTop;
  final List<Alert> alertBottom;
  final Widget child;
  const AnimationCardWidget(
      {Key? key,
      required this.lenght,
      required this.child,
      this.alertTop,
      required this.alertBottom})
      : super(key: key);

  @override
  State<AnimationCardWidget> createState() => _AnimationCardWidgetState();
}

class _AnimationCardWidgetState extends State<AnimationCardWidget>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  double get alertHeight => MediaQuery.of(context).padding.top + kAlertHeight;

  void onDidUpdateWidget(covariant AnimationCardWidget oldWidget) async {
    if (oldWidget.alertBottom == widget.alertBottom &&
        oldWidget.alertTop == widget.alertTop &&
        widget.lenght >= oldWidget.lenght) {
      return;
    }
    if (widget.lenght > oldWidget.lenght) {
      await controller.forward(from: 0.0);
    } else if (widget.lenght < oldWidget.lenght) {
      await controller.reverse(from: 1.0);
    }
  }

  @override
  void didUpdateWidget(covariant AnimationCardWidget oldWidget) {
    onDidUpdateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    animation = Tween<double>(begin: -alertHeight, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusbarHeight = MediaQuery.of(context).padding.top;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final position = animation.value + statusbarHeight;
        return Stack(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            Positioned.fill(
              top: position <= statusbarHeight ? 0 : position - statusbarHeight,
              child: widget.child,
            ),
            ...widget.alertBottom.reversed.map((alert) => alert),
            Positioned(
              top: animation.value,
              left: 0,
              right: 0,
              child: widget.alertTop ?? const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _AlertMessengerScope extends InheritedWidget {
  const _AlertMessengerScope({
    required this.state,
    required super.child,
  });

  final AlertMessengerState state;

  @override
  bool updateShouldNotify(_AlertMessengerScope oldWidget) =>
      state != oldWidget.state;

  static _AlertMessengerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AlertMessengerScope>();
  }

  static _AlertMessengerScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No _AlertMessengerScope found in context');
    return scope!;
  }
}
