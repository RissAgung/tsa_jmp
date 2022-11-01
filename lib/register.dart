// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:latihan_ujikom_1/Login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<Map<String, dynamic>> _Data = [];
  var _account = Hive.box('Account');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_data();
  }

  void load_data() {
    final data = _account.keys.map((Key) {
      final value = _account.get(Key);
      return {
        "key": Key,
        "id": value["id"],
        "username": value["username"],
        "name": value["name"],
        "password": value["password"],
        "noTelp": value["noTelp"]
      };
    }).toList();

    setState(() {
      _Data = data.reversed.toList();
    });
  }

  Future<void> _deleteItem() async {
    for (var i = 0; i < _Data.length; i++) {
      await _account.delete(_Data[i]['key']);
    }
    load_data();
  }

  String autoId() {
    var id = "";
    if (_Data.length == 0) {
      id = "ID1";
    } else {
      var id1 = _Data[0]["id"].toString();
      var idTok = id1.substring(0, 2);
      var nomorTok = int.parse(id1.substring(2, 3)) + 1;

      id = "$idTok$nomorTok";
    }
    return id;
  }

  // void gatauapa() {
  //   var id1 = _Data[0]["id"].toString();
  //   var idTok = id1.substring(0, 2);
  //   var nomorTok = int.parse(id1.substring(2, 3)) + 1;

  //   print("$idTok$nomorTok");
  // }

  final usernameController = new TextEditingController();
  final nameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final telpController = new TextEditingController();

  Future<void> _register(Map<String, dynamic> newData) async {
    await _account.add(newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50
              ),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Nama",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: telpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(hintText: "No Telp"),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.blue),
                child: TextButton(
                  onPressed: () {
                    try {
                      _register({
                        "id": autoId().toString(),
                        "username": usernameController.text,
                        "name": nameController.text,
                        "password": md5.convert(utf8.encode(passwordController.text)).toString(),
                        "noTelp": telpController.text
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Sukses",
                              ),
                              content: Text("Berhasil Register"),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.offAll(Login()),
                                    child: Text('OK')),
                              ],
                            );
                          });
                      // _deleteItem();
                      // print(_Data);
                    } catch (e) {
                      print("gagal");
                    }
                  },
                  child: Text("Resigter", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
