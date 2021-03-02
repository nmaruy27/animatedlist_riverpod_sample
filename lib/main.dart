import 'package:animatedlist_riverpod_sample/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/all.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoList = useProvider(todoListProvider.state);
    return Scaffold(appBar: AppBar(title: Text('Todo[${todoList.length}]')), body: TodoListView());
  }
}

class TodoListView extends HookWidget {
  TodoListView({Key key}) : super(key: key);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final todoList = useProvider(todoListProvider.state);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: todoList.length,
      itemBuilder: (context, index, animation) =>
          _buildItem(todoList[index], animation, index, context),
    );
  }

  Slidable _buildItem(Todo todo, Animation<double> animation, int index, BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: SizeTransition(
          sizeFactor: animation,
          axis: Axis.vertical,
          child: ListTile(title: Text(todo.description), subtitle: Text(todo.id), onTap: () => {})),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '削除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _listKey.currentState.removeItem(
                index, (context, animation) => _buildItem(todo, animation, index, context),
                duration: Duration(milliseconds: 200));
            _removeItem(context, todo);
          },
        ),
      ],
    );
  }

  void _removeItem(BuildContext context, Todo todo) async {
    await Future.delayed(
        Duration(milliseconds: 200), () => context.read(todoListProvider).remove(todo));
  }
}
