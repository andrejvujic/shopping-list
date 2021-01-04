import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/add_item_dialog.dart';
import 'package:shopping_list/widgets/empty_list.dart';
import 'package:shopping_list/widgets/shopping_item.dart';
import 'package:shopping_list/widgets/solid_button.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _addItemDialog = AddItemDialog();
  List<Map<String, dynamic>> _shoppingItems = [];

  void _addItem(
    String title,
    String amount,
  ) {
    setState(
      () => _shoppingItems.add({
        'title': title,
        'amount': amount,
      }),
    );
  }

  void _deleteItem(
    int index,
  ) {
    setState(
      () => _shoppingItems.removeAt(
        index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: MediaQuery(
          data: MediaQueryData(
            textScaleFactor: 1.0,
          ),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: (_shoppingItems.length > 0)
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: _shoppingItems.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              key: Key(
                                '${DateTime.now()}',
                              ),
                              child: ShoppingItem(
                                title:
                                    '${_shoppingItems[index]['title'] ?? ''}',
                                amount: _shoppingItems[index]['amount'] ?? 0,
                                delete: () => _deleteItem(
                                  index,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: EmptyList(
                        title: 'Nema podsjetinka',
                        subtitle:
                            'Niste dodali nijedan podsjetnik za kupovinu. Svi vaši podsjetnici će biti prikazani ovdje.',
                        child: SolidButton(
                          color: Colors.green,
                          width: 275.0,
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onPressed: () => _addItemDialog.show(
                            context,
                            _addItem,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Dodajte prvi podsjetnik',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        tooltip: 'Dodaj podsjetnik',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _addItemDialog.show(
          context,
          _addItem,
        ),
      ),
    );
  }
}
