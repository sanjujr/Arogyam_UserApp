import 'dart:async';

import 'package:firebase/models/patients.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/screens/home/patient_list.dart';
import 'package:firebase/models/patients.dart';
import 'package:geolocator/geolocator.dart';

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  //Genertaring location coords
  String _lat;
  String _long;
  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);

    _lat = position.latitude.toString();
    _long = position.longitude.toString();
    print(_lat);

    print(_long);
  }

  String finalDate = '';
  getCurrentDate() {
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.month}";
    setState(() {
 
      finalDate = formattedDate.toString() ;
 
    });
  }

  final _formKey = GlobalKey<FormState>();
  Map<String, bool> checked = {
    "TB Patient": false,
    "Health Worker": false,
    "Quarry Worker": false,
    "Previous TB patient": false,
    "Diabetic": false,
    "Any lung diseases": false,
    "Heart/Liver diseases": false,
    "Smoker": false,
    "Alcoholic": false,
    "Coughing for more than 2 weeks": false,
    "Having Fever for more than 2 week": false,
    "Weight loss": false,
    "Blood in sputum": false,
  };
  var score = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          //if (snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF398AE5),
                elevation: 0.0,
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () async {
                      Timer(Duration(seconds: 3), () async {
                        getCurrentDate();
                        print("line is printed after 3 seconds");
                        print(finalDate);
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              userData.name,
                              userData.age,
                              score.toString(),
                              userData.flag,
                              _lat,
                              _long,
                              finalDate);
                        }
                      });
                      _getCurrentLocation();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: ListView(
                children: checked.keys.map((String key) {
                  return new CheckboxListTile(
                    title: Text(key),
                    value: checked[key],
                    onChanged: (bool value) {
                      setState(() {
                        checked[key] = value;
                      });
                      if (value) {
                        score += 5;
                      } else {
                        score -= 5;
                      }
                      print(score);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Color(0xFF398AE5),
                    checkColor: Colors.white70,
                  );
                }).toList(),
              ),
            ),
          );
          // }
          // else{
          //   return Loading();
          // }
        });
  }
}
