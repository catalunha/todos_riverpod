import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature/todo/riverpod/todo_prov.dart';
import 'feature/todo/riverpod/todo_state.dart';
import 'feature/todo/todo_list.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final formKey = GlobalKey<FormState>();
  final newTodoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    newTodoController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    // final todos = ref.watch(todoListFilteredProv);
    newTodoController.text = '';
    return Scaffold(
      body: Column(
        children: [
          const Title(),
          Row(
            children: [
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: newTodoController,
                    decoration: const InputDecoration(
                      labelText: 'What needs to be done?',
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    final formValid = formKey.currentState?.validate() ?? false;
                    if (formValid) {
                      ref
                          .read(todoListStNotProv.notifier)
                          .add(newTodoController.text);
                    }
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          const Toolbar(),
          // if (todos.isNotEmpty) const Divider(height: 0),
          const TodoList(),
        ],
      ),
    );
  }
}

class Toolbar extends ConsumerWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilterStProv);

    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(todoListUncompletedCountProv)} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            message: 'All todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilterStProv.notifier).state =
                  TodoListFilter.all,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                    MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilterStProv.notifier).state =
                  TodoListFilter.active,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            message: 'Only completed todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilterStProv.notifier).state =
                  TodoListFilter.completed,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.completed),
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}
