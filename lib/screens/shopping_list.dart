import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/services/auth_service.dart';
import 'package:shopping_list/services/database_service.dart';
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

  final _databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  bool _isLoading = false;

  void _setIsLoading(bool _value) => setState(() => _isLoading = _value);

  void _markAsDone(String id, bool status) {
    _databaseService.markAsDone(id, status);
  }

  void _addItem(
    String title,
    String amount,
  ) async {
    _setIsLoading(true);
    try {
      _databaseService.addItem({
        'title': title,
        'amount': amount,
        'done': false,
      });
    } catch (e) {}
    _setIsLoading(false);
  }

  void _removeItem(
    String id,
  ) async {
    try {
      _databaseService.removeItem(id);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Moji podsjetnici',
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        FirebaseAuth.instance.currentUser.displayName ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.grey[600],
                  size: 24.0,
                ),
                title: Text(
                  'Odjavi me',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16.0,
                  ),
                ),
                onTap: () => context.read<AuthService>().signOut(),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _databaseService.currentUserItems,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ),
                ),
              );
            }

            final QuerySnapshot querySnapshot = snapshot.data;
            final List<QueryDocumentSnapshot> _shoppingItems =
                querySnapshot.docs;

            return LoadingOverlay(
              isLoading: _isLoading,
              color: Colors.black,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
              child: MediaQuery(
                data: MediaQueryData(
                  textScaleFactor: 1.0,
                ),
                child: Container(
                  child: SingleChildScrollView(
                    physics: (_shoppingItems.length > 0)
                        ? ScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    child: (_shoppingItems.length > 0)
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.95,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _shoppingItems.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          key: Key(
                                            '${_shoppingItems[index]['id']}',
                                          ),
                                          child: ShoppingItem(
                                            id: _shoppingItems[index]['id'],
                                            title:
                                                '${_shoppingItems[index]['title'] ?? ''}',
                                            amount: _shoppingItems[index]
                                                    ['amount'] ??
                                                '1',
                                            removeItem: () => _removeItem(
                                                _shoppingItems[index]['id']),
                                            done: _shoppingItems[index]
                                                    ['done'] ??
                                                false,
                                            markAsDone: _markAsDone,
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          )
                        : EmptyList(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
            );
          },
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
      ),
    );
  }
}
