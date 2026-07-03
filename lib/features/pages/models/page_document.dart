class PageDocument {
  final String title;
  final String? coverEmoji;

  /// The serialized AppFlowy editor document — output of Document.toJson().
  /// Shape: {'document': {'type': 'page', 'children': [...]}}
  final Map<String, dynamic> document;

  const PageDocument({
    required this.title,
    this.coverEmoji,
    required this.document,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (coverEmoji != null) 'coverEmoji': coverEmoji,
        'document': document,
      };

  factory PageDocument.fromJson(Map<String, dynamic> json) {
    final doc = json['document'];
    return PageDocument(
      title: json['title'] as String? ?? 'Untitled',
      coverEmoji: json['coverEmoji'] as String?,
      document: doc is Map
          ? Map<String, dynamic>.from(doc)
          : {
              'document': {'type': 'page', 'children': []}
            },
    );
  }
}
