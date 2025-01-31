import 'package:flutter/material.dart';
import '../bloc/todo_bloc.dart';
import '../model/todo.dart';

class HomePage extends StatelessWidget {
  final TodoBloc todoBloc = TodoBloc();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _todoSearchDescriptionFormController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showTodoSearchSheet(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoBloc.todos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Todo todo = snapshot.data![index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) {
                    todoBloc.deleteTodoById(todo.id);
                  },
                  child: ListTile(
                    title: Text(todo.description),
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (bool? value) {
                        if (value != null) {
                          todo.isDone = value;
                          todoBloc.updateTodo(todo);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _displayAddTodoDialog(context);
        },
      ),
    );
  }

  Future<void> _displayAddTodoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a new todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter your todo here'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                final newTodo = Todo(
                  id: DateTime.now().millisecondsSinceEpoch,
                  description: _textFieldController.text,
                );
                todoBloc.addTodo(newTodo);
                _textFieldController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTodoSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _todoSearchDescriptionFormController,
                decoration: const InputDecoration(
                  labelText: 'Search Todos',
                  hintText: 'Enter description',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, top: 15),
                child: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 22,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      todoBloc.getTodos(
                        query: _todoSearchDescriptionFormController.value.text,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
