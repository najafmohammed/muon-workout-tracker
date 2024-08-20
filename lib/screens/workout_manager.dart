import 'package:flutter/material.dart';

class ExerciseManager extends StatefulWidget {
  const ExerciseManager({super.key});

  @override
  State<ExerciseManager> createState() => _ExerciseManagerState();
}

TextEditingController _textController = TextEditingController();

class _ExerciseManagerState extends State<ExerciseManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Exercises'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
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
              child: ListView.builder(
                  itemCount: 10, // Number of items in the list
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Item ${index + 1}'),
                        subtitle: Text('Subtitle for item ${index + 1}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // Handle more action
                              },
                            ),
                          ],
                        ));
                  }),
            )
          ],
        ));
  }
}
