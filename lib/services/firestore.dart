import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification/services/notification_service.dart';


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