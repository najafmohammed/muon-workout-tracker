// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSplitCollection on Isar {
  IsarCollection<Split> get splits => this.collection();
}

const SplitSchema = CollectionSchema(
  name: r'Split',
  id: -746995213775774434,
  properties: {
    r'isCompletedToday': PropertySchema(
      id: 0,
      name: r'isCompletedToday',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'nextIndex': PropertySchema(
      id: 2,
      name: r'nextIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _splitEstimateSize,
  serialize: _splitSerialize,
  deserialize: _splitDeserialize,
  deserializeProp: _splitDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'routines': LinkSchema(
      id: -1054804630021933043,
      name: r'routines',
      target: r'Routine',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _splitGetId,
  getLinks: _splitGetLinks,
  attach: _splitAttach,
  version: '3.1.0+1',
);

int _splitEstimateSize(
  Split object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _splitSerialize(
  Split object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isCompletedToday);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.nextIndex);
}

Split _splitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Split();
  object.id = id;
  object.isCompletedToday = reader.readBool(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.nextIndex = reader.readLong(offsets[2]);
  return object;
}

P _splitDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _splitGetId(Split object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _splitGetLinks(Split object) {
  return [object.routines];
}

void _splitAttach(IsarCollection<dynamic> col, Id id, Split object) {
  object.id = id;
  object.routines.attach(col, col.isar.collection<Routine>(), r'routines', id);
}

extension SplitQueryWhereSort on QueryBuilder<Split, Split, QWhere> {
  QueryBuilder<Split, Split, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SplitQueryWhere on QueryBuilder<Split, Split, QWhereClause> {
  QueryBuilder<Split, Split, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Split, Split, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Split, Split, QAfterWhereClause> idBetween(
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

extension SplitQueryFilter on QueryBuilder<Split, Split, QFilterCondition> {
  QueryBuilder<Split, Split, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Split, Split, QAfterFilterCondition> isCompletedTodayEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompletedToday',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nextIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nextIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nextIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> nextIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SplitQueryObject on QueryBuilder<Split, Split, QFilterCondition> {}

extension SplitQueryLinks on QueryBuilder<Split, Split, QFilterCondition> {
  QueryBuilder<Split, Split, QAfterFilterCondition> routines(
      FilterQuery<Routine> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'routines');
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'routines', length, true, length, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'routines', 0, true, 0, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'routines', 0, false, 999999, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'routines', 0, true, length, include);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'routines', length, include, 999999, true);
    });
  }

  QueryBuilder<Split, Split, QAfterFilterCondition> routinesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'routines', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SplitQuerySortBy on QueryBuilder<Split, Split, QSortBy> {
  QueryBuilder<Split, Split, QAfterSortBy> sortByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByIsCompletedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByNextIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextIndex', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> sortByNextIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextIndex', Sort.desc);
    });
  }
}

extension SplitQuerySortThenBy on QueryBuilder<Split, Split, QSortThenBy> {
  QueryBuilder<Split, Split, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByIsCompletedTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedToday', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByNextIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextIndex', Sort.asc);
    });
  }

  QueryBuilder<Split, Split, QAfterSortBy> thenByNextIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextIndex', Sort.desc);
    });
  }
}

extension SplitQueryWhereDistinct on QueryBuilder<Split, Split, QDistinct> {
  QueryBuilder<Split, Split, QDistinct> distinctByIsCompletedToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompletedToday');
    });
  }

  QueryBuilder<Split, Split, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Split, Split, QDistinct> distinctByNextIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextIndex');
    });
  }
}

extension SplitQueryProperty on QueryBuilder<Split, Split, QQueryProperty> {
  QueryBuilder<Split, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Split, bool, QQueryOperations> isCompletedTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompletedToday');
    });
  }

  QueryBuilder<Split, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Split, int, QQueryOperations> nextIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextIndex');
    });
  }
}
