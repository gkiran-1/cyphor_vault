import 'package:isar/isar.dart';

part 'page_entry.g.dart';

@collection
class PageEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String encryptedData;
  late String encryptedItemKey;
  late String itemKeyIV;
  late String dataIV;
  late DateTime createdAt;
  late DateTime updatedAt;
}
