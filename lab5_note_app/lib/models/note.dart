class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id':        id,
    'title':     title,
    'content':   content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  static Note fromMap(Map<String, dynamic> map) => Note(
    id:        map['id'],
    title:     map['title'],
    content:   map['content'],
    createdAt: DateTime.parse(map['createdAt']),
    updatedAt: DateTime.parse(map['updatedAt']),
  );

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id:        id        ?? this.id,
    title:     title     ?? this.title,
    content:   content   ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}