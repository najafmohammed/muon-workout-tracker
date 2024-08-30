import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/models/split.dart';
import 'package:muon_workout_tracker/database/providers/split_provider.dart';
import 'package:muon_workout_tracker/screens/split_form.dart';
import 'package:muon_workout_tracker/shared/confirm_dialog.dart';

class SplitManager extends ConsumerStatefulWidget {
  const SplitManager({super.key});

  @override
  SplitManagerState createState() => SplitManagerState();
}

class SplitManagerState extends ConsumerState<SplitManager> {
  final TextEditingController _textController = TextEditingController();
  String nameFilter = '';
  @override
  Widget build(BuildContext context) {
    final splitRepo = ref.watch(splitProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Splits'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SplitForm()),
              );
            },
            label: const Text("Create Split"),
            icon: const Icon(Icons.add)),
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
                  labelText: 'Search',
                  hintText: 'Search items',
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
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final split = snapshot.data![index];
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(split.name),
                          subtitle: Text(split.isCompletedToday.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplitForm(
                                              split: split,
                                            )),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmDialog(
                                        title: 'Delete Item',
                                        message:
                                            'Are you sure you want to delete this item?',
                                        onConfirm: () {
                                          splitRepo.deleteSplit(split.id);
                                        },
                                        onCancel: () {},
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ));
  }
}
