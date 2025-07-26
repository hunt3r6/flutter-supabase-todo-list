import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_supabase/cubit/todo_cubit.dart';
import 'package:todo_list_supabase/model/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    context.read<TodoCubit>().fetchTodos(); // Fetch todos on init
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan tugas baru',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _addTodo(); // Call the method to add todo
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _addTodo(); // Call the method to add todo
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: Refresh Data Todo List
              },
              child: BlocBuilder<TodoCubit, List<TodoModel>>(
                builder: (context, state) {
                  final todos = state;
                  if (todos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada tugas',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: todos.length, // TODO: Ganti dengan jumlah todo
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) {
                            context.read<TodoCubit>().toggleDone(todo);
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<TodoCubit>().deleteTodo(todo.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    if (titleController.text.trim().isNotEmpty) {
      context.read<TodoCubit>().addTodo(titleController.text.trim());
      titleController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
