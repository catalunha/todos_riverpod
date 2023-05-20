import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod/todo_prov.dart';

class TodoItem extends ConsumerStatefulWidget {
  const TodoItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  bool itemIsFocused = false;
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todo = ref.watch(currentTodo);

    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        onTap: () {
          textEditingController.text = todo.description;
          itemIsFocused = true;
          setState(() {});
        },
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) =>
              ref.read(todoListStNotProv.notifier).toggle(todo.id),
        ),
        title: itemIsFocused
            ? TextField(
                controller: textEditingController,
              )
            : Text(todo.description),
        trailing: itemIsFocused
            ? IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  ref.read(todoListStNotProv.notifier).edit(
                      id: todo.id, description: textEditingController.text);
                  itemIsFocused = false;
                },
              )
            : null,
      ),
    );
  }
}
