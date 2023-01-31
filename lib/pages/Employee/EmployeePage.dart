import 'package:diplom_vlad/models/employee.dart';
import 'package:diplom_vlad/pages/loginIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../client/hive_names.dart';
import '../BottomNavBar.dart';
import 'EditEmployee.dart';

class EmployeePage extends StatefulWidget {
  EmployeePage({Key key, this.employee, this.editEmployee}) : super(key: key);
  Employee employee;
  Employee editEmployee;
  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(employee: widget.employee,),

        appBar: AppBar(
          backgroundColor: Color(0x6ea85100),
          leading: Visibility(
            visible: widget.editEmployee == null,
            replacement: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => false);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginIn(employee: widget.employee,)));
                      //state: setState,
              },
            ),
          ),
        ),

      backgroundColor: Color(0XFFFFF3E9),
      //Colors.orangeAccent,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Employee>(HiveBoxes.employee).listenable(),
        builder: (context, Box<Employee> box, _) {

          return Column(

            children: [
              Padding(

                  padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                  child: Text(
                    widget.editEmployee == null ?
                    widget.employee.name : widget.editEmployee.name, style: TextStyle(
                    fontSize: 20,
                    color: Color(0XFFDAAD85),
                  ),)
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(105, 20, 105, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.png'),
                      backgroundColor: Color(0x6ea85100),
                      radius: 50,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Table(
                  border: TableBorder.all(color: Color(0x6ea85100)),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Container(height: 50,
                                child: Center(
                                    child: Text("Должность", style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"
                                    ),)))),
                        TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Container(
                                height: 50,
                                child: Center(child: Container(
                                    child: Text(
                                      widget.editEmployee == null ?
                                      widget.employee.post : widget.editEmployee.post, style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        fontFamily: "Ghotic"
                                    ),)))))

                      ],
                    ),
                    TableRow(
                        children: [
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(height: 50,
                                  child: Center(child: Text(
                                    "Дата рождения", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"
                                  ),)))),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(
                                  height: 50,
                                  child: Center(child: Text(
                                    DateFormat.yMMMd("ru").format(
                                        widget.editEmployee == null ?
                                        widget.employee.birthday : widget.editEmployee.birthday), style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: "Ghotic"
                                  ),))))
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(height: 50,
                                  child: Center(child: Text(
                                    "№ телефона", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"
                                  ),)))),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(
                                  height: 50,
                                  child: Center(child: Text(
                                    (widget.editEmployee == null ?
                                    widget.employee.phone : widget.editEmployee.phone).replaceAllMapped(RegExp(r'(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})'), (Match m) => "${m[1]} (${m[2]}) ${m[3]}-${m[4]}-${m[5]}"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: "Ghotic"
                                  ),))))
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(height: 50,
                                  child: Center(
                                      child: Text("E-mail", style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          fontFamily: "Ghotic"
                                      ),)))),
                          TableCell(
                              verticalAlignment: TableCellVerticalAlignment
                                  .top,
                              child: Container(
                                  height: 50,
                                  child: Center(child: Text(
                                    widget.editEmployee == null ?
                                    widget.employee.email : widget.editEmployee.email, style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: "Ghotic"
                                  ),))))
                        ]
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEmployee(employee: widget.employee,
                          editEmployee:
                        widget.editEmployee ?? widget.employee,)));
                    },
                      child: Text(
                        'Редактировать', style: TextStyle(fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0XFFBF7C3F),
                          fixedSize: const Size(200, 20)),),
                  ],
                ),
              ),


            ],
          );
        }
      )
    );
  }
}

