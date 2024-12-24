import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/database/providers/user_settings_provider.dart';

class SelectCurrentSplit extends ConsumerStatefulWidget {
  const SelectCurrentSplit({Key? key}) : super(key: key);

  @override
  _SelectCurrentSplitScreenState createState() =>
      _SelectCurrentSplitScreenState();
}

class _SelectCurrentSplitScreenState extends ConsumerState<SelectCurrentSplit> {
  Split? selectedSplit;
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentSplit(); // Load the current split on screen load
  }

  Future<void> _loadCurrentSplit() async {
    final userSettingsRepo = ref.read(userSettingsProvider.notifier);

    // Fetch the current split from the user settings and pre-select it
    final currentSettings = await userSettingsRepo.getUserSettings();
    setState(() {
      selectedSplit = currentSettings
          ?.currentSplit.value; // Preselect the split if available
    });
  }

  @override
  Widget build(BuildContext context) {
    final splitRepo = ref.watch(splitProvider); // Watches Split Repository
    final userSettingsRepo = ref.watch(userSettingsProvider
        .notifier); // Watches the UserSettingsRepository StateNotifier

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Current Split'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  nameFilter = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Splits',
                hintText: 'Type to search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Split>>(
              stream: splitRepo.getAllSplitsFiltered(nameFilter: nameFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Splits Found'));
                } else {
                  final splits = snapshot.data!;

                  return ListView.builder(
                    itemCount: splits.length,
                    itemBuilder: (context, index) {
                      final split = splits[index];
                      final isSelected = selectedSplit?.id == split.id;
                      final lSplit = split.routines.length;
                      return ListTile(
                        leading: const Icon(Icons.workspaces_filled),
                        title: Text(
                          split.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '$lSplit routines found',
                          style: TextStyle(
                              color: lSplit == 0 ? Colors.red : Colors.white),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 28.0,
                              )
                            : null, // Show the check icon only if selected
                        onTap: () {
                          setState(() {
                            selectedSplit = split;
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: selectedSplit != null
          ? FloatingActionButton.extended(
              onPressed: () async {
                if (selectedSplit != null) {
                  await userSettingsRepo.updateCurrentSplit(selectedSplit!);
                  Navigator.pop(context);
                }
              },
              label: const Text('Set as Current Split'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
