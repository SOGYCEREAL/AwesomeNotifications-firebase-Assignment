import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> showNoteCreatedNotification(String noteText) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'note_channel',
        title: 'Note Created',
        body: noteText.length > 50 ? '${noteText.substring(0, 47)}...' : noteText,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> showNoteDeletedNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'note_channel',
        title: 'Note Deleted',
        body: 'A note has been deleted',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> showNoteUpdatedNotification(String noteText) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'note_channel',
        title: 'Note Updated',
        body: noteText.length > 50 ? '${noteText.substring(0, 47)}...' : noteText,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}