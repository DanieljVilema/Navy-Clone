class ChatMessageModel {
  final int? id;
  final String role; // 'user' | 'assistant'
  final String text;
  final DateTime timestamp;

  ChatMessageModel({
    this.id,
    required this.role,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'role': role,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessageModel.fromMap(Map<String, dynamic> m) => ChatMessageModel(
        id: m['id'] as int?,
        role: m['role'] as String? ?? 'user',
        text: m['text'] as String? ?? '',
        timestamp: DateTime.tryParse(m['timestamp'] as String? ?? ''),
      );
}
