import 'package:flutter/material.dart';

class NavigateBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.arrow_forward_ios, color: Colors.white),
              Text(' Open',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
