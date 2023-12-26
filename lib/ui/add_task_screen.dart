import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/model/todo_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 211, 176, 255),
        title: Text(
          'ADD Task',
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter title'),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Enter description'),
              maxLines: 4,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            TODO newTask = TODO(
              title: titleController.text,
              desc: descriptionController.text,
            );
            Navigator.pop(context, newTask);
            // widget.handleState(newTask);
          },
          child: const Text('Add Todo'),
        ),
      ]),
    );
  }
}
