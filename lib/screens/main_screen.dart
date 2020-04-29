import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/const.dart';
import 'package:shopping_list/screens/category_screen.dart';

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
  Map<String, List<String>> selectedProducts = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/menu.png'))),
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  'login_screen', (Route<dynamic> route) => false),
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
            return SnapshotLoading();
          }
        },
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
