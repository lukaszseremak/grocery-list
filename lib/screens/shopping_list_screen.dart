import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  TextEditingController editingController = TextEditingController()..text = '';

  List<String> shopping_lists = ["Private", "Tesco", "Pepco"];

  void _showModalMenuSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.red,
                        backgroundImage:
                            AssetImage('assets/images/lukasz_avatar_image.jpg'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Łukasz',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'IndieFlower'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: new BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(40.0),
                      )),
                  child: ListTile(
                    title: Text(
                      shopping_lists[0],
                    ),
                    selected: true,
                    onTap: () {},
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text(
                      shopping_lists[1],
                    ),
                    selected: false,
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  child: FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Create new list")
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.all(40.0),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: const Text('Bottom App Bar')),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: _showModalMenuSheet,
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class SnapshotLoading extends StatelessWidget {
  const SnapshotLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          )
        ],
      ),
    );
  }
}

class SnapshotError extends StatelessWidget {
  const SnapshotError({Key key, this.snapshot}) : super(key: key);

  final AsyncSnapshot<dynamic> snapshot;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
