import 'package:firebase/models/user.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/utilities/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/models/patients.dart';

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
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
    
    // pat.forEach((patients){
    //   print(patients.name);
    //   print(patients.age);
    // });
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        //if (snapshot.hasData){
          return Scaffold(
          body: ListView(
            children: checked.keys.map((String key) {
              return new CheckboxListTile(
                title: Text(key),
                value: checked[key],
                onChanged: (bool value) {

                  setState(() {
                    checked[key] = value;
                    
                  });
                  if(value){score+=5;}
                  else{score-=5;}
                  print(score);
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Color(0xFF398AE5),
                checkColor: Colors.white70,
              );
            }).toList(),
            
          ),
        );
        // }
        // else{
        //   return Loading();
        // }
        
      }
    );
  }
}
