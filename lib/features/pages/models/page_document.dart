import 'package:flutter_quill/flutter_quill.dart';

class PageDocument {
  final String title;
  final String? coverEmoji;

  /// The serialized Quill Delta document operations list: `[{"insert": "...\n"}]`.
  final List<dynamic> document;

  const PageDocument({
    required this.title,
    this.coverEmoji,
    required this.document,
  });

  /// Instantiates a [Document] for use with a [QuillController].
  Document toQuillDocument() {
    if (document.isEmpty) {
      return Document();
    }
    try {
      return Document.fromJson(document);
    } catch (_) {
      return Document();
    }
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        if (coverEmoji != null) 'coverEmoji': coverEmoji,
        'document': document,
      };

  factory PageDocument.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? 'Untitled';
    final coverEmoji = json['coverEmoji'] as String?;
    final rawDoc = json['document'];

    List<dynamic> parsedOps;
    if (rawDoc is List) {
      parsedOps = List<dynamic>.from(rawDoc);
    } else if (rawDoc is Map) {
      parsedOps = convertAppFlowyToQuillDelta(Map<String, dynamic>.from(rawDoc));
    } else {
      parsedOps = [
        {'insert': '\n'}
      ];
    }

    return PageDocument(
      title: title,
      coverEmoji: coverEmoji,
      document: parsedOps,
    );
  }

  /// Converts legacy AppFlowy block-tree JSON format to Quill Delta ops list.
  static List<dynamic> convertAppFlowyToQuillDelta(Map<String, dynamic> appflowyDoc) {
    final ops = <Map<String, dynamic>>[];

    List<dynamic>? children;
    if (appflowyDoc.containsKey('children') && appflowyDoc['children'] is List) {
      children = appflowyDoc['children'] as List<dynamic>;
    } else if (appflowyDoc.containsKey('document') &&
        appflowyDoc['document'] is Map &&
        (appflowyDoc['document'] as Map).containsKey('children')) {
      children = (appflowyDoc['document'] as Map)['children'] as List<dynamic>;
    }

    if (children == null || children.isEmpty) {
      return [
        {'insert': '\n'}
      ];
    }

    for (final child in children) {
      if (child is! Map) continue;
      final node = Map<String, dynamic>.from(child);
      final type = node['type'] as String? ?? 'paragraph';
      final data = node['data'] is Map ? Map<String, dynamic>.from(node['data'] as Map) : <String, dynamic>{};

      if (type == 'image') {
        final url = data['url'] as String? ?? data['src'] as String?;
        if (url != null && url.isNotEmpty) {
          final imageUrl = url.startsWith('data:') ? url : (url.length > 200 ? 'data:image/png;base64,$url' : url);
          ops.add({
            'insert': {'image': imageUrl}
          });
          ops.add({'insert': '\n'});
        }
        continue;
      }

      // Process inline text and formatting
      var lineHasText = false;
      if (data.containsKey('delta') && data['delta'] is List) {
        final deltaList = data['delta'] as List<dynamic>;
        for (final deltaOp in deltaList) {
          if (deltaOp is Map) {
            final opMap = Map<String, dynamic>.from(deltaOp);
            final text = opMap['insert'] as String? ?? '';
            if (text.isNotEmpty) {
              lineHasText = true;
              final attributes = opMap['attributes'] is Map ? Map<String, dynamic>.from(opMap['attributes'] as Map) : null;
              ops.add({
                'insert': text,
                if (attributes != null && attributes.isNotEmpty) 'attributes': attributes,
              });
            }
          }
        }
      } else if (data.containsKey('text') && data['text'] is String) {
        final text = data['text'] as String;
        if (text.isNotEmpty) {
          lineHasText = true;
          ops.add({'insert': text});
        }
      }

      if (!lineHasText) {
        ops.add({'insert': ''});
      }

      // Append block attributes to trailing newline
      final blockAttrs = <String, dynamic>{};
      if (type == 'heading') {
        final level = data['level'] as int? ?? 1;
        blockAttrs['header'] = level;
      } else if (type == 'quote') {
        blockAttrs['blockquote'] = true;
      } else if (type == 'bulleted_list') {
        blockAttrs['list'] = 'bullet';
      } else if (type == 'numbered_list') {
        blockAttrs['list'] = 'ordered';
      } else if (type == 'todo_list') {
        blockAttrs['list'] = (data['checked'] == true) ? 'checked' : 'unchecked';
      }

      ops.add({
        'insert': '\n',
        if (blockAttrs.isNotEmpty) 'attributes': blockAttrs,
      });
    }

    if (ops.isEmpty) {
      return [
        {'insert': '\n'}
      ];
    }

    return ops;
  }
}
