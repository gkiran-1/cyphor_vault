import 'package:cyphor_vault/features/pages/models/page_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageDocument Migration Tests', () {
    test('Serializes and deserializes Quill Delta JSON correctly', () {
      final deltaOps = [
        {'insert': 'Hello World'},
        {
          'insert': '\n',
          'attributes': {'header': 1}
        },
      ];

      final doc = PageDocument(title: 'Test Note', document: deltaOps);
      final jsonMap = doc.toJson();

      final restored = PageDocument.fromJson(jsonMap);
      expect(restored.title, 'Test Note');
      expect(restored.document, deltaOps);

      final quillDoc = restored.toQuillDocument();
      expect(quillDoc.toPlainText().trim(), 'Hello World');
    });

    test('Converts legacy AppFlowy Editor block tree to Quill Delta format', () {
      final legacyAppFlowyJson = {
        'title': 'Legacy Note',
        'coverEmoji': '📝',
        'document': {
          'type': 'page',
          'children': [
            {
              'type': 'heading',
              'data': {
                'level': 1,
                'delta': [
                  {'insert': 'Heading Title'}
                ]
              }
            },
            {
              'type': 'paragraph',
              'data': {
                'delta': [
                  {
                    'insert': 'This is bold text',
                    'attributes': {'bold': true}
                  }
                ]
              }
            },
            {
              'type': 'quote',
              'data': {
                'delta': [
                  {'insert': 'A wise quote'}
                ]
              }
            },
            {
              'type': 'bulleted_list',
              'data': {
                'delta': [
                  {'insert': 'Bullet item 1'}
                ]
              }
            },
            {
              'type': 'todo_list',
              'data': {
                'checked': true,
                'delta': [
                  {'insert': 'Completed task'}
                ]
              }
            },
            {
              'type': 'image',
              'data': {
                'url': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
              }
            }
          ]
        }
      };

      final restored = PageDocument.fromJson(legacyAppFlowyJson);
      expect(restored.title, 'Legacy Note');
      expect(restored.coverEmoji, '📝');
      expect(restored.document, isNotEmpty);

      final quillDoc = restored.toQuillDocument();
      final plainText = quillDoc.toPlainText();

      expect(plainText, contains('Heading Title'));
      expect(plainText, contains('This is bold text'));
      expect(plainText, contains('A wise quote'));
      expect(plainText, contains('Bullet item 1'));
      expect(plainText, contains('Completed task'));
    });
  });
}
