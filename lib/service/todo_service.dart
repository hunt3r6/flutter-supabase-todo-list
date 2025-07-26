import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_list_supabase/model/todo_model.dart';

class TodoService {
  final _client = Supabase.instance.client;

  Future<List<TodoModel>> fetchTodos() async {
    return run(() async {
      final response = await _client
          .from('todos')
          .select()
          .order('created_at', ascending: false);

      return TodoModel.fromJsonToList(response);
    });
  }

  Future<void> addTodo(String title) async {
    return run(() async {
      await _client.from('todos').insert({
        'title': title,
        'is_done': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> toggleDone(String id, bool isDone) async {
    return run(() async {
      await _client.from('todos').update({'is_done': !isDone}).eq('id', id);
    });
  }

  Future<void> deleteTodo(String id) async {
    return run(() async {
      await _client.from('todos').delete().eq('id', id);
    });
  }

  Future<T> run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}

class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'Server error'});
}
