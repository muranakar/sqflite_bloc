import 'dart:async';
import '../model/todo.dart';
import '../repository/todo_repository.dart';

class TodoBloc {
  final _todoRepository = TodoRepository();

  final _todoController = StreamController<List<Todo>>.broadcast();

  Stream<List<Todo>> get todos => _todoController.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos({String? query}) async {
    _todoController.sink.add(
      await _todoRepository.getAllTodos(query: query)
    );
  }

  addTodo(Todo todo) async {
    await _todoRepository.insertTodo(todo);
    getTodos();
  }

  updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
    getTodos();
  }

  deleteTodoById(int id) async {
    await _todoRepository.deleteTodoById(id);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}
