import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme.dart';
import '../../../data/models/alert_model.dart';
import '../../../presentation/blocs/notifications/notification_bloc.dart';
import '../../../presentation/blocs/notifications/notification_event.dart';
import '../../../presentation/blocs/notifications/notification_state.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadAlerts());
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppTheme.errorColor;
      case AlertSeverity.warning:
        return const Color(0xFFFFA726);
      case AlertSeverity.info:
        return const Color(0xFF1E88E5);
    }
  }

  IconData _getSeverityIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error;
      case AlertSeverity.warning:
        return Icons.warning;
      case AlertSeverity.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Alerts'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }

          if (state is NotificationLoaded) {
            if (state.alerts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 64, color: AppTheme.accentColor),
                    SizedBox(height: 16),
                    Text('No active alerts'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.alerts.length,
              itemBuilder: (context, index) {
                final alert = state.alerts[index];
                final color = _getSeverityColor(alert.severity);

                return GestureDetector(
                  onTap: () => context
                      .read<NotificationBloc>()
                      .add(MarkAlertAsRead(alert.id)),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Severity icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getSeverityIcon(alert.severity),
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Alert content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alert.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: alert.isRead
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (!alert.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  alert.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Affected line + subscribe button
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        alert.affectedLine,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      backgroundColor: color.withValues(alpha: 0.1),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        final isSubscribed = state
                                            .subscribedLines
                                            .contains(alert.affectedLine);
                                        if (isSubscribed) {
                                          context.read<NotificationBloc>().add(
                                            UnsubscribeFromLine(
                                                alert.affectedLine),
                                          );
                                        } else {
                                          context.read<NotificationBloc>().add(
                                            SubscribeToLine(
                                                alert.affectedLine),
                                          );
                                        }
                                      },
                                      child: Text(
                                        state.subscribedLines
                                            .contains(alert.affectedLine)
                                            ? 'Unsubscribe'
                                            : 'Subscribe',
                                        style: TextStyle(color: color),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}