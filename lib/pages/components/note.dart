/// A class representing a note with a title, content, creation date, and unique ID.
class Note {
  final int id;
  final String title;
  final String content;
  final DateTime creationDate;

  /// Creates a new Note instance with the given title, content, and creation date.
  /// The ID is generated based on the creation date.
  Note({
    required this.title,
    required this.content,
    required this.creationDate,
  }) : id = creationDate.millisecondsSinceEpoch;

  /// Converts the Note instance to a map for storage in a database.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  /// Creates a new Note instance from a map retrieved from a database.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      creationDate: DateTime.parse(map['creationDate']),
    );
  }
}
