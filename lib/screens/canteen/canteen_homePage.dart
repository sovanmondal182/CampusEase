import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_ease/apis/foodAPIs.dart';
import 'package:campus_ease/models/food.dart';
import 'package:campus_ease/notifiers/authNotifier.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cartIds = <String>[];
  List<Food> _foodItems = <Food>[];
  String name = '';

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    getCart(authNotifier.userDetails!.uuid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('CampusEase'),
        ),
        // ignore: unrelated_type_equality_checks
        body: (authNotifier.userDetails!.uuid == Null)
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Text("No Items to display"),
              )
            : userHome(context));
  }

  Widget userHome(context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
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
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('total_qty', isGreaterThan: 0)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                  _foodItems = <Food>[];
                  snapshot.data!.docs.forEach((item) {
                    _foodItems.add(Food(item.id, item['item_name'],
                        item['total_qty'], item['price']));
                  });
                  List<Food> _suggestionList = (name == '' || name == null)
                      ? _foodItems
                      : _foodItems
                          .where((element) => element.itemName!
                              .toLowerCase()
                              .contains(name.toLowerCase()))
                          .toList();
                  if (_suggestionList.length > 0) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _suggestionList.length,
                          itemBuilder: (context, int i) {
                            return ListTile(
                                title: Text(_suggestionList[i].itemName ?? ''),
                                subtitle: Text(
                                    'cost: ${_suggestionList[i].price.toString()}'),
                                trailing: IconButton(
                                  icon: cartIds.contains(_suggestionList[i].id)
                                      ? new Icon(Icons.remove)
                                      : new Icon(Icons.add),
                                  onPressed: () async {
                                    cartIds.contains(_suggestionList[i].id)
                                        ? await removeFromCart(
                                            _suggestionList[i], context)
                                        : await addToCart(
                                            _suggestionList[i], context);
                                    setState(() {
                                      getCart(authNotifier.userDetails!.uuid!);
                                    });
                                  },
                                ));
                          }),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text("No Items to display"),
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

  void getCart(String uuid) async {
    List<String> ids = <String>[];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(uuid)
        .collection('items')
        .get();
    var data = snapshot.docs;
    for (var i = 0; i < data.length; i++) {
      ids.add(data[i].id);
    }
    setState(() {
      cartIds = ids;
    });
  }
}
