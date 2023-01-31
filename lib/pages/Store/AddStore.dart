import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../client/hive_names.dart';
import '../../tools/utils.dart';
import '../../models/employee.dart';
import '../../tools/button.dart';
import '../BottomNavBar.dart';

enum ImageSourceType { gallery, camera }

class AddStore extends StatefulWidget {
  AddStore({Key key, this.employee, this.state}) : super(key: key);
  Employee employee;
  final void Function(VoidCallback fn) state;

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  DateTime date = DateTime.now();

  String name;

  int remains = 0;

  String manufacturer;

  String desc;
  final _keyForm = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Водитель"), value: "Водитель"),
      DropdownMenuItem(child: Text("Механик"), value: "Механик"),
      DropdownMenuItem(child: Text("Администратор"), value: "Администратор"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Employee>(HiveBoxes.employee).listenable(),
          builder: (context, Box<Employee> box, _) {
            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Text(
                          "Добавление запчати",
                          style: TextStyle(
                              color: Color(0xbaa85100),
                              fontWeight: FontWeight.w400,
                              fontSize: 24,
                              fontFamily: "Ghotic"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Table(
                          border: TableBorder.all(color: Color(0x6ea85100)),
                          children: [
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                      child: Center(
                                          child: Text(
                                    "Название",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"),
                                  )))),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                child: TextFormField(
                                  autofocus: true,
                                  initialValue: '',
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                  validator: (val) {
                                    return val.trim().isEmpty
                                        ? 'Поле названия должно быть заполнено'
                                        : null;
                                  },
                                ),
                              )),
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                      child: Center(
                                          child: Text(
                                    "Остаток",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"),
                                  )))),
                              TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                    child: TextFormField(
                                      autofocus: true,
                                      initialValue: '0',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          remains = int.parse(value);
                                        });
                                      },
                                      validator: (val) {
                                        return int.tryParse(val) == null
                                            ? 'Поле остатка должно быть заполнено или заполнено неправильно'
                                            : null;
                                      },
                                    ),
                                  ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                      child: Center(
                                          child: Text(
                                    "Производитель",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"),
                                  )))),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                  child: TextFormField(
                                    autofocus: true,
                                    initialValue: "",
                                    onChanged: (value) {
                                      setState(() {
                                        manufacturer = value;
                                      });
                                    },
                                    validator: (val) {
                                      return val.trim().isEmpty
                                          ? 'Поле производителя должно быть заполнено'
                                          : null;
                                    },
                                  ),
                                ))
                            ]),

                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      child: Text("Справочная информация")
                ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0x6ea85100))
                          ),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height/3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              autofocus: true,
                              initialValue: "",
                              onChanged: (value) {
                                setState(() {
                                  desc = value;
                                });
                              },
                              maxLines: 14,

                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 18, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xbaa85100),
                                ),
                                child: Center(
                                  child: Text(
                                    "Назад",
                                    style: TextStyle(
                                        color: Color(0xffFFF3E9),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"),
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                _validateAndSave();
                              },
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xbaa85100),
                                ),
                                child: Center(
                                  child: Text(
                                    "Добавить",
                                    style: TextStyle(
                                        color: Color(0xffFFF3E9),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        fontFamily: "Ghotic"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  // TODO: implement widget
  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() => this.date = newDateTime);
            }),
      );

  void _validateAndSave() {
    final form = _keyForm.currentState;
    if (form.validate()) {
      _onFormSubmit();
    } else {
      print('form is invalid');
    }
  }

  void _onFormSubmit() {
    Box<Store> contactsBox = Hive.box<Store>(HiveBoxes.store);
    int index;
    if (contactsBox.isEmpty) {
      index = 0;
    } else {
      index = contactsBox.toMap().values.last.id + 1;
    }
    contactsBox.add(Store(
        id: index,
        name: name,
        desc: desc ?? "",
    manufacturer: manufacturer,
    remains: remains));
    log("Lolg");

    Navigator.of(context).pop();
  }
}
