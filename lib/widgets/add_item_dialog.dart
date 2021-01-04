import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/info_alert.dart';
import 'package:shopping_list/widgets/solid_button.dart';
import 'package:shopping_list/widgets/text_input.dart';

class AddItemDialog {
  void show(
    BuildContext context,
    Function onButtonPressed,
  ) {
    final _titleController = TextEditingController();
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) =>
          MediaQuery(
        data: MediaQueryData(
          textScaleFactor: 1.0,
        ),
        child: Container(
          margin: MediaQuery.of(context).viewInsets,
          child: AlertDialog(
            title: Text(
              'Novi podsjetnik',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Poppins-Bold',
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextInput(
                    width: MediaQuery.of(context).size.width * 0.85,
                    labelText: '*Naslov',
                    helperText: 'Naslov',
                    hintText: 'npr. hljeb',
                    controller: _titleController,
                    maxLength: 100,
                    margin: EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  ),
                  TextInput(
                    width: MediaQuery.of(context).size.width * 0.85,
                    labelText: 'Količina',
                    helperText: 'Količina',
                    hintText: '',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    margin: EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  ),
                  SolidButton(
                    color: Colors.green,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    childWidth: 85.0,
                    onPressed: () {
                      if (_titleController.text.isNotEmpty &&
                          _titleController.text.length < 101 &&
                          !_amountController.text.contains('-') &&
                          !_amountController.text.contains('.')) {
                        onButtonPressed?.call(
                          _titleController.text,
                          ((_amountController.text.isEmpty)
                              ? '1'
                              : _amountController.text),
                        );
                        Navigator.pop(context);
                      } else if (_titleController.text.isEmpty) {
                        InfoAlert(
                          title: 'Greška',
                          text:
                              'Polje za naslov je obavezno i mora biti popunjeno. Popunite ga, pa pokušajte ponovo.',
                        ).show(context);
                      } else if (_titleController.text.length > 100) {
                        InfoAlert(
                          title: 'Greška',
                          text:
                              'Naslov koji ste unijeli je predug. Skratite ga, pa pokušajte ponovo.',
                        ).show(context);
                      } else {
                        InfoAlert(
                          title: 'Greška',
                          text:
                              'Polje za količinu može da sadrži samo brojeve.',
                        ).show(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        Text(
                          'Dodaj',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Text(
                      '* - obavezno polje',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
