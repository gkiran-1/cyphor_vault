import 'package:isar/isar.dart';

part 'document_entry.g.dart';

@collection
class DocumentEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String documentType;
  late String encryptedData;
  late String encryptedItemKey;
  late String itemKeyIV;
  late String dataIV;
  late DateTime createdAt;
  late DateTime updatedAt;
}
