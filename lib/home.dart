// ignore_for_file: camel_case_types, prefer_const_constructors, unused_import, implementation_imports, unnecessary_import, unused_element, unnecessary_new, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:latihan_ujikom_1/Login.dart';
import 'package:latihan_ujikom_1/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:android_intent_plus/android_intent.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final TextEditingController lokasi = new TextEditingController();

  String koordinat = '-';
  String address = '-';

  Future<Position> _getGeolocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address =
          '\n ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  Future<void> destroyPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("login", "");
    await prefs.setString("username", "");
    await prefs.setString("name", "");
  }

  Future<void> setNameUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getString("name").toString());

    setState(() {
      nameUser = prefs.getString("name").toString();
    });
  }

  @override
  void initState() {
    super.initState();
    setNameUser();
  }

  var nameUser = "anu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        "Welcome " + nameUser,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 18, 61, 97)),
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.edit),
                      onTap: () => Get.to(edit()),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 163, 156, 177),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                              width: 300,
                              child: Text(
                                "Lokasi Anda",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 18, 61, 97)),
                              )),
                          SizedBox(height: 5),
                          Container(
                              width: 300,
                              child: Text(
                                "Koordinat Point : $koordinat \n",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 18, 61, 97)),
                              )),
                          SizedBox(height: 5),
                          Container(
                              width: 300,
                              child: Text(
                                "Address : $address",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 18, 61, 97)),
                              )),
                          SizedBox(height: 30),
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 18, 61, 97),
                            ),
                            child: TextButton(
                                onPressed: () async {
                                  Position position =
                                      await _getGeolocationPosition();
                                  setState(() {
                                    koordinat =
                                        '${position.latitude}, ${position.longitude}';
                                  });
                                  getAddressFromLongLat(position);
                                },
                                child: Text(
                                  "Cek Lokasi",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    // height: 50,
                    width: 300,
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 163, 156, 177),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: TextField(
                                controller: lokasi,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Cari lokasi tujuan anda",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 18, 61, 97),
                                    )),
                              ),
                            )),
                        Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 18, 61, 97),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                              onPressed: () {
                                final Intent = AndroidIntent(
                                    action: 'action_view',
                                    data: Uri.encodeFull(
                                        'google.navigation:q=${lokasi.text}&avoid=tf'),
                                    package: 'com.google.android.apps.maps');
                                Intent.launch();
                              },
                              child: Text(
                                "Cari",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 18, 61, 97),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                        onPressed: () {
                          destroyPrefs();
                          Get.offAll(Login());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Logout    ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.logout, color: Colors.white,),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
