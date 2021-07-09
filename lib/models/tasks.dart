class Task {
  final int id;
  final String title, description;

  Task({this.id, this.title, this.description});

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
