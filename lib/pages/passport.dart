import 'package:flutter/material.dart';

class Passport extends StatelessWidget {
  const Passport({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Column (
          children: [
            Padding(padding: EdgeInsets.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Паспорт', style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),),
              ],
            )
          ],
        )
    );
  }
}
