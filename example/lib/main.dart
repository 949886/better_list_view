import 'package:flutter/material.dart';
import 'package:better_list_view/better_list_view.dart';

void main() {
  Executor().warmUp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test App',
        home: SafeArea(
            child: Scaffold(
          body: Body(key: gkey),
        )));
  }
}

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<ItemData> currentList;

  @override
  void initState() {
    super.initState();
    currentList = listA;
  }

  void swapList() {
    setState(() {
      // currentList.swap(0, 1);
      if (currentList == listA) {
        currentList = listB;
      } else {
        currentList = listA;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutomaticAnimatedListView<ItemData>(
      list: currentList,
      comparator: AnimatedListDiffListComparator<ItemData>(
          sameItem: (a, b) => a.id == b.id,
          sameContent: (a, b) =>
              a.color == b.color && a.fixedHeight == b.fixedHeight),
      itemBuilder: (context, index, data) {
        print(index);
        var item = currentList[index];
        return data.measuring
            ? Container(
                margin: EdgeInsets.all(5), height: item.fixedHeight ?? 60)
            : Item(data: item);
      },
      listController: controller,
      addLongPressReorderable: true,
      detectMoves: true,
    );
  }
}

class Item extends StatelessWidget {
  final ItemData data;

  const Item({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => gkey.currentState?.swapList(),
        child: AnimatedContainer(
            height: data.fixedHeight ?? 60,
            duration: const Duration(milliseconds: 500),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: data.color,
                border: Border.all(color: Colors.black12, width: 0)),
            child: Center(
                child: Text(
              'Item ${data.id}',
              style: TextStyle(fontSize: 16),
            ))));
  }
}

class ItemData {
  final int id;
  final Color color;
  final double? fixedHeight;
  const ItemData(this.id, [this.color = Colors.blue, this.fixedHeight]);
}

// List<ItemData> listA = [
//   ItemData(1, Colors.orange),
//   ItemData(2),
//   ItemData(3),
//   ItemData(4, Colors.cyan),
//   ItemData(5),
//   ItemData(8, Colors.green)
// ];
// List<ItemData> listB = [
//   ItemData(4, Colors.cyan),
//   ItemData(2),
//   ItemData(6),
//   ItemData(5, Colors.pink, 100),
//   ItemData(7),
//   ItemData(8, Colors.yellowAccent),
// ];

List<ItemData> listA = [
  ItemData(1, Colors.orange),
  ItemData(2),
  ItemData(3),
  ItemData(4, Colors.cyan),
  ItemData(5),
  ItemData(8, Colors.green)
];
List<ItemData> listB = [
  ItemData(1, Colors.orange),
  ItemData(2),
  ItemData(3),
  ItemData(5),
  ItemData(4, Colors.cyan),
  ItemData(8, Colors.green)
];

final controller = AnimatedListController();
final gkey = GlobalKey<_BodyState>();

extension SwappableList<E> on List<E> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}
