import 'package:campus_ease/apis/allAPIs.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';
import 'package:campus_ease/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:campus_ease/models/food.dart';
import 'package:provider/provider.dart';

import 'admin_order_history.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyEdit = GlobalKey<FormState>();
  List<Food> _foodItems = <Food>[];
  String name = '';

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CampusEase',
          style: TextStyle(
              color: Color(0xFF8CBBF1),
              fontWeight: FontWeight.w800,
              fontSize: 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AdminOrderDetailsPage();
              }));
            },
          ),
        ],
      ),
      // ignore: unrelated_type_equality_checks
      body: (authNotifier.userDetails == null)
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Text("No Items to display"),
            )
          : (authNotifier.userDetails!.role == 'canteen')
              ? adminHome(context)
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: const Text("No Items to display"),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return popupForm(context);
              });
        },
        backgroundColor: const Color(0xFF8CBBF1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget adminHome(context) {
    // AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Card(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  _foodItems = <Food>[];
                  for (var item in snapshot.data!.docs) {
                    _foodItems.add(Food(item.id, item['item_name'],
                        item['total_qty'], item['price']));
                  }
                  List<Food> suggestionList = (name == '')
                      ? _foodItems
                      : _foodItems
                          .where((element) => element.itemName!
                              .toLowerCase()
                              .contains(name.toLowerCase()))
                          .toList();
                  if (suggestionList.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: suggestionList.length,
                          itemBuilder: (context, int i) {
                            return ListTile(
                              title: Text(suggestionList[i].itemName ?? ''),
                              subtitle: Text(
                                  'cost: ${suggestionList[i].price.toString()}'),
                              trailing: Text(
                                  'Total Quantity: ${suggestionList[i].totalQty.toString()}'),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return popupDeleteOrEmpty(
                                          context, suggestionList[i]);
                                    });
                              },
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return popupEditForm(
                                          context, suggestionList[i]);
                                    });
                              },
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        // width: MediaQuery.of(context).size.width * 0.6,
                        child: const Text("No Items to display"),
                      ),
                    );
                  }
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: const Text("No Items to display"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget popupForm(context) {
    String? itemName;
    int? totalQty, price;
    return AlertDialog(
        content: Stack(
      // overflow: Overflow.visible,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "New Food Item",
                  style: TextStyle(
                    color: Color(0xFF8CBBF1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.length < 3) {
                      return "Not a valid name";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onSaved: (String? value) {
                    itemName = value!;
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Food Name',
                    icon: Icon(
                      Icons.fastfood,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.length > 3) {
                      return "Not a valid price";
                    } else if (int.tryParse(value) == null) {
                      return "Not a valid integer";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSaved: (String? value) {
                    price = int.parse(value!);
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Price in INR',
                    icon: Icon(
                      Icons.attach_money,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.length > 4) {
                      return "QTY cannot be above 4 digits";
                    } else if (int.tryParse(value) == null) {
                      return "Not a valid integer";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSaved: (String? value) {
                    totalQty = int.parse(value!);
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Total QTY',
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addNewItem(itemName, price, totalQty, context);
                    }
                  },
                  child: const CustomRaisedButton(buttonText: 'Add Item'),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget popupEditForm(context, Food data) {
    String itemName = data.itemName!;
    int totalQty = data.totalQty!, price = data.price!;
    return AlertDialog(
        content: Stack(
      // overflow: Overflow.visible,
      children: <Widget>[
        Form(
          key: _formKeyEdit,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Edit Food Item",
                  style: TextStyle(
                    color: Color(0xFF8CBBF1),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: itemName,
                  validator: (String? value) {
                    if (value!.length < 3) {
                      return "Not a valid name";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  onSaved: (String? value) {
                    itemName = value!;
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Food Name',
                    icon: Icon(
                      Icons.fastfood,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: price.toString(),
                  validator: (String? value) {
                    if (value!.length > 3) {
                      return "Not a valid price";
                    } else if (int.tryParse(value) == null) {
                      return "Not a valid integer";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSaved: (String? value) {
                    price = int.parse(value!);
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Price in INR',
                    icon: Icon(
                      Icons.attach_money,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: totalQty.toString(),
                  validator: (String? value) {
                    if (value!.length > 4) {
                      return "QTY cannot be above 4 digits";
                    } else if (int.tryParse(value) == null) {
                      return "Not a valid integer";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSaved: (String? value) {
                    totalQty = int.parse(value!);
                  },
                  cursorColor: const Color(0xFF8CBBF1),
                  decoration: const InputDecoration(
                    hintText: 'Total QTY',
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Color(0xFF8CBBF1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (_formKeyEdit.currentState!.validate()) {
                      _formKeyEdit.currentState!.save();
                      editItem(itemName, price, totalQty, context, data.id!);
                    }
                  },
                  child: const CustomRaisedButton(buttonText: 'Edit Item'),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget popupDeleteOrEmpty(context, Food data) {
    return AlertDialog(
        content: Stack(
      // overflow: Overflow.visible,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  deleteItem(data.id!, context);
                },
                child: const CustomRaisedButton(buttonText: 'Delete Item'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  editItem(data.itemName!, data.price!, 0, context, data.id!);
                },
                child: const CustomRaisedButton(buttonText: 'Empty Item'),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
