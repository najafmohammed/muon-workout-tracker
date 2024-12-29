import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/dropdown_options.dart';
import 'package:muon_workout_tracker/database/models/exercise.dart';

final muscleGroupsProvider = Provider<List<DropdownOption<MuscleGroup>>>((ref) {
  return [
    DropdownOption(name: 'Abs', value: MuscleGroup.abs),
    DropdownOption(name: 'Biceps', value: MuscleGroup.biceps),
    DropdownOption(name: 'Calves', value: MuscleGroup.calves),
    DropdownOption(name: 'Cardio', value: MuscleGroup.cardio),
    DropdownOption(name: 'Chest', value: MuscleGroup.chest),
    DropdownOption(name: 'Forearms', value: MuscleGroup.forearms),
    DropdownOption(name: 'Full Body', value: MuscleGroup.fullBody),
    DropdownOption(name: 'Glutes', value: MuscleGroup.glutes),
    DropdownOption(name: 'Hamstrings', value: MuscleGroup.hamstrings),
    DropdownOption(name: 'Lats', value: MuscleGroup.lats),
    DropdownOption(name: 'Legs', value: MuscleGroup.legs),
    DropdownOption(name: 'Lower Back', value: MuscleGroup.lowerBack),
    DropdownOption(name: 'Neck', value: MuscleGroup.neck),
    DropdownOption(name: 'Shoulders', value: MuscleGroup.shoulders),
    DropdownOption(name: 'Traps', value: MuscleGroup.traps),
    DropdownOption(name: 'Triceps', value: MuscleGroup.triceps),
    DropdownOption(name: 'Upper Back', value: MuscleGroup.upperBack),
    DropdownOption(name: 'Other', value: MuscleGroup.other),
  ];
});
