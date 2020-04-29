import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Product {
  final String name;
  bool selected;

  Product({this.name, this.selected = false});

  @override
  bool operator ==(covariant String name) =>
      name.toLowerCase() == this.name.toLowerCase();
}

class CategoryScreen extends StatefulWidget {
  CategoryScreen({
    Key key,
    this.uid,
    this.name,
    this.products,
  }) : super(key: key);
  final String uid;
  final String name;
  final List<Product> products;

  @override
  _CategoryScreenState createState() => new _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController editingController = TextEditingController()..text = '';

  // List<Product> products = [
  //   Product(name: "apple"),
  //   Product(name: "bannana"),
  //   Product(name: "kiwi"),
  // ];
  var items = List<Product>();

  @override
  void initState() {
    items.addAll(widget.products);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Product> searchList = List<Product>();
    searchList.addAll(widget.products);
    if (query.isNotEmpty) {
      List<Product> foundData = List<Product>();
      searchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          foundData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(foundData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.products);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  String newProductName = "";

  @override
  Widget build(BuildContext context) {
    items.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Options',
        heroTag: 'products-options-tag',
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_shopping_cart),
            backgroundColor: Colors.pinkAccent[100],
            label: 'Accept choosen products',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () {
              var selected = items.where((i) => i.selected).toList();
              print(selected);
              Navigator.pop(
                  context, selected.map((product) => product.name).toList());
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.orangeAccent[100],
            label: 'Add new product',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () async {
              String received = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: 15.0,
                                child: Icon(
                                  Icons.close,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.red[300],
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'New product'),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value.length < 2) {
                                        return 'Name not long enough';
                                      } else if (widget.products
                                              .contains(value) ||
                                          items.contains(value))
                                        return "Product: `${value}` already exist!";
                                    },
                                    onSaved: (value) => newProductName = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Submit"),
                                    color: Colors.black38,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                        10.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      print(_formKey);
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        Navigator.of(context)
                                            .pop(newProductName);
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              if (received.isNotEmpty) {
                setState(() {
                  widget.products.add(Product(name: received.toLowerCase()));
                  items.add(Product(name: received.toLowerCase()));
                });
                Firestore.instance
                    .collection("categories")
                    .document(widget.uid)
                    .updateData(
                  {
                    "products":
                        widget.products.map((product) => product.name).toList()
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: Colors.yellow[200]),
                  ),
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.yellow[200]),
                  hintText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.yellow[200],
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      editingController.clear();
                      setState(() {
                        items.clear();
                        items.addAll(widget.products);
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.yellow[200],
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(60, 5, 60, 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: items[index].selected
                          ? Colors.white38
                          : Colors.black12, // set border color
                      border: Border.all(
                          color: Colors.red[300], // set border color
                          width: 3.0), // set border width
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ), // set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(1, 3),
                        ),
                      ], // make rounded corner of border
                    ),
                    child: ListTile(
                      title: Center(
                          child: Text(
                        '${items[index].name}',
                        style: TextStyle(color: Colors.white),
                      )),
                      selected: items[index].selected,
                      onTap: () {
                        setState(() {
                          items[index].selected = !items[index].selected;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
