import 'package:flutter/material.dart';

class EmptyList extends StatefulWidget {
  @override
  _EmptyListState createState() => _EmptyListState();

  final String title, subtitle;
  final Widget child;
  EmptyList({
    this.title,
    this.subtitle,
    this.child,
  });
}

class _EmptyListState extends State<EmptyList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${widget.title ?? ''}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Poppins-Bold',
            ),
          ),
          Text(
            '${widget.subtitle ?? ''}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          (widget.child == null) ? Container() : widget.child,
        ],
      ),
    );
  }
}
