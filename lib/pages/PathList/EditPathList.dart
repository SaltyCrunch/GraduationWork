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

class EditPathList extends StatefulWidget {
  EditPathList({Key key, this.employee, this.pathList}) : super(key: key);
  Employee employee;
  PathList pathList;
  @override
  State<EditPathList> createState() => _EditPathListState();
}

class _EditPathListState extends State<EditPathList> {
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


    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          "Редактирование путевого листа",
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

                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                      child: Text(
                                    "Дата отправления",
                                    style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    fontFamily: "Ghotic"),
                                  ))),
                              TableCell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      child: Text(
                                date != null ?
                                '${date.month}-${date.day}-${date.year}':
                                '${widget.pathList.date.month}-${widget.pathList.date.day}-${widget.pathList.date.year}',
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
                                          final value =
                                              DateFormat('yyyy/MM/dd').format(date == DateTime.now()? widget.pathList.date: date);
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
                                  : widget.pathList.image != null ? Image.file(
                                widget.pathList.image,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              ): Container(
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
                                _validateAndSave();
                                log("Дошёл");
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
                      ),
                    ],
                  ),
                ),
              );}

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

    widget.pathList.date = date ?? widget.pathList.date;
    widget.pathList.image = _image ?? widget.pathList.image;
    widget.pathList.save();

  }
}
