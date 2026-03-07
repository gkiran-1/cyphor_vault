// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileCollection on Isar {
  IsarCollection<UserProfile> get userProfiles => this.collection();
}

const UserProfileSchema = CollectionSchema(
  name: r'UserProfile',
  id: 4738427352541298688,
  properties: {
    r'autoBackupEnabled': PropertySchema(
      id: 0,
      name: r'autoBackupEnabled',
      type: IsarType.bool,
    ),
    r'autoBackupFrequency': PropertySchema(
      id: 1,
      name: r'autoBackupFrequency',
      type: IsarType.string,
    ),
    r'biometricEnabled': PropertySchema(
      id: 2,
      name: r'biometricEnabled',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'kekIV': PropertySchema(
      id: 4,
      name: r'kekIV',
      type: IsarType.string,
    ),
    r'lastBackupDate': PropertySchema(
      id: 5,
      name: r'lastBackupDate',
      type: IsarType.dateTime,
    ),
    r'pinHash': PropertySchema(
      id: 6,
      name: r'pinHash',
      type: IsarType.string,
    ),
    r'pinSalt': PropertySchema(
      id: 7,
      name: r'pinSalt',
      type: IsarType.string,
    ),
    r'recoveryKekIV': PropertySchema(
      id: 8,
      name: r'recoveryKekIV',
      type: IsarType.string,
    ),
    r'recoveryPhraseHash': PropertySchema(
      id: 9,
      name: r'recoveryPhraseHash',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wrappedKEK': PropertySchema(
      id: 11,
      name: r'wrappedKEK',
      type: IsarType.string,
    ),
    r'wrappedKEKByRecovery': PropertySchema(
      id: 12,
      name: r'wrappedKEKByRecovery',
      type: IsarType.string,
    )
  },
  estimateSize: _userProfileEstimateSize,
  serialize: _userProfileSerialize,
  deserialize: _userProfileDeserialize,
  deserializeProp: _userProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileGetId,
  getLinks: _userProfileGetLinks,
  attach: _userProfileAttach,
  version: '3.1.0+1',
);

int _userProfileEstimateSize(
  UserProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.autoBackupFrequency.length * 3;
  bytesCount += 3 + object.kekIV.length * 3;
  bytesCount += 3 + object.pinHash.length * 3;
  bytesCount += 3 + object.pinSalt.length * 3;
  bytesCount += 3 + object.recoveryKekIV.length * 3;
  bytesCount += 3 + object.recoveryPhraseHash.length * 3;
  bytesCount += 3 + object.wrappedKEK.length * 3;
  bytesCount += 3 + object.wrappedKEKByRecovery.length * 3;
  return bytesCount;
}

void _userProfileSerialize(
  UserProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoBackupEnabled);
  writer.writeString(offsets[1], object.autoBackupFrequency);
  writer.writeBool(offsets[2], object.biometricEnabled);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.kekIV);
  writer.writeDateTime(offsets[5], object.lastBackupDate);
  writer.writeString(offsets[6], object.pinHash);
  writer.writeString(offsets[7], object.pinSalt);
  writer.writeString(offsets[8], object.recoveryKekIV);
  writer.writeString(offsets[9], object.recoveryPhraseHash);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeString(offsets[11], object.wrappedKEK);
  writer.writeString(offsets[12], object.wrappedKEKByRecovery);
}

UserProfile _userProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfile();
  object.autoBackupEnabled = reader.readBool(offsets[0]);
  object.autoBackupFrequency = reader.readString(offsets[1]);
  object.biometricEnabled = reader.readBool(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.kekIV = reader.readString(offsets[4]);
  object.lastBackupDate = reader.readDateTimeOrNull(offsets[5]);
  object.pinHash = reader.readString(offsets[6]);
  object.pinSalt = reader.readString(offsets[7]);
  object.recoveryKekIV = reader.readString(offsets[8]);
  object.recoveryPhraseHash = reader.readString(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  object.wrappedKEK = reader.readString(offsets[11]);
  object.wrappedKEKByRecovery = reader.readString(offsets[12]);
  return object;
}

P _userProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileGetId(UserProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileGetLinks(UserProfile object) {
  return [];
}

void _userProfileAttach(
    IsarCollection<dynamic> col, Id id, UserProfile object) {
  object.id = id;
}

extension UserProfileQueryWhereSort
    on QueryBuilder<UserProfile, UserProfile, QWhere> {
  QueryBuilder<UserProfile, UserProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileQueryWhere
    on QueryBuilder<UserProfile, UserProfile, QWhereClause> {
  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idBetween(
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

extension UserProfileQueryFilter
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {
  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoBackupEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoBackupFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'autoBackupFrequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'autoBackupFrequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoBackupFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      autoBackupFrequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'autoBackupFrequency',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      biometricEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biometricEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      kekIVGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kekIV',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kekIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> kekIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kekIV',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      kekIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kekIV',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastBackupDate',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastBackupDate',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      lastBackupDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBackupDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinSaltGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinSalt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinSaltStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinSalt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> pinSaltMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinSalt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinSaltIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinSalt',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      pinSaltIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinSalt',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recoveryKekIV',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recoveryKekIV',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recoveryKekIV',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryKekIV',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryKekIVIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recoveryKekIV',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recoveryPhraseHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recoveryPhraseHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recoveryPhraseHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryPhraseHash',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      recoveryPhraseHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recoveryPhraseHash',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrappedKEK',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrappedKEK',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrappedKEK',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrappedKEK',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrappedKEK',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrappedKEKByRecovery',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrappedKEKByRecovery',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrappedKEKByRecovery',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrappedKEKByRecovery',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
      wrappedKEKByRecoveryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrappedKEKByRecovery',
        value: '',
      ));
    });
  }
}

