import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/constants/styles.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/models/user_settings.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';
import 'package:muon_workout_tracker/database/repository/split_repository.dart';
import 'package:muon_workout_tracker/screens/select_current_split.dart';
import 'package:muon_workout_tracker/screens/split_form.dart';
import 'package:muon_workout_tracker/shared/wrappers/card_wrapper.dart';

class WorkoutInfoCard extends ConsumerStatefulWidget {
  const WorkoutInfoCard({super.key});

  @override
  WorkoutInfoCardState createState() => WorkoutInfoCardState();
}

class WorkoutInfoCardState extends ConsumerState<WorkoutInfoCard> {
  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsProvider);
    final split = ref.watch(splitProvider);

    return userSettings == null
        ? const Center(child: CircularProgressIndicator())
        : userSettings.currentSplit.value != null
            ? _buildCurrentSplitInfo(context, userSettings, split)
            : _buildNoSplitInfo(context, split);
  }

  Widget _buildCurrentSplitInfo(
      BuildContext context, UserSettings userSettings, SplitRepository split) {
    final String name =
        userSettings.currentSplit.value?.name ?? 'No split found';
    return Column(
      children: [
        CardWrapper(children: [
          const Row(
            children: [
              Text(
                "Current Split",
                style: AppTextStyle.large,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(name, style: AppTextStyle.medium),
          const SizedBox(height: 10),
          CurrentSplit(split: split),
        ]),
      ],
    );
  }

  Widget _buildNoSplitInfo(BuildContext context, SplitRepository split) {
    return CurrentSplit(split: split);
  }
}

class CurrentSplit extends ConsumerWidget {
  const CurrentSplit({super.key, required this.split});

  final SplitRepository split;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettingsRepo = ref.watch(userSettingsProvider.notifier);

    return FutureBuilder<List<Split>>(
      future: split.getAllSplits(), // Fetch the list of splits
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          bool hasSplits = snapshot.data!.isNotEmpty;
          return ElevatedButton.icon(
            onPressed: () async {
              if (hasSplits) {
                final selectedSplit = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectCurrentSplit()),
                );
                if (selectedSplit != null) {
                  await userSettingsRepo.updateCurrentSplit(selectedSplit);
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SplitForm()),
                );
              }
            },
            icon: const Icon(Icons.add),
            label:
                Text(hasSplits ? 'Select current split' : 'Create a new split'),
          );
        } else {
          return const Center(child: Text('No splits found.'));
        }
      },
    );
  }
}
