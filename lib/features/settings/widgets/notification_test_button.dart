import 'package:flutter/material.dart';
import 'package:escape/services/notification_service.dart';
import 'package:escape/theme/app_constants.dart';

class NotificationTestButton extends StatelessWidget {
  const NotificationTestButton({super.key});

  Future<void> _testNotification(BuildContext context) async {
    try {
      final notificationService = NotificationService();
      await notificationService.showTestNotification();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: AppConstants.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send notification: $e'),
            backgroundColor: AppConstants.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_active),
        title: const Text('Test Notifications'),
        subtitle: const Text('Send a test notification to verify setup'),
        trailing: ElevatedButton(
          onPressed: () => _testNotification(context),
          child: const Text('Test'),
        ),
      ),
    );
  }
}
