**Awesome Notifications Firebase Assignment**
---------------------------------------------

Pertama-tama tambahkan beberapa package kedalam `pubspec.yaml`,

```dart
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  firebase_core: ^3.13.0
  cloud_firestore: ^5.6.7
  awesome_notifications: ^0.10.1
```
Pada main.dart ditambahkan initialize firebase dan awsome notification 

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //init awesome notification
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'note_channel',
        channelName: 'Note Notifications',
        channelDescription: 'Notifications for note activities',
        defaultColor: Colors.purple,
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
  );

  // asking permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // klo udh ada permission
  if (isAllowed) {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 999,
        channelKey: 'note_channel',
        title: 'Test Notification',
        body: 'If you see this, Awesome Notifications works!',
      ),
    );
  }

  runApp(const MyApp());
}
```

Didalam main diatas pertama-tama akan meng-initialize firebase dan AwesomeNotification.
Setelah berhasil kode akan memberikan test notification.


Kemudian dalam `firestore.dart` akan dilakukan CRUD dan pemanggilan notifikasi
```dart
class FireStoreService {
  // get collection from database
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // Create
  Future<void> addNote(String note) async {
    await notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });

    // show notification
    await NotificationService.showNoteCreatedNotification(note);
  }

  // read
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
      notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // Update
  Future<void> updateNote(String docID, String newNote) async {
    await notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });

    //show notification
    await NotificationService.showNoteUpdatedNotification(newNote);
  }

  // Delete
  Future<void> deleteNote(String docID) async {
    await notes.doc(docID).delete();

    // Show notification
    await NotificationService.showNoteDeletedNotification();
  }
}
```

Kemudian kita tambahkan fungsi pemanggilan notifikasi di dalam `notification_service.dart` ketika melakukan CRUD

```dart
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
```
Hasil Dari Kode Diatas:
![image](https://github.com/user-attachments/assets/0a5187b3-ba84-49e5-bb20-483d0211e35e)


