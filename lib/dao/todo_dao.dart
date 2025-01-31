import 'dart:async';
import '../database/database.dart';
import '../model/todo.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = db.insert('Todo', todo.toDatabaseJson());
    return result;
  }

  Future<List<Todo>> getTodos({String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null && query.isNotEmpty) {
      result = await db
          .query('Todo', where: 'description LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query('Todo');
    }

    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = await db.update('Todo', todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete('Todo', where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
