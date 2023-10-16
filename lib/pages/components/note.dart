class Note {
  final String title;
  final String content;
  final DateTime creationDate;

  Note({
    required this.title,
    required this.content,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }
}
