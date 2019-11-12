import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;

  InputWidget(this.topRight, this.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 40, bottom: 5),
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Material(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(bottomRight),
                      topRight: Radius.circular(topRight))),
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "JohnDoe@example.com",
                      hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                ),  
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 40, bottom: 30),
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Material(
              elevation: 10,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(0.0))),
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                ),  
              ),
            ),
          ),
        ),
      ],
    );
  }
}