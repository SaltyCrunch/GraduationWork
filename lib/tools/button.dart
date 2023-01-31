import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialButton(

    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.more_time, size: 24),

        Text(
          'Выбрать дату',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    onPressed: onClicked,
  );
}