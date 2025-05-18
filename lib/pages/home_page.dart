import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreService fireStoreService = FireStoreService();

  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  if(docID == null){
                    fireStoreService.addNote(textController.text);
                  }
                  else{
                    fireStoreService.updateNote(docID, textController.text);
                  }
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text("Add")
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: Colors.purpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: fireStoreService.getNotesStream(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              if (notesList.isEmpty) {
                return const Center(child: Text("No Notes..."));
              }

              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                  String noteText = data['note'] ?? '';
                  Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                  DateTime dateTime = timestamp.toDate();

                  String formattedDate =
                      "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";

                  return ListTile(
                    title: Text(
                      noteText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Created at: $formattedDate",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => fireStoreService.deleteNote(docID),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No Notes..."));
            }
          }
      ),
    );
  }
}
