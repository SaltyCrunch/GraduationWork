import 'package:diplom_vlad/pages/Car/CarList.dart';
import 'package:diplom_vlad/pages/car.dart';
import 'package:diplom_vlad/tools/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/employee.dart';
import 'Employee/EmployeeList.dart';
import 'Store/StoreList.dart';
import 'Employee/EmployeePage.dart';


class BottomNavBar extends StatelessWidget{
  BottomNavBar({Key key, this.employee}) : super(key: key);
  Employee employee;


  @override
  Widget build(BuildContext context) {
    return Container(

      child: Table(

        border: TableBorder(verticalInside: BorderSide(width: 1, color: Color(
            0xbaa85100), style: BorderStyle.solid)),
        children: [
          TableRow(

            decoration: BoxDecoration(

              color: Color(0x6ea85100),
            ),
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                  child: IconButton(
                    onPressed: () {
                      if (employee.post == "Администратор") {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(settings: new RouteSettings(name: "cars"), builder: (context) =>
                            Cars(employee: employee)),
                                (route) => route.settings.name == "cars" ? false : true
                        );
                      } else {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(settings: new RouteSettings(name: "car"), builder: (context) =>
                            CarList(employee: employee)),
                                (route) => route.settings.name == "car" ? false : true
                        );
                      }
                    },
                      icon: Image.asset("assets/car.png", ), iconSize: MediaQuery.of(context).size.height/12,//iconSize: 100,
                  )
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: IconButton(onPressed: () {
                    if (employee.post == "Механик" || employee.post == "Администратор") {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(settings: new RouteSettings(name: "store"), builder: (context) =>
                          StoreList(employee: employee)),
                              (route) => route.settings.name == "store" ? false : true
                      );
                    } else {
                      Utils.showSnackBar(
                          context, 'Доступ ограничен');
                    }
                  },icon: Image.asset("assets/details.png", ), iconSize: MediaQuery.of(context).size.height/12,//iconSize: 100,
                  )
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: IconButton(onPressed: () {
                    Utils.showSnackBar(
                        context, 'Будет добавлено в будущих обновлениях');
                  },
                    icon: Image.asset("assets/map.png", ), iconSize: MediaQuery.of(context).size.height/12,//iconSize: 100,
                  )
              ),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: IconButton(onPressed: () {
                    if(employee.post == "Администратор") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(settings: new RouteSettings(name: "employeelist"), builder: (context) =>
                              EmployeeList(employee: employee)),
                              (route) => route.settings.name == "employeelist" ? false : true
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(settings: new RouteSettings(name: "accounts"), builder: (context) =>
                              EmployeePage(employee: employee)),
                            (route) => route.settings.name == "accounts" ? false : true
                      );
                    }
                  },icon: Image.asset("assets/account.png", ), iconSize: MediaQuery.of(context).size.height/12,//iconSize: 100,
                  )
              )
            ]
          )
        ],
      ),
    );
  }

}