extension UserProfileQueryObject
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {}

extension UserProfileQueryLinks
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {}

extension UserProfileQuerySortBy
    on QueryBuilder<UserProfile, UserProfile, QSortBy> {
  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByAutoBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByAutoBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByAutoBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupFrequency', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByAutoBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupFrequency', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByBiometricEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByBiometricEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByKekIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kekIV', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByKekIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kekIV', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByLastBackupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByRecoveryKekIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryKekIV', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByRecoveryKekIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryKekIV', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByRecoveryPhraseHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryPhraseHash', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByRecoveryPhraseHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryPhraseHash', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByWrappedKEK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEK', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByWrappedKEKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEK', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByWrappedKEKByRecovery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEKByRecovery', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      sortByWrappedKEKByRecoveryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEKByRecovery', Sort.desc);
    });
  }
}

extension UserProfileQuerySortThenBy
    on QueryBuilder<UserProfile, UserProfile, QSortThenBy> {
  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByAutoBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByAutoBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByAutoBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupFrequency', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByAutoBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupFrequency', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByBiometricEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByBiometricEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biometricEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByKekIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kekIV', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByKekIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kekIV', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByLastBackupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinHash', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByPinSalt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByPinSaltDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinSalt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByRecoveryKekIV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryKekIV', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByRecoveryKekIVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryKekIV', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByRecoveryPhraseHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryPhraseHash', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByRecoveryPhraseHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryPhraseHash', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByWrappedKEK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEK', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByWrappedKEKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEK', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByWrappedKEKByRecovery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEKByRecovery', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
      thenByWrappedKEKByRecoveryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrappedKEKByRecovery', Sort.desc);
    });
  }
}

extension UserProfileQueryWhereDistinct
    on QueryBuilder<UserProfile, UserProfile, QDistinct> {
  QueryBuilder<UserProfile, UserProfile, QDistinct>
      distinctByAutoBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoBackupEnabled');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
      distinctByAutoBackupFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoBackupFrequency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
      distinctByBiometricEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biometricEnabled');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByKekIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kekIV', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBackupDate');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByPinHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByPinSalt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinSalt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByRecoveryKekIV(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recoveryKekIV',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
      distinctByRecoveryPhraseHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recoveryPhraseHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByWrappedKEK(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrappedKEK', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
      distinctByWrappedKEKByRecovery({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrappedKEKByRecovery',
          caseSensitive: caseSensitive);
    });
  }
}

extension UserProfileQueryProperty
    on QueryBuilder<UserProfile, UserProfile, QQueryProperty> {
  QueryBuilder<UserProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfile, bool, QQueryOperations>
      autoBackupEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoBackupEnabled');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations>
      autoBackupFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoBackupFrequency');
    });
  }

  QueryBuilder<UserProfile, bool, QQueryOperations> biometricEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biometricEnabled');
    });
  }

  QueryBuilder<UserProfile, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> kekIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kekIV');
    });
  }

  QueryBuilder<UserProfile, DateTime?, QQueryOperations>
      lastBackupDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupDate');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> pinHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinHash');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> pinSaltProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinSalt');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> recoveryKekIVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recoveryKekIV');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations>
      recoveryPhraseHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recoveryPhraseHash');
    });
  }

  QueryBuilder<UserProfile, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> wrappedKEKProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrappedKEK');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations>
      wrappedKEKByRecoveryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrappedKEKByRecovery');
    });
  }
}
