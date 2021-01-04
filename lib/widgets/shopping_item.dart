import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/yes_no_alert.dart';

class ShoppingItem extends StatefulWidget {
  @override
  _ShoppingItemState createState() => _ShoppingItemState();

  final String title, amount;
  final Function delete;

  ShoppingItem({
    this.title,
    this.amount,
    this.delete,
  });
}

class _ShoppingItemState extends State<ShoppingItem>
    with SingleTickerProviderStateMixin {
  YesNoAlert _deleteItemAlert;
  AnimationController _controller;
  Animation _animation;
  Tween _tween;
  double _itemOpacity = 1.0, _checkmarkOpacity = 0.0, _horizontalOffset = 0.0;
  bool _done = false;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );

    _tween = Tween<double>(
      begin: 0.0,
      end: 999.0,
    );

    _animation = _tween.animate(_controller)
      ..addListener(
        () => setState(
          () => _horizontalOffset = _animation.value,
        ),
      )
      ..addStatusListener((AnimationStatus _status) {
        if (_status == AnimationStatus.completed) widget.delete?.call();
      });

    _deleteItemAlert = YesNoAlert(
      title: 'Upozorenje',
      text:
          'Da li ste sigurni da želite da zauvijek obrišete ovaj podsjetnik? Nećete ga moći vratiti.',
      onYesPressed: () => _controller.forward(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        _horizontalOffset,
        0.0,
      ),
      child: Container(
        margin: EdgeInsets.all(
          5.0,
        ),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _itemOpacity,
              duration: const Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeInOut,
              child: MaterialButton(
                onLongPress: () =>
                    (_done) ? null : _deleteItemAlert.show(context),
                onPressed: () => setState(() {
                  _itemOpacity = ((_done) ? 1.0 : 0.25);
                  _checkmarkOpacity = ((_done) ? 0.0 : 1.0);
                  _done = !_done;
                }),
                elevation: 0.0,
                highlightElevation: 0.0,
                hoverElevation: 0.0,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 300.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.title ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'x${widget.amount ?? 0}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      splashRadius: (_done) ? 0.5 : 20.0,
                      highlightColor: Colors.grey.withOpacity(0.5),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey[800],
                        size: 30.0,
                      ),
                      onPressed: () =>
                          (_done) ? null : _deleteItemAlert.show(context),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _checkmarkOpacity,
              duration: const Duration(
                milliseconds: 200,
              ),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.done,
                size: 50.0,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
