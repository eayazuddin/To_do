import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/to_do.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      List<List<dynamic>> csvData = const CsvToListConverter().convert(content);
      setState(() {
        todos = csvData.skip(1).map((row) {
          return Todo(
            id: row[0].toString(),
            title: row[1],
            description: row[2],
            createdAt: int.parse(row[3].toString()),
            status: row[4],
          );
        }).toList();
      });
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.csv');
  }

  void _addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
    _saveTodos();
  }

  void _saveTodos() async {
    final file = await _getLocalFile();
    List<List<dynamic>> csvData = [
      ['id', 'title', 'description', 'created_at', 'status'],
      ...todos.map((todo) => [todo.id, todo.title, todo.description, todo.createdAt, todo.status])
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(csv);
  }

  void _addTodoDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Todo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newTodo = Todo(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                description: descriptionController.text,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                status: 'pending',
              );
              _addTodo(newTodo);
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: Text(todo.status),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
