import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod/todo_prov.dart';
import 'todo_item.dart';

class TodoList extends ConsumerWidget {
  const TodoList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListFilteredProv);

    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          for (var i = 0; i < todos.length; i++) ...[
            if (i > 0) const Divider(height: 0),
            Dismissible(
              key: ValueKey(todos[i].id),
              onDismissed: (_) {
                ref.read(todoListStNotProv.notifier).remove(todos[i]);
              },
              child: ProviderScope(
                overrides: [
                  currentTodo.overrideWithValue(todos[i]),
                ],
                child: const TodoItem(),
              ),
            )
          ],
        ]),
      ),
    );
  }
}
