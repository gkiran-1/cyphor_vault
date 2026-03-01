import 'package:isar/isar.dart';

part 'note_entry.g.dart';

@collection
class NoteEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String encryptedData;
  late String encryptedItemKey;
  late String itemKeyIV;
  late String dataIV;
  late DateTime createdAt;
  late DateTime updatedAt;
}
