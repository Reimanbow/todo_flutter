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
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
          ),
        ),
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

    if (!context.mounted) return;

    setState(() {
      todos.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ToDo List",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
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
              title: Text(
                todo.getTitle,
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              // 詳細画面に遷移
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReadTodoScreen(todo: todo)));
              },
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
        title: Text(
          "Create ToDo",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
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
              isMultiline: false,
            ),
            _TodoTextField(
              controller: _descriptionController,
              label: "description",
              isMultiline: true,
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
    required this.isMultiline,
  });

  final TextEditingController controller;
  final String label;
  final bool isMultiline;

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
        keyboardType: isMultiline ? TextInputType.multiline : null,
        maxLines: isMultiline ? null : 1,
      ),
    );
  }
}

class ReadTodoScreen extends StatelessWidget {
  const ReadTodoScreen({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          todo.getTitle,
          style: Theme.of(context).textTheme.titleLarge!,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              todo.getDescription,
              style: Theme.of(context).textTheme.bodyMedium!,
              softWrap: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Return")),
          ),
        ],
      ),
    );
  }
}
