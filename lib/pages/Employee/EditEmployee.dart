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

class EditEmployee extends StatefulWidget {
  EditEmployee({Key key, this.employee, this.state, this.editEmployee}) : super(key: key);
  Employee employee;
  Employee editEmployee;
  final void Function(VoidCallback fn) state;

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  DateTime date;

  String fio;
  String post;

  String login;

  String password;

  String phone;

  String email;

  String passport;

  String driverLicense;
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
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                      child: Text(
                        "Редактирование сотрудника",
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
                                  "ФИО",
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
                                initialValue: widget.editEmployee.name,
                                onChanged: (value) {
                                  setState(() {
                                    fio = value;
                                  });
                                },
                                validator: (val) {
                                  return val.trim().isEmpty
                                      ? 'Поле имени должно быть заполнено'
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
                                  "Должность",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"),
                                )))),
                            TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                  child: DropdownButton(
                              items: dropdownItems,
                              value: post ?? widget.editEmployee.post,
                              onChanged: (value) {
                                  setState(() {
                                    post = value;
                                  });
                              },
                              dropdownColor: Color(0xffc4834f),
                              borderRadius: BorderRadius.circular(10),
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
                                  "Дата рождения",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: "Ghotic"),
                                )))),
                            TableCell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoButton(
                                    child: Text(
                                      date != null ?
                                      '${date.month}-${date.day}-${date.year}':
                                      '${widget.editEmployee.birthday.month}-${widget.editEmployee.birthday.day}-${widget.editEmployee.birthday.year}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        fontFamily: "Ghotic",
                                      ),
                                    ),
                                    onPressed: () => Utils.showSheet(
                                      context,
                                      child: buildDatePicker(),
                                      onClicked: () {
                                        final value = DateFormat('yyyy/MM/dd')
                                            .format(date??widget.editEmployee.birthday);
                                        Utils.showSnackBar(
                                            context, 'Выбрана дата: "$value"');

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Container(
                                    child: Center(
                                        child: Text(
                                  "Логин",
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
                                    initialValue: widget.editEmployee.login,
                                    onChanged: (value) {
                                      setState(() {
                                        login = value;
                                      });
                                      },
                                    validator: (val) {
                                      return val.trim().isEmpty
                                      ? 'Поле логина должно быть заполнено'
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
                                  "Пароль",
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
                                initialValue: widget.editEmployee.password,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validator: (val) {
                                  return val.trim().isEmpty
                                      ? 'Поле пароля должно быть заполнено'
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
                                  "E-mail",
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
                                initialValue: widget.editEmployee.email,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (val) {
                                  return !EmailValidator.validate(val)
                                      ? 'Поле почты введено неверно'
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
                                  "№ телефона",
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
                                initialValue: widget.editEmployee.phone,
                                inputFormatters: [PhoneInputFormatter()],
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                                validator: (val) {
                                  return val.trim().isEmpty
                                      ? 'Поле телефона должно быть заполнено'
                                      : null;
                                },
                              ),
                            )),
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
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
                                  "Сохранить",
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

    widget.editEmployee.name= fio ?? widget.editEmployee.name;
    widget.editEmployee.post = post ?? widget.editEmployee.post;
    widget.editEmployee.phone = phone ?? widget.editEmployee.phone;
    widget.editEmployee.birthday = date ?? widget.editEmployee.birthday;
    widget.editEmployee.login =  login ?? widget.editEmployee.login;
    widget.editEmployee.password =  password ?? widget.editEmployee.password;
    widget.editEmployee.email = email ?? widget.editEmployee.email;
    widget.editEmployee.save();
    Navigator.of(context).pop();
  }
}
