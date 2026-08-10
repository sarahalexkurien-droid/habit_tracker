import 'package:flutter/material.dart';

void main() {
  runApp(const HabitApp());
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HabitHome(),
    );
  }
}

class HabitHome extends StatefulWidget {
  const HabitHome({super.key});

  @override
  State<HabitHome> createState() => _HabitHomeState();
}

class _HabitHomeState extends State<HabitHome> {
  List<Map<String, dynamic>> habits = [];

  // ADD HABIT
  void addHabit(String name) {
    setState(() {
      habits.add({
        'name': name,
        'done': false,
        'streak': 0,
      });
    });
  }

  // CHECK / UNCHECK HABIT
  void toggleHabit(int index) {
    setState(() {
      habits[index]['streak'] = habits[index]['streak'] ?? 0;

      if (habits[index]['done']) {
        habits[index]['done'] = false;
        habits[index]['streak'] = 0;
      } else {
        habits[index]['done'] = true;
        habits[index]['streak'] =
            (habits[index]['streak'] as int) + 1;
      }
    });
  }

  // EDIT HABIT
  void editHabit(int index) {
    String editedName = habits[index]['name'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Habit"),
          content: TextField(
            controller: TextEditingController(text: editedName),
            onChanged: (value) {
              editedName = value;
            },
            decoration: const InputDecoration(
              labelText: "Habit name",
              hintText: "Enter new name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editedName.trim().isNotEmpty) {
                  setState(() {
                    habits[index]['name'] = editedName.trim();
                  });
                }

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // DELETE HABIT
  void deleteHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Habit?"),
          content: Text(
            'Are you sure you want to delete "${habits[index]['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  habits.removeAt(index);
                });

                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // PLANT GROWTH
  String getPlant(int streak) {
    if (streak >= 7) {
      return "🌳";
    } else if (streak >= 3) {
      return "🌿";
    } else {
      return "🌱";
    }
  }

  // ADD HABIT DIALOG
  void showAddDialog() {
    String newHabit = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Habit"),
          content: TextField(
            onChanged: (value) {
              newHabit = value;
            },
            decoration: const InputDecoration(
              labelText: "Habit name",
              hintText: "Example: Study",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newHabit.trim().isNotEmpty) {
                  addHabit(newHabit.trim());
                }

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌱 Habit Tracker"),
        centerTitle: true,
      ),

      body: habits.isEmpty
          ? const Center(
              child: Text(
                "No habits yet.\nClick + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                int streak = habits[index]['streak'] ?? 0;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Text(
                      getPlant(streak),
                      style: const TextStyle(fontSize: 32),
                    ),

                    title: Text(
                      habits[index]['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      "Streak: $streak day${streak == 1 ? '' : 's'}",
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: habits[index]['done'],
                          onChanged: (value) {
                            toggleHabit(index);
                          },
                        ),

                        // EDIT BUTTON
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: "Edit habit",
                          onPressed: () {
                            editHabit(index);
                          },
                        ),

                        // DELETE BUTTON
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: "Delete habit",
                          onPressed: () {
                            deleteHabit(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}