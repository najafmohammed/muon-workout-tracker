import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/screens/split_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';
import 'package:muon_workout_tracker/utils/get_sort_icon.dart';

class SplitManager extends ConsumerStatefulWidget {
  const SplitManager({super.key});

  @override
  SplitManagerState createState() => SplitManagerState();
}

class SplitManagerState extends ConsumerState<SplitManager> {
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  String sortBy = 'name_asc'; // Default sorting option

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final splitRepo = ref.watch(splitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Splits'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplitForm()),
        ),
        label: const Text("Create Split"),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              onChanged: (value) => setState(() => nameFilter = value),
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          // Sort Mechanism
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        sortBy =
                            sortBy == 'name_asc' ? 'name_desc' : 'name_asc';
                      }),
                      child: Chip(
                        backgroundColor: theme.colorScheme.surface,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Name',
                              style:
                                  TextStyle(color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              getSortIcon(sortBy.startsWith('name')
                                  ? sortBy
                                  : 'name_asc'),
                              size: 16,
                              color: sortBy.startsWith('name')
                                  ? theme.colorScheme.primary
                                  : theme.iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.sort, size: 24, color: theme.iconTheme.color),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Split>>(
              stream: splitRepo.getAllSplitsFiltered(
                  nameFilter: nameFilter, sortBy: sortBy),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final splits = snapshot.data ?? [];

                if (splits.isEmpty) {
                  return const Center(child: Text('No Splits Found'));
                }

                return ListView.builder(
                  itemCount: splits.length,
                  itemBuilder: (context, index) {
                    final split = splits[index];
                    final routines = split.routines.toList();
                    final routine = (split.nextIndex >= 0 &&
                            split.nextIndex < routines.length)
                        ? routines[split.nextIndex]
                        : null;

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(split.name),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.next_plan,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            routine != null
                                ? 'Next Routine: ${routine.name}'
                                : 'No routines configured',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplitForm(split: split),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                title: 'Delete Item',
                                message:
                                    'Are you sure you want to delete this item?',
                                onConfirm: () =>
                                    splitRepo.deleteSplit(split.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
