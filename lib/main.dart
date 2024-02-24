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
      home: TodoApp(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
      ),
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
        //TODO 作成画面に遷移
        onPressed: () {},
        tooltip: "Create ToDo",
        child: const Icon(Icons.add),
      ),
    );
  }
}
