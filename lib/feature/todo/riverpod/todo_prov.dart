import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/todo_model.dart';
import 'todo_state.dart';

final todoListStNotProv =
    StateNotifierProvider<TodoListStNot, List<Todo>>((ref) {
  return TodoListStNot(const [
    Todo(id: 'todo-0', description: 'hi'),
    Todo(id: 'todo-1', description: 'hello'),
    Todo(id: 'todo-2', description: 'bonjour'),
  ]);
});

final todoListFilterStProv =
    StateProvider<TodoListFilter>((_) => TodoListFilter.all);

final todoListUncompletedCountProv = Provider<int>((ref) {
  return ref.watch(todoListStNotProv).where((todo) => !todo.completed).length;
});

final todoListFilteredProv = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilterStProv);
  final todos = ref.watch(todoListStNotProv);
  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

final currentTodo = Provider<Todo>((ref) => throw UnimplementedError());
