import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<void> markAsDone(String _id, bool _status) async {
    final Map<String, dynamic> _itemData =
        await itemsCollection.doc(_id).get().then((value) => value.data()) ??
            {};
    _itemData['done'] = _status;
    await itemsCollection.doc(_id).set(_itemData);
  }

  Future<void> addItem(Map<String, dynamic> _data) async {
    _data['timestamp'] = Timestamp.now();
    final String _id =
        await itemsCollection.add(_data).then((value) => value.id);
    _data['id'] = _id;
    _data['ownerId'] = uid;
    await itemsCollection.doc(_id).set(_data);
  }

  Future<void> removeItem(
    String _id,
  ) async {
    await itemsCollection.doc(_id).delete();
  }

  Future<void> removeAllItems(
    List<QueryDocumentSnapshot> _shoppingItems,
  ) async {
    for (int i = 0; i < _shoppingItems.length; i++) {
      await removeItem(_shoppingItems[i]['id']);
    }
  }

  Stream<QuerySnapshot> get currentUserItems => itemsCollection
      .orderBy('timestamp', descending: true)
      .where(
        'ownerId',
        isEqualTo: uid,
      )
      .snapshots();
}
