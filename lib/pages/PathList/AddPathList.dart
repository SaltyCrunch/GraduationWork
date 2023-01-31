import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../client/hive_names.dart';
import '../../tools/utils.dart';
import '../../models/employee.dart';
import '../../tools/button.dart';
import '../BottomNavBar.dart';

enum ImageSourceType { gallery, camera }

class AddPathList extends StatefulWidget {
  AddPathList({Key key, this.employee}) : super(key: key);
  Employee employee;

  @override
  State<AddPathList> createState() => _AddPathListState();
}

class _AddPathListState extends State<AddPathList> {
  DateTime date;
  File _image;
  final _keyForm = GlobalKey<FormState>();
  String carNumber;
  int indexCar;
  Car car;

  var imagePicker;
  var type;


  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }


  @override
  Widget build(BuildContext context) {
    log((_image != null).toString());

    return Scaffold(

      bottomNavigationBar: BottomNavBar(
        employee: widget.employee,
      ),
      backgroundColor: Color(0xfffff3e9),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<PathList>(HiveBoxes.pathList).listenable(),
          builder: (context, Box<PathList> box, _) {

            return ValueListenableBuilder(
              valueListenable: Hive.box<Car>(HiveBoxes.car).listenable(),
                builder: (context, Box<Car> boxCar, _) {

              return Center(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                        child: Text(
                          "Добавление путевого листа",
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
                                            "Транспорт",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                fontFamily: "Ghotic"),
                                          )))),
                              TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                    child: DropdownButton(
                                      items: boxCar.values
                                          .toList()
                                          //.where((element) =>
                                      //element.status == "Свободен")
                                          .map((Car value) {
                                        return DropdownMenuItem<Car>(
                                            child: Text(value.numberCar),
                                            value: value);
                                      }).toList(),
                                      value: car ?? null,
                                      onChanged: (value) {
                                        setState(() {
                                          car = value;

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
                                    "Дата отправления",
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
                                        "Выбрать дату",
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
                                          final value = DateFormat('yyyy/MM/dd').format(date);
                                          Utils.showSnackBar(
                                              context, 'Выбрана дата: "$value"');

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ])
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () async {
                              await _showPicker(context);

                            },
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: Color(0xffc4834f),),
                              child: _image != null
                                  ? Image.file(
                                _image,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffc4834f),),
                                width: 200,
                                height: 200,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              onPressed: () { Navigator.of(context).pop(); },
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

                                if (date == null) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Ошибка'),
                                          content: const Text(
                                              'Дата не введена'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Ок'),
                                            ),
                                          ],
                                        ),
                                  );
                                } else {
                                  _validateAndSave();
                                }

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
              );}

            );
          }),
    );
  }
  Widget getDropDown(Box<Car> list) {
    if(list.isNotEmpty) {
      return DropdownButton(items: list.values.toList().where((element) => element.status == "Доступен").map((Car value) {
        return DropdownMenuItem<String>(
          value: value.numberCar,
          child: Text(value.numberCar),
        );
      }).toList(), onChanged: (value) {
        carNumber = value;
      });
    } else {
      return Container(
        child: Text("Все машины заняты или на ремонте")
      );
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
              setState(() => this.date = newDateTime);
            }),
      );

  Future<void> pickImage() async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile image = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Библиотека'),
                      onTap: () {
                        type = ImageSourceType.gallery;
                        pickImage();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Камера'),
                    onTap: () {
                      type = ImageSourceType.camera;
                      pickImage();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _validateAndSave() {
    final form = _keyForm.currentState;
    if (form.validate()) {
      _onFormSubmit();
    } else {
      print('form is invalid');
    }
  }

  void _onFormSubmit() {
    Box<PathList> contactsBox = Hive.box<PathList>(HiveBoxes.pathList);
    int index;
    if (contactsBox.isEmpty) {
      index = 0;
    } else {
      index = contactsBox.toMap().values.last.id + 1;
    }
    contactsBox.add(PathList(
        id: index,
        numberCar: car.numberCar,
    date: date,
    image: _image));

    car.save();
    Navigator.of(context).pop();
  }
}
