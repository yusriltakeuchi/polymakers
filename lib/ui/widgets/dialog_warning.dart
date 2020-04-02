import 'package:flutter/material.dart';

class DialogWarning extends StatelessWidget {
  String title;
  String message;
  BuildContext context;
  Function onClick;

  DialogWarning({
    this.title,
    this.message,
    this.context,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
              ),
            )
          ],
        )
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onClick(),
          child: Text(
            "OK",
            style: TextStyle(
            )
          ),
        ),
      ],
    );
  }
}