import 'package:flutter/material.dart';
import 'package:shadow/shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/const.dart';

class Category {
  String name;
  Image image;
  List products;

  Category({this.name, this.image, this.products});

  factory Category.fromDocument(DocumentSnapshot document) {
    return Category(
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

  _showReportDialog(String typeOfProduct, List products) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose $typeOfProduct"),
            content: MultiSelectChip(
              products,
              typeOfProduct,
              onSelectionChanged: (selectedList) {
                setState(() {
                  if (selectedProducts.containsKey(typeOfProduct)) {
                    selectedProducts[typeOfProduct] =
                        (selectedProducts[typeOfProduct] + selectedList)
                            .toSet()
                            .toList();
                  } else {
                    selectedProducts[typeOfProduct] = selectedList;
                  }
                  print(selectedProducts);
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Choose"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

// shopping-list-2a711

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
              onTap: () => Navigator.popUntil(
                  context, ModalRoute.withName('login_screen')),
            ),
          ],
        ),
      ),
      body: new StreamBuilder(
        stream: Firestore.instance.collection("categories").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 3,
              children: snapshot.data.documents.map<Widget>(
                (document) {
                  Category category = Category.fromDocument(document);
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: FlatButton(
                        onPressed: () => _showReportDialog(category.name,
                            List<String>.from(category.products)),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Shadow(
                                opacity: 0.15,
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
            );
          } else if (snapshot.hasError) {
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
          } else {
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
        },
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> productList;
  final String typeOfProduct;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.productList, this.typeOfProduct,
      {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.productList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
