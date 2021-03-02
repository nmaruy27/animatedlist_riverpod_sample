import 'package:hooks_riverpod/all.dart';

final todoListProvider = StateNotifierProvider<TodoList>((ref) {
  return TodoList([
    Todo(id: '0', description: 'Todo1'),
    Todo(id: '1', description: 'Todo2'),
    Todo(id: '2', description: 'Todo3'),
  ]);
});

class Todo {
  Todo({
    this.id,
    this.description,
  });

  final String id;
  final String description;
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(description: description),
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
