import 'package:firebase/models/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

class GenerateQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF398AE5),
          elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height:100),
          Center(
              child: Column(
            children: <Widget>[
              //genrater qr
              QrImage(
                data:user.uid,
                size: 250,
              ),
              Text(
                "Scan Me",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20.0,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}