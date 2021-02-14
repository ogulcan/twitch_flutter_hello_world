class TodoItem {
  final String text; 
  TodoItem({this.text});
  
  factory TodoItem.fromJson(Map<String, dynamic> json) => _$TodoItemFromJson(json);
  Map<String, dynamic> toJson() => _$TodoItemToJson(this);
}

TodoItem _$TodoItemFromJson(Map<String, dynamic> json) {
  return TodoItem(
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$TodoItemToJson(TodoItem instance) => <String, dynamic>{
  'text': instance.text,
};