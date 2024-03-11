import 'package:flutter/material.dart';

import 'alert/alert.dart';
import 'alert/alert_messenger.dart';

void main() => runApp(const AlertPriorityApp());

class AlertPriorityApp extends StatelessWidget {
  const AlertPriorityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priority',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(size: 16.0, color: Colors.white),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(110, 40)),
          ),
        ),
      ),
      home: AlertMessenger(
        child: Builder(
          builder: (context) {
            final showAlert = AlertMessenger.of(context).showAlert;
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const Text('Alerts'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedBuilder(
                          animation:
                              AlertMessenger.of(context).lastAlertDropped,
                          builder: (context, _) {
                            return Text(
                              AlertMessenger.of(context)
                                      .lastAlertDropped
                                      .value
                                      ?.message ??
                                  '<Adicione o texto do alerta de prioridade aqui>',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16.0,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Button(
                                  label: 'Error',
                                  icon: Icons.error,
                                  backgroundColor: Colors.red,
                                  onPressed: () => showAlert(
                                    alert: const Alert.error(
                                      message:
                                          'Oops, ocorreu um erro. Pedimos desculpas.',
                                    ),
                                  ),
                                ),
                                Button(
                                  label: 'Warning',
                                  icon: Icons.warning_outlined,
                                  backgroundColor: Colors.amber,
                                  onPressed: () => showAlert(
                                    alert: const Alert.warning(
                                      message: 'Atenção! Você foi avisado.',
                                    ),
                                  ),
                                ),
                                Button(
                                  label: 'Info',
                                  icon: Icons.info_outline,
                                  backgroundColor: Colors.lightGreen,
                                  onPressed: () => showAlert(
                                    alert: const Alert.info(
                                      message:
                                          'Este é um aplicativo escrito em Flutter.',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: ElevatedButton(
                                onPressed: AlertMessenger.of(context).hideAlert,
                                child: const Text('Hide alert'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final String label;
  const Button({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          const SizedBox(width: 4.0),
          Text(label),
        ],
      ),
    );
  }
}
