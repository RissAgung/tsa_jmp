// ignore_for_file: camel_case_types, use_key_in_widget_constructors, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, avoid_print, unused_field, non_constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:latihan_ujikom_1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class edit extends StatefulWidget {
  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> _Data = [];
  // ignore: prefer_final_fields
  var _account = Hive.box('Account');

  @override
  void initState() {
    load_data();
    load_data2();
    super.initState();
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

  Future<void> setPreference(username, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("username", username);
        await prefs.setString("name", name);
    
  }

  Future<void> _updateData(int itemKey, Map<String, dynamic> item) async {
    await _account.put(itemKey, item);
    load_data(); // Update the UI
  }

  Future<void> load_data2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < _Data.length; i++) {
      if (_Data[i]['username'] == prefs.getString("username")) {
        print(_Data);
        keyController.text = _Data[i]['key'].toString();
        usernameController.text = _Data[i]['username'].toString();
        nameController.text = _Data[i]['name'].toString();
        telpController.text = _Data[i]['noTelp'].toString();
        break;
      }
    }
  }

  final usernameController = new TextEditingController();

  final nameController = new TextEditingController();

  final telpController = new TextEditingController();

  final keyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Edit Data",
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: TextButton(
                  onPressed: () {
                    try {
                      _updateData(int.parse(keyController.text), {
                        'username': usernameController.text.trim(),
                        'name': nameController.text.trim(),
                        'noTelp': telpController.text.trim(),
                      });
                      setPreference(usernameController.text, nameController.text);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Berhasil",
                              ),
                              content: Text("Berhasil di edit"),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.to(home()),
                                    child: Text('OK')),
                              ],
                            );
                          });
                    } catch (e) {
                      print(keyController.text);
                      // print(e);
                    }
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
