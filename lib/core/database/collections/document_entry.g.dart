// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDocumentEntryCollection on Isar {
  IsarCollection<DocumentEntry> get documentEntrys => this.collection();
}

const DocumentEntrySchema = CollectionSchema(
  name: r'DocumentEntry',
  id: -5441240361459940692,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dataIV': PropertySchema(
      id: 1,
      name: r'dataIV',
      type: IsarType.string,
    ),
    r'documentType': PropertySchema(
      id: 2,
      name: r'documentType',
      type: IsarType.string,
    ),
    r'encryptedData': PropertySchema(
      id: 3,
      name: r'encryptedData',
      type: IsarType.string,
    ),
    r'encryptedItemKey': PropertySchema(
      id: 4,
      name: r'encryptedItemKey',
      type: IsarType.string,
    ),
    r'itemKeyIV': PropertySchema(
      id: 5,
      name: r'itemKeyIV',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 7,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _documentEntryEstimateSize,
  serialize: _documentEntrySerialize,
  deserialize: _documentEntryDeserialize,
  deserializeProp: _documentEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _documentEntryGetId,
  getLinks: _documentEntryGetLinks,
  attach: _documentEntryAttach,
  version: '3.1.0+1',
);

int _documentEntryEstimateSize(
  DocumentEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataIV.length * 3;
  bytesCount += 3 + object.documentType.length * 3;
  bytesCount += 3 + object.encryptedData.length * 3;
  bytesCount += 3 + object.encryptedItemKey.length * 3;
  bytesCount += 3 + object.itemKeyIV.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _documentEntrySerialize(
  DocumentEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.dataIV);
  writer.writeString(offsets[2], object.documentType);
  writer.writeString(offsets[3], object.encryptedData);
  writer.writeString(offsets[4], object.encryptedItemKey);
  writer.writeString(offsets[5], object.itemKeyIV);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeString(offsets[7], object.uuid);
}

DocumentEntry _documentEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DocumentEntry();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dataIV = reader.readString(offsets[1]);
  object.documentType = reader.readString(offsets[2]);
  object.encryptedData = reader.readString(offsets[3]);
  object.encryptedItemKey = reader.readString(offsets[4]);
  object.id = id;
  object.itemKeyIV = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  object.uuid = reader.readString(offsets[7]);
  return object;
}

P _documentEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _documentEntryGetId(DocumentEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _documentEntryGetLinks(DocumentEntry object) {
  return [];
}

void _documentEntryAttach(
    IsarCollection<dynamic> col, Id id, DocumentEntry object) {
  object.id = id;
}

extension DocumentEntryQueryWhereSort
    on QueryBuilder<DocumentEntry, DocumentEntry, QWhere> {
  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DocumentEntryQueryWhere
    on QueryBuilder<DocumentEntry, DocumentEntry, QWhereClause> {
  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DocumentEntryQueryFilter
    on QueryBuilder<DocumentEntry, DocumentEntry, QFilterCondition> {
  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataIV',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      dataIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentType',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      documentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentType',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encryptedItemKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedItemKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      encryptedItemKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemKeyIV',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemKeyIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      itemKeyIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension DocumentEntryQueryObject
    on QueryBuilder<DocumentEntry, DocumentEntry, QFilterCondition> {}

extension DocumentEntryQueryLinks
    on QueryBuilder<DocumentEntry, DocumentEntry, QFilterCondition> {}

extension DocumentEntryQuerySortBy
    on QueryBuilder<DocumentEntry, DocumentEntry, QSortBy> {
  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DocumentEntryQuerySortThenBy
    on QueryBuilder<DocumentEntry, DocumentEntry, QSortThenBy> {
  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension DocumentEntryQueryWhereDistinct
    on QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> {
  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByDataIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByDocumentType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByEncryptedData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedData',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct>
      distinctByEncryptedItemKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedItemKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByItemKeyIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemKeyIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<DocumentEntry, DocumentEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension DocumentEntryQueryProperty
    on QueryBuilder<DocumentEntry, DocumentEntry, QQueryProperty> {
  QueryBuilder<DocumentEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DocumentEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations> dataIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataIV');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations> documentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentType');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations>
      encryptedDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedData');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations>
      encryptedItemKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedItemKey');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations> itemKeyIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemKeyIV');
    });
  }

  QueryBuilder<DocumentEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<DocumentEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
