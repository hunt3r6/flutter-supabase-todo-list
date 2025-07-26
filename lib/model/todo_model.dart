class TodoModel {
  final String id;
  final String title;
  final bool isDone;

  TodoModel({required this.id, required this.title, required this.isDone});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      isDone: json['is_done'],
    );
  }

  static List<TodoModel> fromJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => TodoModel.fromJson(json)).toList();
  }
}
