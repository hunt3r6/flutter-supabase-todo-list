import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_supabase/model/todo_model.dart';
import 'package:todo_list_supabase/service/todo_service.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  final TodoService _service;

  TodoCubit(super.initialState, this._service);

  Future<void> fetchTodos() async {
    try {
      final todos = await _service.fetchTodos();
      emit(todos);
    } catch (e) {
      emit(state); // Kembalikan ke state sebelumnya jika error
      rethrow;
    }
  }

  Future<void> addTodo(String title) async {
    try {
      await _service.addTodo(title);
      await fetchTodos(); // Refresh todos after adding
    } catch (e) {
      emit(state); // Kembalikan ke state sebelumnya jika error
      rethrow;
    }
  }

  Future<void> toggleDone(TodoModel todo) async {
    try {
      await _service.toggleDone(todo.id, todo.isDone);
      await fetchTodos(); // Refresh todos after toggling
    } catch (e) {
      emit(state); // Kembalikan ke state sebelumnya jika error
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _service.deleteTodo(id);
      await fetchTodos(); // Refresh todos after deletion
    } catch (e) {
      emit(state); // Kembalikan ke state sebelumnya jika error
      rethrow;
    }
  }
}
