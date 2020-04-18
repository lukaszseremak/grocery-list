import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:shadow/shadow.dart';

class Category {
  String name;
  Image image;
  List<String> products;

  Category({this.name, this.image, this.products});
}

Future<List> _loadAsset() async {
  String jsonString =
      await rootBundle.loadString("assets/data/categories.json");
  var data = json.decode(jsonString);
  return data;
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

  Widget build(BuildContext context) {
    Future<List> categories = _loadAsset();

    return FutureBuilder<List>(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          body = GridView.count(
            crossAxisCount: 3,
            // TODO: stworz klase categorie ktora posiada 3 pola: nazwa, zdjecie, lista produktow.
            children: List.generate(
              12,
              (index) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: FlatButton(
                      onPressed: () => _showReportDialog(
                          snapshot.data[index]["name"],
                          List<String>.from(snapshot.data[index]["products"])),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Shadow(
                              opacity: 0.15,
                              child: Image.asset(
                                snapshot.data[index]["photo_path"],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              snapshot.data[index]["name"],
                              style: TextStyle(fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          body = Center(
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
          body = Center(
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
                  // decoration: BoxDecoration(
                  //     color: Colors.grey[400],
                  //     image: DecorationImage(
                  //         fit: BoxFit.fill,
                  //         image: AssetImage('assets/images/cover.jpg'))),
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
          body: body,
        );
      },
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
