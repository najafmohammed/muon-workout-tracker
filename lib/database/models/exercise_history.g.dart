// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseHistoryCollection on Isar {
  IsarCollection<ExerciseHistory> get exerciseHistorys => this.collection();
}

const ExerciseHistorySchema = CollectionSchema(
  name: r'ExerciseHistory',
  id: 1208015327924720424,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'sets': PropertySchema(
      id: 1,
      name: r'sets',
      type: IsarType.objectList,
      target: r'ExerciseSet',
    )
  },
  estimateSize: _exerciseHistoryEstimateSize,
  serialize: _exerciseHistorySerialize,
  deserialize: _exerciseHistoryDeserialize,
  deserializeProp: _exerciseHistoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'ExerciseSet': ExerciseSetSchema},
  getId: _exerciseHistoryGetId,
  getLinks: _exerciseHistoryGetLinks,
  attach: _exerciseHistoryAttach,
  version: '3.1.0+1',
);

int _exerciseHistoryEstimateSize(
  ExerciseHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sets.length * 3;
  {
    final offsets = allOffsets[ExerciseSet]!;
    for (var i = 0; i < object.sets.length; i++) {
      final value = object.sets[i];
      bytesCount += ExerciseSetSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _exerciseHistorySerialize(
  ExerciseHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeObjectList<ExerciseSet>(
    offsets[1],
    allOffsets,
    ExerciseSetSchema.serialize,
    object.sets,
  );
}

ExerciseHistory _exerciseHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExerciseHistory();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.sets = reader.readObjectList<ExerciseSet>(
        offsets[1],
        ExerciseSetSchema.deserialize,
        allOffsets,
        ExerciseSet(),
      ) ??
      [];
  return object;
}

P _exerciseHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<ExerciseSet>(
            offset,
            ExerciseSetSchema.deserialize,
            allOffsets,
            ExerciseSet(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _exerciseHistoryGetId(ExerciseHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseHistoryGetLinks(ExerciseHistory object) {
  return [];
}

void _exerciseHistoryAttach(
    IsarCollection<dynamic> col, Id id, ExerciseHistory object) {
  object.id = id;
}

extension ExerciseHistoryQueryWhereSort
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QWhere> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExerciseHistoryQueryWhere
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QWhereClause> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterWhereClause> idBetween(
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

extension ExerciseHistoryQueryFilter
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QFilterCondition> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
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

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sets',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ExerciseHistoryQueryObject
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QFilterCondition> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterFilterCondition>
      setsElement(FilterQuery<ExerciseSet> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sets');
    });
  }
}

extension ExerciseHistoryQueryLinks
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QFilterCondition> {}

extension ExerciseHistoryQuerySortBy
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QSortBy> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension ExerciseHistoryQuerySortThenBy
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QSortThenBy> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExerciseHistory, ExerciseHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ExerciseHistoryQueryWhereDistinct
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QDistinct> {
  QueryBuilder<ExerciseHistory, ExerciseHistory, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension ExerciseHistoryQueryProperty
    on QueryBuilder<ExerciseHistory, ExerciseHistory, QQueryProperty> {
  QueryBuilder<ExerciseHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExerciseHistory, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ExerciseHistory, List<ExerciseSet>, QQueryOperations>
      setsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sets');
    });
  }
}
