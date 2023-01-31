import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../client/hive_names.dart';
import '../models/employee.dart';
import 'Employee/EmployeePage.dart';

class LoginIn extends StatefulWidget{
  LoginIn({Key key, this.employee}) : super(key: key);
  Employee employee;
  @override
  State<LoginIn> createState() => _LoginInState();

}
class _LoginInState extends State<LoginIn> {

  final _formKey = GlobalKey<FormState>();
  String login;
  String password;


  bool _isObscure = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffff3e9),
        body: ValueListenableBuilder(
            valueListenable:
            Hive.box<Employee>(HiveBoxes.employee).listenable(),
            builder: (context, Box<Employee> box, _) {
              return Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Авторизация",
                        style: TextStyle(
                          fontFamily: "Ghotic",
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 22, 55, 0),
                        child: Container(
                          color: Color(0x6ea85100),
                          child: TextFormField(
                              //initialValue: widget.employee.login,
                              onChanged: (value) {
                                setState(() {
                                  login = value;
                                });
                              },
                              initialValue: widget.employee == null ? "" : widget.employee.login,

                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Color(0xffE5E5E5),
                                    fontFamily: "Ghotic",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                  hintText: "Логин"),
                              validator: (val) {
                                return val == null || val.trim().isEmpty
                                    ? 'Поле логина должно быть заполнено'
                                    : null;
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 22, 55, 0),
                        child: Container(
                          color: Color(0x6ea85100),
                          child: TextFormField(


                            obscureText: _isObscure,



                            initialValue: "",
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(

                              /*
                              border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure ?
                                    Icons.visibility :
                                    Icons.visibility_off,
                                    color: Colors.white, size: 20,),
                                  onPressed: (){
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                               */

                                hintStyle: TextStyle(
                                  color: Color(0xffe5e5e5),
                                  fontFamily: "Ghotic",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                hintText: "Пароль"),
                            validator: (val) {
                              return val == null || val.trim().isEmpty
                                  ? 'Поле пароля должно быть заполнено'
                                  : null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(110, 20, 110, 0),
                        child: MaterialButton(
                            onPressed: () {

                              //box.clear();
                              //box.add(Employee(id: 0, name: "Владислав", post: "Администратор", login: "SaltyCrunch", password: "123", email: "SaltyCrunch@mail.ru", phone: "+79213360033", birthday: DateTime.utc(2002, 9, 17),));

                              if (_validateAndSave()) {
                                int employee = box
                                    .toMap()
                                    .values
                                    .toList()
                                    .indexWhere((element) =>
                                element.login == (login ?? widget.employee.login) &&
                                    element.password == password);
                                if (!box.isEmpty && employee != -1) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                      builder: (context) => EmployeePage(
                                        employee: box
                                            .toMap()
                                            .values
                                            .toList()[employee],
                                      )));
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Ошибка'),
                                          content: const Text(
                                              'Логин или пароль введены неверно'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Ок'),
                                            ),
                                          ],
                                        ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xbaa85100)),
                              child: Center(
                                child: Text(
                                  "Войти",
                                  style: TextStyle(
                                    color: Color(0xffe5e5e5),
                                    fontFamily: "Ghotic",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      print('form is invalid');
      return false;
    }
  }
}