import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../client/hive_names.dart';
import '../../tools/utils.dart';
import '../../models/employee.dart';
import '../../tools/button.dart';
import '../BottomNavBar.dart';

enum ImageSourceType { gallery, camera }

class AddCar extends StatefulWidget {
  AddCar({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  DateTime date = DateTime.now();
  File _image;
  final _keyForm = GlobalKey<FormState>();
  ImagePicker imagePicker = new ImagePicker();
  String carNumber;
  int employee = -1;

  var status;

  String technicalStatus;

  String numberCar;

  MaskTextInputFormatter format = new MaskTextInputFormatter(mask: "A###AA###",
      type: MaskAutoCompletionType.lazy,
      filter: {
        "A": RegExp(r'[А-Я]'), "#": RegExp(r'[0-9]')
      });


  @override
  Widget build(BuildContext context) {
    log((_image != null).toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        employee: widget.employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
          builder: (context, Box<Car> box, _) {


            return ValueListenableBuilder(
                valueListenable:
                    Hive.box<Employee>(HiveBoxes.employee).listenable(),
                builder: (context, Box<Employee> boxEmployee, _) {
                  Iterable<Employee> drivers = boxEmployee.values
                      .toList()
                      .where((element) =>
                  element.post != "Водитель");
                  return Center(
                    child: Form(
                      key: _keyForm,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                            child: Text(
                              "Добавление автомобиля",
                              style: TextStyle(
                                  color: Color(0xbaa85100),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  fontFamily: "Ghotic"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
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
                                        "Номер ТС",
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
                                          inputFormatters: [format],
                                    onChanged: (value) {
                                        setState(() {
                                          numberCar = value;
                                        });
                                    },
                                    validator: (val) {
                                        return val.trim().isEmpty || val.length < 8
                                            ? 'Поле номера должно быть заполнено'
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
                                        "Водитель",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            fontFamily: "Ghotic"),
                                      )))),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                        child: DropdownButton(
                                    items: drivers ??
                                      drivers.map((Employee value) {
                                        return DropdownMenuItem<String>(
                                            child: Text(value.name),
                                            value: value.id.toString());
                                    }).toList(),
                                    value: employee != -1? employee.toString(): null,
                                    onChanged: (value) {
                                        setState(() {
                                          employee = int.parse(value);
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
                                        "Статус",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            fontFamily: "Ghotic"),
                                      )))),
                                  TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                        child: DropdownButton(
                                    items: ["Свободен", "Занят", "На ремонте"]
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                            child: Text(value), value: value);
                                    }).toList(),
                                    value: status,
                                    onChanged: (value) {
                                        setState(() {
                                          status = value;
                                        });
                                    },
                                    dropdownColor: Color(0xffc4834f),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                      )),
                                ]),
                                TableRow(

                                    children: [
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Container(
                                          child: Center(
                                              child: Text(
                                        "Техн. состояние",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            fontFamily: "Ghotic"),
                                      )))),
                                  TableCell(

                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                        child: DropdownButton(
                                          items: ["В норме", "Сломано"]
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                                child: Text(value), value: value);
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              technicalStatus = value;
                                            });
                                          },
                                          value: technicalStatus,
                                          dropdownColor: Color(0xffc4834f),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ))
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                  );
                });
          }),
    );
  }

  Widget getDropDown(Box<Car> list) {
    if (list.isNotEmpty) {
      return DropdownButton(
          items: list.values
              .toList()
              .where((element) => element.status == "Доступен")
              .map((Car value) {
            return DropdownMenuItem<String>(
              value: value.numberCar,
              child: Text(value.numberCar),
            );
          }).toList(),
          onChanged: (value) {
            carNumber = value;
          });
    } else {
      return Container(child: Text("Все машины заняты или на ремонте"));
    }
  }

  @override
  // TODO: implement widget
  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() => this.date = date);
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
    Box<Car> contactsBox = Hive.box<Car>(HiveBoxes.car);
    int index;
    if (contactsBox.isEmpty) {
      index = 0;
    } else {
      index = contactsBox.toMap().values.last.id + 1;
    }
    contactsBox.add(Car(
        id: index,
        destination: "",
    technicalStatus: technicalStatus,
    employeeId: employee,
    numberCar: numberCar,
    status: status));
    Navigator.of(context).pop();
  }
}
