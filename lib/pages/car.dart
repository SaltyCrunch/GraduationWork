import 'package:diplom_vlad/pages/PathList/AddPathList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/employee.dart';
import 'BottomNavBar.dart';
import 'Car/CarList.dart';

class Cars extends StatelessWidget {
  Cars({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x6ea85100),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        employee: employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CarList(employee: employee,)));
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xbaa85100)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Список ТС",
                        style: TextStyle(
                          color: Color(0xffe5e5e5),
                          fontFamily: "Ghotic",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddPathList(employee: employee,)));
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xbaa85100)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Добавление путевого листа",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffe5e5e5),
                          fontFamily: "Ghotic",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
