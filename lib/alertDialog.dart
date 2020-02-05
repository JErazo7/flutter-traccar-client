import 'package:flutter/material.dart';

class AlertDialogInput extends StatelessWidget {
  final String title;
  final value;

  const AlertDialogInput({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController _controller = TextEditingController(text: value);


    return AlertDialog(
      title: new Text(title),
      
      content: TextField(autofocus: true, controller:_controller),
      actions: <Widget>[
        ButtonBar(
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCELAR')
            ),
            FlatButton(
                onPressed: () => Navigator.of(context).pop(_controller.text),
                child: const Text('ACEPTAR')
            ),
          ],
        )
      ],
    );
  }
}
