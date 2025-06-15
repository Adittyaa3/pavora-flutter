import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main(
) => runApp(myContainer());


class myContainer extends StatelessWidget {
@override
Widget build(BuildContext context){
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Contoh Container'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: OuterContainer()
        
      ),
    ),
  );
}}


class OuterContainer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 200,
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: innercontainer(),

    );
  }
}

class innercontainer extends StatelessWidget{
@override
Widget build(BuildContext context){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(40),
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Text(
      'Inner Container',
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    
    
  );
  
}
}

