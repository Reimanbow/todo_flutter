import "package:flutter/material.dart";

void main() => runApp(const MyApp());

// タイトルと詳細な説明
class Todo {
  final String _title;
  final String _description;

  const Todo(
    this._title,
    this._description,
  );

  String get getTitle => _title;
  String get getDescription => _description;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const TodoApp(),
    );
  }
}

// Todo一覧画面
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];

  // Todo作成画面に遷移
  Future<void> _navigateCreateTodoScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTodoScreen()),
    );

    setState(() {
      todos.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
      ),

      // 横にスライドすることでTodoを削除する
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
            key: Key(todo.getTitle),
            onDismissed: (direction) {
              setState(() {
                todos.removeAt(index);
              });

              // 削除の通知
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${todo.getTitle} delete")));
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text("${todo.getTitle}"),
              //TODO 詳細画面に遷移
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // 作成画面に遷移
        onPressed: () => _navigateCreateTodoScreen(context),
        tooltip: "Create ToDo",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create ToDo"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _TodoTextField(
              controller: _titleController,
              label: "Title",
            ),
            _TodoTextField(
              controller: _descriptionController,
              label: "description",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final todo = Todo(
                        _titleController.text, _descriptionController.text);
                    Navigator.pop(context, todo);
                  }
                },
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Todo作成時の入力フィールド
class _TodoTextField extends StatelessWidget {
  const _TodoTextField({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Fill $label";
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
