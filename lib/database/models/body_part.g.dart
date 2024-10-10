// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_part.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBodyPartCollection on Isar {
  IsarCollection<BodyPart> get bodyParts => this.collection();
}

const BodyPartSchema = CollectionSchema(
  name: r'BodyPart',
  id: 5079964848560096991,
  properties: {
    r'duration': PropertySchema(
      id: 0,
      name: r'duration',
      type: IsarType.long,
    ),
    r'exerciseCount': PropertySchema(
      id: 1,
      name: r'exerciseCount',
      type: IsarType.long,
    ),
    r'muscleGroup': PropertySchema(
      id: 2,
      name: r'muscleGroup',
      type: IsarType.byte,
      enumMap: _BodyPartmuscleGroupEnumValueMap,
    ),
    r'totalVolume': PropertySchema(
      id: 3,
      name: r'totalVolume',
      type: IsarType.double,
    )
  },
  estimateSize: _bodyPartEstimateSize,
  serialize: _bodyPartSerialize,
  deserialize: _bodyPartDeserialize,
  deserializeProp: _bodyPartDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'exercises': LinkSchema(
      id: 8882508454070240962,
      name: r'exercises',
      target: r'Exercise',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _bodyPartGetId,
  getLinks: _bodyPartGetLinks,
  attach: _bodyPartAttach,
  version: '3.1.0+1',
);

int _bodyPartEstimateSize(
  BodyPart object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _bodyPartSerialize(
  BodyPart object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.duration);
  writer.writeLong(offsets[1], object.exerciseCount);
  writer.writeByte(offsets[2], object.muscleGroup.index);
  writer.writeDouble(offsets[3], object.totalVolume);
}

BodyPart _bodyPartDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BodyPart(
    duration: reader.readLongOrNull(offsets[0]) ?? 0,
    exerciseCount: reader.readLongOrNull(offsets[1]) ?? 0,
    muscleGroup:
        _BodyPartmuscleGroupValueEnumMap[reader.readByteOrNull(offsets[2])] ??
            MuscleGroup.abs,
    totalVolume: reader.readDoubleOrNull(offsets[3]) ?? 0,
  );
  object.id = id;
  return object;
}

P _bodyPartDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (_BodyPartmuscleGroupValueEnumMap[reader.readByteOrNull(offset)] ??
          MuscleGroup.abs) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BodyPartmuscleGroupEnumValueMap = {
  'abs': 0,
  'biceps': 1,
  'calves': 2,
  'cardio': 3,
  'chest': 4,
  'forearms': 5,
  'fullBody': 6,
  'glutes': 7,
  'hamstrings': 8,
  'lats': 9,
  'legs': 10,
  'lowerBack': 11,
  'neck': 12,
  'shoulders': 13,
  'traps': 14,
  'triceps': 15,
  'upperBack': 16,
  'other': 17,
};
const _BodyPartmuscleGroupValueEnumMap = {
  0: MuscleGroup.abs,
  1: MuscleGroup.biceps,
  2: MuscleGroup.calves,
  3: MuscleGroup.cardio,
  4: MuscleGroup.chest,
  5: MuscleGroup.forearms,
  6: MuscleGroup.fullBody,
  7: MuscleGroup.glutes,
  8: MuscleGroup.hamstrings,
  9: MuscleGroup.lats,
  10: MuscleGroup.legs,
  11: MuscleGroup.lowerBack,
  12: MuscleGroup.neck,
  13: MuscleGroup.shoulders,
  14: MuscleGroup.traps,
  15: MuscleGroup.triceps,
  16: MuscleGroup.upperBack,
  17: MuscleGroup.other,
};

Id _bodyPartGetId(BodyPart object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bodyPartGetLinks(BodyPart object) {
  return [object.exercises];
}

void _bodyPartAttach(IsarCollection<dynamic> col, Id id, BodyPart object) {
  object.id = id;
  object.exercises
      .attach(col, col.isar.collection<Exercise>(), r'exercises', id);
}

extension BodyPartQueryWhereSort on QueryBuilder<BodyPart, BodyPart, QWhere> {
  QueryBuilder<BodyPart, BodyPart, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BodyPartQueryWhere on QueryBuilder<BodyPart, BodyPart, QWhereClause> {
  QueryBuilder<BodyPart, BodyPart, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BodyPart, BodyPart, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterWhereClause> idBetween(
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

extension BodyPartQueryFilter
    on QueryBuilder<BodyPart, BodyPart, QFilterCondition> {
  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> durationEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> exerciseCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exerciseCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> exerciseCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> exerciseCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> muscleGroupEqualTo(
      MuscleGroup value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      muscleGroupGreaterThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> muscleGroupLessThan(
    MuscleGroup value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> muscleGroupBetween(
    MuscleGroup lower,
    MuscleGroup upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> totalVolumeEqualTo(
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> totalVolumeLessThan(
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

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> totalVolumeBetween(
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
}

extension BodyPartQueryObject
    on QueryBuilder<BodyPart, BodyPart, QFilterCondition> {}

extension BodyPartQueryLinks
    on QueryBuilder<BodyPart, BodyPart, QFilterCondition> {
  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> exercises(
      FilterQuery<Exercise> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'exercises');
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exercisesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', length, true, length, true);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition> exercisesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, true, 0, true);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exercisesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, false, 999999, true);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exercisesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, true, length, include);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exercisesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', length, include, 999999, true);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterFilterCondition>
      exercisesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'exercises', lower, includeLower, upper, includeUpper);
    });
  }
}

extension BodyPartQuerySortBy on QueryBuilder<BodyPart, BodyPart, QSortBy> {
  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByExerciseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseCount', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByExerciseCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseCount', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> sortByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }
}

extension BodyPartQuerySortThenBy
    on QueryBuilder<BodyPart, BodyPart, QSortThenBy> {
  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByExerciseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseCount', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByExerciseCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseCount', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByMuscleGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroup', Sort.desc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.asc);
    });
  }

  QueryBuilder<BodyPart, BodyPart, QAfterSortBy> thenByTotalVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolume', Sort.desc);
    });
  }
}

extension BodyPartQueryWhereDistinct
    on QueryBuilder<BodyPart, BodyPart, QDistinct> {
  QueryBuilder<BodyPart, BodyPart, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<BodyPart, BodyPart, QDistinct> distinctByExerciseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseCount');
    });
  }

  QueryBuilder<BodyPart, BodyPart, QDistinct> distinctByMuscleGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleGroup');
    });
  }

  QueryBuilder<BodyPart, BodyPart, QDistinct> distinctByTotalVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolume');
    });
  }
}

extension BodyPartQueryProperty
    on QueryBuilder<BodyPart, BodyPart, QQueryProperty> {
  QueryBuilder<BodyPart, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BodyPart, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<BodyPart, int, QQueryOperations> exerciseCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseCount');
    });
  }

  QueryBuilder<BodyPart, MuscleGroup, QQueryOperations> muscleGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroup');
    });
  }

  QueryBuilder<BodyPart, double, QQueryOperations> totalVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolume');
    });
  }
}
