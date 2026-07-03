// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPageEntryCollection on Isar {
  IsarCollection<PageEntry> get pageEntrys => this.collection();
}

const PageEntrySchema = CollectionSchema(
  name: r'PageEntry',
  id: -1736692989501714157,
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
  estimateSize: _pageEntryEstimateSize,
  serialize: _pageEntrySerialize,
  deserialize: _pageEntryDeserialize,
  deserializeProp: _pageEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pageEntryGetId,
  getLinks: _pageEntryGetLinks,
  attach: _pageEntryAttach,
  version: '3.1.0+1',
);

int _pageEntryEstimateSize(
  PageEntry object,
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

void _pageEntrySerialize(
  PageEntry object,
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

PageEntry _pageEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PageEntry();
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

P _pageEntryDeserializeProp<P>(
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

Id _pageEntryGetId(PageEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pageEntryGetLinks(PageEntry object) {
  return [];
}

void _pageEntryAttach(IsarCollection<dynamic> col, Id id, PageEntry object) {
  object.id = id;
}

extension PageEntryQueryWhereSort
    on QueryBuilder<PageEntry, PageEntry, QWhere> {
  QueryBuilder<PageEntry, PageEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PageEntryQueryWhere
    on QueryBuilder<PageEntry, PageEntry, QWhereClause> {
  QueryBuilder<PageEntry, PageEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PageEntry, PageEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterWhereClause> idBetween(
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

extension PageEntryQueryFilter
    on QueryBuilder<PageEntry, PageEntry, QFilterCondition> {
  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVEqualTo(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVGreaterThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVStartsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVEndsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVContains(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVMatches(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> dataIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedData',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedItemKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encryptedItemKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedItemKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encryptedItemKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedItemKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      encryptedItemKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encryptedItemKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVEqualTo(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVStartsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVEndsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVContains(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVMatches(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> itemKeyIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
      itemKeyIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemKeyIV',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition>
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidEqualTo(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidGreaterThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidLessThan(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidBetween(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidStartsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidEndsWith(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidContains(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidMatches(
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

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterFilterCondition> uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PageEntryQueryObject
    on QueryBuilder<PageEntry, PageEntry, QFilterCondition> {}

extension PageEntryQueryLinks
    on QueryBuilder<PageEntry, PageEntry, QFilterCondition> {}

extension PageEntryQuerySortBy on QueryBuilder<PageEntry, PageEntry, QSortBy> {
  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy>
      sortByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PageEntryQuerySortThenBy
    on QueryBuilder<PageEntry, PageEntry, QSortThenBy> {
  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByDataIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByDataIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataIV', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByEncryptedData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByEncryptedDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedData', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByEncryptedItemKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy>
      thenByEncryptedItemKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedItemKey', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByItemKeyIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByItemKeyIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemKeyIV', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PageEntryQueryWhereDistinct
    on QueryBuilder<PageEntry, PageEntry, QDistinct> {
  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByDataIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByEncryptedData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedData',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByEncryptedItemKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encryptedItemKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByItemKeyIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemKeyIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PageEntry, PageEntry, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PageEntryQueryProperty
    on QueryBuilder<PageEntry, PageEntry, QQueryProperty> {
  QueryBuilder<PageEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PageEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PageEntry, String, QQueryOperations> dataIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataIV');
    });
  }

  QueryBuilder<PageEntry, String, QQueryOperations> encryptedDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedData');
    });
  }

  QueryBuilder<PageEntry, String, QQueryOperations> encryptedItemKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedItemKey');
    });
  }

  QueryBuilder<PageEntry, String, QQueryOperations> itemKeyIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemKeyIV');
    });
  }

  QueryBuilder<PageEntry, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PageEntry, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
