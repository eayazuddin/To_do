class Todo {
  String id;
  String title;
  String description;
  int createdAt;
  String status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'created_at': createdAt,
    'status': status,
  };

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }
}