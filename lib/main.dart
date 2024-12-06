import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF64B5F6),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
          ),
        ),
      ),
      home: const ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> reminders = [
    Reminder(title: 'Buy groceries', isCompleted: false),
    Reminder(title: 'Call mom', isCompleted: true),
    Reminder(title: 'Finish project', isCompleted: false),
    Reminder(title: 'Go for a run', isCompleted: false),
  ];

  final TextEditingController _textController = TextEditingController();

  void _toggleReminder(int index) {
    setState(() {
      reminders[index].isCompleted = !reminders[index].isCompleted;
    });
  }

  void _addReminder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Enter reminder text'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    reminders.add(Reminder(title: _textController.text, isCompleted: false));
                  });
                  _textController.clear();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 64, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 16),
                  const Text(
                    'No reminders yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a reminder',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: reminders[index].isCompleted,
                      onChanged: (bool? value) {
                        _toggleReminder(index);
                      },
                      activeColor: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(
                      reminders[index].title,
                      style: TextStyle(
                        decoration: reminders[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: reminders[index].isCompleted
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    trailing: reminders[index].isCompleted
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              _removeReminder(index);
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class Reminder {
  String title;
  bool isCompleted;

  Reminder({required this.title, required this.isCompleted});
}
