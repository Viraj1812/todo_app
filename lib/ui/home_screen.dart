import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/ui/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<List<TODO>> listNotifier = ValueNotifier<List<TODO>>([]);
  // List<TODO> list = [];
  late SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  set prefs(SharedPreferences value) {
    _prefs = value;
  }

  @override
  void initState() {
    super.initState();
    setupTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO APP',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 211, 176, 255),
      ),
      body: ValueListenableBuilder(
        valueListenable: listNotifier,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: listNotifier.value.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(listNotifier.value[index].title!),
                subtitle: Text(
                  listNotifier.value[index].desc!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _editTodo(index);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteTodo(index);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTodoScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTodoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    ).then((value) {
      if (value != null) {
        handleState(value);
      }
      saveTodo();
    });
  }

  void handleState(TODO item) {
    listNotifier.value = List.of(listNotifier.value)..add(item);
    saveTodo();
  }

  void _editTodo(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController =
            TextEditingController(text: listNotifier.value[index].title);
        TextEditingController descriptionController =
            TextEditingController(text: listNotifier.value[index].desc);

        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(hintText: 'Enter edited title'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(hintText: 'Enter edited description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                listNotifier.value = List.of(listNotifier.value)
                  ..[index].title = titleController.text;
                listNotifier.value = List.of(listNotifier.value)
                  ..[index].desc = descriptionController.text;
                ;
                saveTodo();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                listNotifier.value = List.of(listNotifier.value)
                  ..removeAt(index);
                saveTodo();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList('todo');
    if (todoList != null) {
      listNotifier.value =
          todoList.map((e) => TODO.fromJson(json.decode(e))).toList();
    }
  }

  void saveTodo() {
    List<String> todoList =
        listNotifier.value.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('todo', todoList);
  }
}
