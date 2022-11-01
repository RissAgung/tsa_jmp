// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, use_key_in_widget_constructors, prefer_final_fields, non_constant_identifier_names, avoid_types_as_parameter_names, unused_element, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latihan_ujikom_1/home.dart';
import 'package:latihan_ujikom_1/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> setPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("login", "true");

    for (var i = 0; i < _Data.length; i++) {
      if (_Data[i]['username'] == controllerUsername.text) {
        await prefs.setString("username", _Data[i]['username']);
        await prefs.setString("name", _Data[i]['name']);
        break;
      }
    }
  }

  Future<void> loginOtomatis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("login").toString() == "true") {
      Get.offAll(home());
    }
  }

  final TextEditingController controllerUsername = new TextEditingController();
  final TextEditingController controllerPassword = new TextEditingController();

  List<Map<String, dynamic>> _Data = [];
  var _account = Hive.box('Account');

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    load_data();
    loginOtomatis();
    print(_Data);
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
      // print(_Data[2]['username']);
    });
  }

  Future<void> _deleteItem() async {
    for (var i = 0; i < _Data.length; i++) {
      await _account.delete(_Data[i]['key']);
    }
    load_data();
  }

  bool cekLogin() {
    bool status = false;
    for (var i = 0; i < _Data.length; i++) {
      if (controllerUsername.text == _Data[i]['username'] &&
          md5.convert(utf8.encode(controllerPassword.text)).toString() == _Data[i]['password']) {
        status = true;
        return true;
      }
    }
    if (status == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Gagal",
              ),
              content: Text("Username atau password salah"),
            );
          });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: controllerUsername,
                  decoration: InputDecoration(hintText: "Username"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: TextField(
                  controller: controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                child: Row(
                  children: [
                    Text(
                      "Blm punya akun? ",
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(Register()),
                      child: Text(
                        "Click disini",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      if (cekLogin()) {
                        setPreference();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Berhasil",
                                ),
                                content: Text("Sukses"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.offAll(home());
                                      },
                                      child: Text("OK"))
                                ],
                              );
                            });
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
