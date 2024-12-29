// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTotalStatsCollection on Isar {
  IsarCollection<TotalStats> get totalStats => this.collection();
}

const TotalStatsSchema = CollectionSchema(
  name: r'TotalStats',
  id: 4201312623362832798,
  properties: {
    r'currentWeekTime': PropertySchema(
      id: 0,
      name: r'currentWeekTime',
      type: IsarType.long,
    ),
    r'currentWeekVolume': PropertySchema(
      id: 1,
      name: r'currentWeekVolume',
      type: IsarType.double,
    ),
    r'currentWeekWorkouts': PropertySchema(
      id: 2,
      name: r'currentWeekWorkouts',
      type: IsarType.long,
    ),
    r'lastWeekTime': PropertySchema(
      id: 3,
      name: r'lastWeekTime',
      type: IsarType.long,
    ),
    r'lastWeekVolume': PropertySchema(
      id: 4,
      name: r'lastWeekVolume',
      type: IsarType.double,
    ),
    r'lastWeekWorkouts': PropertySchema(
      id: 5,
      name: r'lastWeekWorkouts',
      type: IsarType.long,
    ),
    r'totalTime': PropertySchema(
      id: 6,
      name: r'totalTime',
      type: IsarType.long,
    ),
    r'totalVolume': PropertySchema(
      id: 7,
      name: r'totalVolume',
      type: IsarType.double,
    ),
    r'totalWorkouts': PropertySchema(
      id: 8,
      name: r'totalWorkouts',
      type: IsarType.long,
    )
  },
  estimateSize: _totalStatsEstimateSize,
  serialize: _totalStatsSerialize,
  deserialize: _totalStatsDeserialize,
  deserializeProp: _totalStatsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _totalStatsGetId,
  getLinks: _totalStatsGetLinks,
  attach: _totalStatsAttach,
  version: '3.1.0+1',
);

int _totalStatsEstimateSize(
  TotalStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _totalStatsSerialize(
  TotalStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentWeekTime);
  writer.writeDouble(offsets[1], object.currentWeekVolume);
  writer.writeLong(offsets[2], object.currentWeekWorkouts);
  writer.writeLong(offsets[3], object.lastWeekTime);
  writer.writeDouble(offsets[4], object.lastWeekVolume);
  writer.writeLong(offsets[5], object.lastWeekWorkouts);
  writer.writeLong(offsets[6], object.totalTime);
  writer.writeDouble(offsets[7], object.totalVolume);
  writer.writeLong(offsets[8], object.totalWorkouts);
}

TotalStats _totalStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TotalStats();
  object.currentWeekTime = reader.readLong(offsets[0]);
  object.currentWeekVolume = reader.readDouble(offsets[1]);
  object.currentWeekWorkouts = reader.readLong(offsets[2]);
  object.id = id;
  object.lastWeekTime = reader.readLong(offsets[3]);
  object.lastWeekVolume = reader.readDouble(offsets[4]);
  object.lastWeekWorkouts = reader.readLong(offsets[5]);
  object.totalTime = reader.readLong(offsets[6]);
  object.totalVolume = reader.readDouble(offsets[7]);
  object.totalWorkouts = reader.readLong(offsets[8]);
  return object;
}

P _totalStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _totalStatsGetId(TotalStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _totalStatsGetLinks(TotalStats object) {
  return [];
}

void _totalStatsAttach(IsarCollection<dynamic> col, Id id, TotalStats object) {
  object.id = id;
}

extension TotalStatsQueryWhereSort
    on QueryBuilder<TotalStats, TotalStats, QWhere> {
  QueryBuilder<TotalStats, TotalStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TotalStatsQueryWhere
    on QueryBuilder<TotalStats, TotalStats, QWhereClause> {
  QueryBuilder<TotalStats, TotalStats, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TotalStats, TotalStats, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterWhereClause> idBetween(
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

extension TotalStatsQueryFilter
    on QueryBuilder<TotalStats, TotalStats, QFilterCondition> {
  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentWeekTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentWeekVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekWorkoutsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekWorkoutsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekWorkoutsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      currentWeekWorkoutsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentWeekWorkouts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWeekTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWeekTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWeekVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWeekVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekWorkoutsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekWorkoutsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekWorkoutsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWeekWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      lastWeekWorkoutsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWeekWorkouts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> totalTimeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> totalTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition> totalTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalWorkoutsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalWorkoutsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalWorkoutsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalWorkouts',
        value: value,
      ));
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterFilterCondition>
      totalWorkoutsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalWorkouts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TotalStatsQueryObject
    on QueryBuilder<TotalStats, TotalStats, QFilterCondition> {}

extension TotalStatsQueryLinks
    on QueryBuilder<TotalStats, TotalStats, QFilterCondition> {}

extension TotalStatsQuerySortBy
    on QueryBuilder<TotalStats, TotalStats, QSortBy> {
  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByCurrentWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByCurrentWeekTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByCurrentWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByCurrentWeekVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByCurrentWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByCurrentWeekWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekWorkouts', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByLastWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByLastWeekTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByLastWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByLastWeekVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByLastWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      sortByLastWeekWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekWorkouts', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> sortByTotalWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWorkouts', Sort.desc);
    });
  }
}

extension TotalStatsQuerySortThenBy
    on QueryBuilder<TotalStats, TotalStats, QSortThenBy> {
  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByCurrentWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByCurrentWeekTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByCurrentWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByCurrentWeekVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByCurrentWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByCurrentWeekWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentWeekWorkouts', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByLastWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByLastWeekTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByLastWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByLastWeekVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByLastWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy>
      thenByLastWeekWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWeekWorkouts', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTime', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTime', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWorkouts', Sort.asc);
    });
  }

  QueryBuilder<TotalStats, TotalStats, QAfterSortBy> thenByTotalWorkoutsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalWorkouts', Sort.desc);
    });
  }
}

extension TotalStatsQueryWhereDistinct
    on QueryBuilder<TotalStats, TotalStats, QDistinct> {
  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByCurrentWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentWeekTime');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct>
      distinctByCurrentWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentWeekVolume');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct>
      distinctByCurrentWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentWeekWorkouts');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByLastWeekTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWeekTime');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByLastWeekVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWeekVolume');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByLastWeekWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWeekWorkouts');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByTotalTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTime');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolume');
    });
  }

  QueryBuilder<TotalStats, TotalStats, QDistinct> distinctByTotalWorkouts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalWorkouts');
    });
  }
}

extension TotalStatsQueryProperty
    on QueryBuilder<TotalStats, TotalStats, QQueryProperty> {
  QueryBuilder<TotalStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations> currentWeekTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentWeekTime');
    });
  }

  QueryBuilder<TotalStats, double, QQueryOperations>
      currentWeekVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentWeekVolume');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations>
      currentWeekWorkoutsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentWeekWorkouts');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations> lastWeekTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWeekTime');
    });
  }

  QueryBuilder<TotalStats, double, QQueryOperations> lastWeekVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWeekVolume');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations> lastWeekWorkoutsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWeekWorkouts');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations> totalTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTime');
    });
  }

  QueryBuilder<TotalStats, double, QQueryOperations> totalVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolume');
    });
  }

  QueryBuilder<TotalStats, int, QQueryOperations> totalWorkoutsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalWorkouts');
    });
  }
}
