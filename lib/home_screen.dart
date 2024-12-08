import 'package:flutter/material.dart';
import 'package:to_do_list/add_list.dart';
import 'package:to_do_list/data/list.dart'; // Import the Todolist class
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:convert'; // Import json

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void _loadToDoList() async {
    await Todolist.loadTodoList();
    setState(() {});
  }

  void _addToDoItem(Todolist item) async {
    setState(() {
      Todolist.addTodoItem(item.listTodo); // Add item to Todolist
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todoList', Todolist.todoList.map((e) => json.encode(e.toJson())).toList());
  }

  void _updateToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todoList', Todolist.todoList.map((e) => json.encode(e.toJson())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
            'ToDone',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            if (Todolist.todoList.isEmpty) ...[ // Check if Todolist is empty
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/home_screen.jpg',
                      width: 400,
                    ),
                    const Text(
                      'Belum ada To Do List, coba tambahkan lewat tombol di bawah',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: Todolist.todoList.length, // Use Todolist length
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(Todolist.todoList[index].listTodo),
                          if (Todolist.todoList[index].isDone)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ), // Use Todolist item
                      trailing: Checkbox(
                        value: Todolist.todoList[index].isDone, // Use isDone status
                        onChanged: (bool? value) {
                          setState(() {
                            Todolist.todoList[index].isDone = value ?? false; // Update isDone status
                          });
                          _updateToDoList(); // Save updated status
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddList()),
          );
          if (result != null) {
            _addToDoItem(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}