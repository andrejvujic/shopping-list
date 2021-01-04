import 'package:flutter/material.dart';
import 'package:shopping_list/screens/shopping_list.dart';

void main() {
  runApp(
    App(),
  );
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podsjetink za kupovinu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins-Regular',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingList(),
    );
  }
}
