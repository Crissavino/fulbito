import 'package:flutter/material.dart';
import 'package:fulbito/globals/constants.dart';

class CreateNewGroup extends StatefulWidget {
  @override
  _CreateNewGroupState createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(CREATE_GROUP),
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: horizontalGradient,
          ),
        ),
        body: Container(
          decoration: horizontalGradient,
          child: Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: screenBorders,
              ),
              child: ClipRRect(
                borderRadius: screenBorders,
                child: Container(child: Text('contenido'),),
              ),
            ),
          ),
        ));
  }
}
