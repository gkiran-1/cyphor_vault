// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNoteEntryCollection on Isar {
  IsarCollection<NoteEntry> get noteEntrys => this.collection();
}

const NoteEntrySchema = CollectionSchema(
  name: r'NoteEntry',
  id: 6591543896557105152,
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
    r'encryptedData': PropertySchema(
      id: 2,
      name: r'encryptedData',
      type: IsarType.string,
    ),
    r'encryptedItemKey': PropertySchema(
      id: 3,
      name: r'encryptedItemKey',
      type: IsarType.string,
    ),
    r'itemKeyIV': PropertySchema(
      id: 4,
      name: r'itemKeyIV',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 6,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _noteEntryEstimateSize,
  serialize: _noteEntrySerialize,
  deserialize: _noteEntryDeserialize,
  deserializeProp: _noteEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _noteEntryGetId,
  getLinks: _noteEntryGetLinks,
  attach: _noteEntryAttach,
  version: '3.1.0+1',
);

int _noteEntryEstimateSize(
  NoteEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataIV.length * 3;
  bytesCount += 3 + object.encryptedData.length * 3;
  bytesCount += 3 + object.encryptedItemKey.length * 3;
  bytesCount += 3 + object.itemKeyIV.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _noteEntrySerialize(
  NoteEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.dataIV);
  writer.writeString(offsets[2], object.encryptedData);
  writer.writeString(offsets[3], object.encryptedItemKey);
  writer.writeString(offsets[4], object.itemKeyIV);
  writer.writeDateTime(offsets[5], object.updatedAt);
  writer.writeString(offsets[6], object.uuid);
}

NoteEntry _noteEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NoteEntry();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dataIV = reader.readString(offsets[1]);
  object.encryptedData = reader.readString(offsets[2]);
  object.encryptedItemKey = reader.readString(offsets[3]);
  object.id = id;
  object.itemKeyIV = reader.readString(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  object.uuid = reader.readString(offsets[6]);
  return object;
}

P _noteEntryDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _noteEntryGetId(NoteEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _noteEntryGetLinks(NoteEntry object) {
  return [];
}

void _noteEntryAttach(IsarCollection<dynamic> col, Id id, NoteEntry object) {
  object.id = id;
}

extension NoteEntryQueryWhereSort
    on QueryBuilder<NoteEntry, NoteEntry, QWhere> {
  QueryBuilder<NoteEntry, NoteEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NoteEntryQueryWhere
    on QueryBuilder<NoteEntry, NoteEntry, QWhereClause> {
  QueryBuilder<NoteEntry, NoteEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterWhereClause> idBetween(
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

extension NoteEntryQueryFilter
    on QueryBuilder<NoteEntry, NoteEntry, QFilterCondition> {
  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVEqualTo(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVGreaterThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVStartsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVEndsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> dataIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedItemKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedItemKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedItemKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedItemKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      encryptedItemKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVEqualTo(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVStartsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVEndsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemKeyIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> itemKeyIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
      itemKeyIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition>
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension NoteEntryQueryObject
    on QueryBuilder<NoteEntry, NoteEntry, QFilterCondition> {}

extension NoteEntryQueryLinks
    on QueryBuilder<NoteEntry, NoteEntry, QFilterCondition> {}

extension NoteEntryQuerySortBy on QueryBuilder<NoteEntry, NoteEntry, QSortBy> {
  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy>
      sortByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension NoteEntryQuerySortThenBy
    on QueryBuilder<NoteEntry, NoteEntry, QSortThenBy> {
  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy>
      thenByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension NoteEntryQueryWhereDistinct
    on QueryBuilder<NoteEntry, NoteEntry, QDistinct> {
  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByDataIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByEncryptedData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedData',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByEncryptedItemKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedItemKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByItemKeyIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemKeyIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<NoteEntry, NoteEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension NoteEntryQueryProperty
    on QueryBuilder<NoteEntry, NoteEntry, QQueryProperty> {
  QueryBuilder<NoteEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NoteEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<NoteEntry, String, QQueryOperations> dataIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataIV');
    });
  }

  QueryBuilder<NoteEntry, String, QQueryOperations> encryptedDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedData');
    });
  }

  QueryBuilder<NoteEntry, String, QQueryOperations> encryptedItemKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedItemKey');
    });
  }

  QueryBuilder<NoteEntry, String, QQueryOperations> itemKeyIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemKeyIV');
    });
  }

  QueryBuilder<NoteEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<NoteEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
