class Todo {
  String title;
  int timestamp;

  Todo(this.title) {
    this.timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() =>
    {
      'title': title,
      'timestamp': timestamp,
    };

  String toJsonString() => '{"title": "$title", "timestamp": $timestamp}';
}