import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo List', home: TodoList());
  }
}

class Todo {
  int id;
  String title;
  DateTime date;

  Todo({this.id, this.title, this.date});
}

class TodoList extends StatefulWidget {
  @override
  createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _todoList = [];

  void _addTodoItem(Todo task) {
    if (task.title != null) {
      setState(() {
        _todoList.add(task);
        _todoList.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void _editTodoItem(Todo task, int index) {
    if (task.title != null) {
      setState(() {
        _todoList.removeAt(index);
        _todoList.add(task);
        _todoList.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void _removeTodoItem(int index) {
    setState(() => _todoList.removeAt(index));
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoList.length) {
          return _buildTodoItem(_todoList[index], index);
        }
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(Todo todoText, int index) {
    return ListTile(
      title: Text(todoText.title),
      subtitle: Text(todoText.date.toString().substring(0, 19)),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text("Edit"),
              value: 'edit',
            ),
            PopupMenuItem(
              child: Text("Delete"),
              value: 'delete',
            )
          ];
        },
        onSelected: (value) {
          switch (value) {
            case "edit":
              {
                pushAddTodoScreen(todoText, 'Edit todo', index);
              }
              break;
            case "delete":
              {
                _removeTodoItem(index);
              }
              break;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List ')),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => pushAddTodoScreen(Todo(title: ''), 'Add Todo', 0),
          tooltip: 'Add task',
          child: Icon(Icons.add)),
    );
  }

  pushAddTodoScreen(Todo todo, String title, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      TextEditingController _todoController =
          TextEditingController(text: todo.title ?? '');
      return Scaffold(
          appBar: AppBar(title: Text(title ?? 'Add a new task')),
          body: TextField(
            autofocus: true,
            controller: _todoController,
            onSubmitted: (val) {
              if (index != 0)
                _editTodoItem(Todo(date: DateTime.now(), title: val), index);
              else
                _addTodoItem(Todo(date: DateTime.now(), title: val));
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
