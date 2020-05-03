import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/const.dart';
import 'package:shopping_list/screens/category_screen.dart';
import 'package:shopping_list/services/auth.dart';
import 'package:shopping_list/shared/loading.dart';

class Category {
  String uid;
  String name;
  Image image;
  List products;

  Category({this.uid, this.name, this.image, this.products});

  factory Category.fromDocument(DocumentSnapshot document) {
    return Category(
      uid: document.documentID,
      name: document['name'] as String,
      image: categoryNameImageMapping[document['name']],
      products: document['products'],
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _auth = AuthService();

  Map<String, List<String>> selectedProducts = Map();
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
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.of(context).pop();
                  //Navigator.of(context).pushNamedAndRemoveUntil(
                  //  'login_screen', (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
          padding: EdgeInsets.all(40.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: _showModalMenuSheet,
            ),
            Text(
              'Menu',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection("categories").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: snapshot.data.documents.map<Widget>(
                    (document) {
                      Category category = Category.fromDocument(document);
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: FlatButton(
                            onPressed: () async {
                              var selected = await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new CategoryScreen(
                                    uid: category.uid,
                                    name: category.name,
                                    products: category.products
                                        .map(
                                          (name) => Product(
                                            name: name,
                                            selected: (selectedProducts[
                                                        category.name] ??
                                                    [])
                                                .contains(name),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                              if (selected != null) {
                                selectedProducts[category.name] = selected;
                              }
                            },
                            padding: EdgeInsets.all(1.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white70),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15.0,
                                        ), //  ,               <--- border radius here
                                      ),
                                    ),
                                    child: category.image,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    category.name,
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return SnapshotError(snapshot: snapshot);
          } else {
            return Loading();
          }
        },
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
