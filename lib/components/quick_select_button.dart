import 'package:flutter/material.dart';

class QuickSelectButton extends StatelessWidget {
  QuickSelectButton({this.text = "", this.isSelected = false, super.key});
  String text;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 135,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.blue : const Color.fromARGB(255, 223, 240, 255),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.blue,
        ),
      ),
    );
  }
}
