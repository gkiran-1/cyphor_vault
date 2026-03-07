// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPasswordEntryCollection on Isar {
  IsarCollection<PasswordEntry> get passwordEntrys => this.collection();
}

const PasswordEntrySchema = CollectionSchema(
  name: r'PasswordEntry',
  id: 7629463826840264704,
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
  estimateSize: _passwordEntryEstimateSize,
  serialize: _passwordEntrySerialize,
  deserialize: _passwordEntryDeserialize,
  deserializeProp: _passwordEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _passwordEntryGetId,
  getLinks: _passwordEntryGetLinks,
  attach: _passwordEntryAttach,
  version: '3.1.0+1',
);

int _passwordEntryEstimateSize(
  PasswordEntry object,
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

void _passwordEntrySerialize(
  PasswordEntry object,
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

PasswordEntry _passwordEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PasswordEntry();
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

P _passwordEntryDeserializeProp<P>(
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

Id _passwordEntryGetId(PasswordEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _passwordEntryGetLinks(PasswordEntry object) {
  return [];
}

void _passwordEntryAttach(
    IsarCollection<dynamic> col, Id id, PasswordEntry object) {
  object.id = id;
}

extension PasswordEntryQueryWhereSort
    on QueryBuilder<PasswordEntry, PasswordEntry, QWhere> {
  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PasswordEntryQueryWhere
    on QueryBuilder<PasswordEntry, PasswordEntry, QWhereClause> {
  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterWhereClause> idBetween(
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

extension PasswordEntryQueryFilter
    on QueryBuilder<PasswordEntry, PasswordEntry, QFilterCondition> {
  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      dataIVContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      dataIVMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      dataIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      dataIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedItemKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedItemKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedItemKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedItemKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      encryptedItemKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      itemKeyIVContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemKeyIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      itemKeyIVMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemKeyIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      itemKeyIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      itemKeyIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PasswordEntryQueryObject
    on QueryBuilder<PasswordEntry, PasswordEntry, QFilterCondition> {}

extension PasswordEntryQueryLinks
    on QueryBuilder<PasswordEntry, PasswordEntry, QFilterCondition> {}

extension PasswordEntryQuerySortBy
    on QueryBuilder<PasswordEntry, PasswordEntry, QSortBy> {
  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PasswordEntryQuerySortThenBy
    on QueryBuilder<PasswordEntry, PasswordEntry, QSortThenBy> {
  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PasswordEntryQueryWhereDistinct
    on QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> {
  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByDataIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByEncryptedData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedData',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct>
      distinctByEncryptedItemKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedItemKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByItemKeyIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemKeyIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PasswordEntry, PasswordEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PasswordEntryQueryProperty
    on QueryBuilder<PasswordEntry, PasswordEntry, QQueryProperty> {
  QueryBuilder<PasswordEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PasswordEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PasswordEntry, String, QQueryOperations> dataIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataIV');
    });
  }

  QueryBuilder<PasswordEntry, String, QQueryOperations>
      encryptedDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedData');
    });
  }

  QueryBuilder<PasswordEntry, String, QQueryOperations>
      encryptedItemKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedItemKey');
    });
  }

  QueryBuilder<PasswordEntry, String, QQueryOperations> itemKeyIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemKeyIV');
    });
  }

  QueryBuilder<PasswordEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PasswordEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
