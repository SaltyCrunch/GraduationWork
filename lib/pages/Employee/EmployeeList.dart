import 'dart:developer';

import 'package:diplom_vlad/models/employee.dart';
import 'package:diplom_vlad/pages/Employee/EditEmployee.dart';
import 'package:diplom_vlad/pages/Employee/EmployeePage.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../client/hive_names.dart';
import 'AddEmployee.dart';
import '../BottomNavBar.dart';

class EmployeeList extends StatefulWidget {
  EmployeeList({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> copyEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
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
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddEmployee(employee: widget.employee,state: setState,)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffA85100),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Color(0xffFFF3E9),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Employee>(HiveBoxes.employee).listenable(),
        builder: (context, Box<Employee> box, _) {
          if (box.values.isEmpty) {

            return Center(
              child: Text("Сотрудников нет"),
            );
          }
          /*Employee employee = box.getAt(0);
          box.clear();
          box.add(employee);*/
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
              child: Container(
                color: Color(0x6ea85100),
                width: double.infinity,
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: 'Поиск',
                      hintStyle: TextStyle(
                          color: Color(0xffE5E5E5),
                          fontSize: 18,
                          fontFamily: "Ghotic",
                          fontWeight: FontWeight.w400)),
                  onChanged: (value) {
                    copyEmployee = List.from(box.values.toList());
                    copyEmployee.removeWhere((element) => !element.name
                        .toLowerCase()
                        .contains(value.toLowerCase()));
                    setState(() {});
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Center(
                        child: Text(
                      "ФИО",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontFamily: "Ghotic"),
                    )),
                    Center(
                        child: Text(
                      "Должность",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          fontFamily: "Ghotic"),
                    )),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0x6ea85100)),
                ),
                child: ListView.builder(

                    itemCount: copyEmployee == null
                        ? box.values.length
                        : copyEmployee.length,
                    itemBuilder: (context, index) {
                      Employee res = copyEmployee == null
                          ?box.getAt(index):copyEmployee[index];
                      return Dismissible(
                        background: Container(color: Colors.red),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Удаление'),
                                  content: const Text('Вы уверены, что хотите удалить сотрудника?'),
                                  actions: [
                                    // The "Yes" button
                                    TextButton(
                                        onPressed: () {
                                          // Remove the box
                                          res?.delete();
                                          Navigator.pop(context);
                                          // Close the dialog

                                        },
                                        child: const Text('Да')),
                                    TextButton(
                                        onPressed: () {
                                          // Close the dialog
                                          setState(() {

                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Нет'))
                                  ],
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmployeePage(employee: widget.employee, editEmployee: res, )));
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,

                                      child: Center(
                                        child: Text(
                                          res.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Ghotic",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      width: 6,
                                      thickness: 1.5,

                                      color: Color(0x6ea85100),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: Center(
                                        child: Text(
                                          res.post,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Ghotic",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(

                                  height: 6,
                                  thickness: 1.5,

                                  color: Color(0x6ea85100),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
