class ChatMessageModel {
  final int? id;
  final String role; // 'user' | 'assistant'
  final String text;
  final DateTime timestamp;
  final List<String> sources;

  ChatMessageModel({
    this.id,
    required this.role,
    required this.text,
    DateTime? timestamp,
    this.sources = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'role': role,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        if (sources.isNotEmpty) 'sources': sources.join('|'),
      };

  factory ChatMessageModel.fromMap(Map<String, dynamic> m) {
    final sourcesRaw = m['sources'] as String? ?? '';
    return ChatMessageModel(
      id: m['id'] as int?,
      role: m['role'] as String? ?? 'user',
      text: m['text'] as String? ?? '',
      timestamp: DateTime.tryParse(m['timestamp'] as String? ?? ''),
      sources: sourcesRaw.isEmpty
          ? []
          : sourcesRaw.split('|').where((s) => s.isNotEmpty).toList(),
    );
  }
}
