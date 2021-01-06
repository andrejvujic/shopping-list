import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/services/auth_service.dart';
import 'package:shopping_list/services/database_service.dart';
import 'package:shopping_list/widgets/add_item_dialog.dart';
import 'package:shopping_list/widgets/empty_list.dart';
import 'package:shopping_list/widgets/info_alert.dart';
import 'package:shopping_list/widgets/shopping_item.dart';
import 'package:shopping_list/widgets/solid_button.dart';
import 'package:shopping_list/widgets/yes_no_alert.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _addItemDialog = AddItemDialog();

  final _databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<QueryDocumentSnapshot> _shoppingItems;
  bool _isLoading = false;

  void _setIsLoading(bool _value) => setState(() => _isLoading = _value);

  void _copyUniqueId(
    BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey,
  ) {
    Clipboard.setData(
      ClipboardData(
        text: FirebaseAuth.instance.currentUser.uid,
      ),
    );

    Navigator.pop(context);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          'Vaš id je kopiran u privremenu memoriju',
        ),
      ),
    );
  }

  void _markAsDone(String id, bool status) {
    _databaseService.markAsDone(id, status);
  }

  void _removeAllItems(
    List<QueryDocumentSnapshot> _shoppingItems,
  ) {
    if (_shoppingItems.length > 0) {
      YesNoAlert(
          title: 'Upozorenje',
          text:
              'Da li ste sigurni da želite da obrišete sve podsjetnike? Nećete ih moći vratiti.',
          onYesPressed: () async {
            _setIsLoading(true);
            try {
              await _databaseService.removeAllItems(_shoppingItems);
            } catch (e) {}
            _setIsLoading(false);
          }).show(context);
    } else {
      InfoAlert(
        title: 'Greška',
        text:
            'Nema podsjetnika za brisanje jer niste dodali nijedan podsjetnik.',
      ).show(context);
    }
  }

  void _addItem(
    String title,
    String amount,
  ) async {
    _setIsLoading(true);
    try {
      await _databaseService.addItem({
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
      await _databaseService.removeItem(id);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'Moji podsjetnici',
            ),
            centerTitle: true,
            actions: <Widget>[
              (!_isLoading)
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      onPressed: () => _removeAllItems(_shoppingItems),
                    )
                  : Container(),
            ],
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
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            FirebaseAuth.instance.currentUser.photoURL,
                          ),
                        ),
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
                    Icons.person_outline,
                    color: Colors.grey[600],
                    size: 24.0,
                  ),
                  title: Text(
                    'Moj id',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: (_isLoading)
                      ? null
                      : () => _copyUniqueId(
                            context,
                            _scaffoldKey,
                          ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.library_books_outlined,
                    color: Colors.grey[600],
                    size: 24.0,
                  ),
                  title: Text(
                    'Biblioteke otvorenog koda',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: (_isLoading)
                      ? null
                      : () => showLicensePage(
                            context: context,
                            applicationName: 'Podsjetnik za kupovinu',
                            applicationVersion: 'v1.0.2',
                            applicationLegalese:
                                'est. December 16th, 2020\nCopyright © 2020-2021, Andrej Vujić\nAll rights reserved.',
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
                  onTap: (_isLoading)
                      ? null
                      : () => context.read<AuthService>().signOut(),
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
              _shoppingItems = querySnapshot.docs;

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
                  child: (_shoppingItems.length > 0)
                      ? Column(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _shoppingItems.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          key: Key(
                                            _shoppingItems[index]['id'],
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
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
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
              );
            },
          ),
          floatingActionButton: (_isLoading)
              ? Container()
              : FloatingActionButton(
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
      ),
    );
  }
}
