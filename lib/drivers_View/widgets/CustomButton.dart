import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),

      ),
      child: Center(child: Text('Arrived'))
    );
  }
}
