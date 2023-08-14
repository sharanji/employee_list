import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomAppbar extends StatelessWidget {
   CustomAppbar(this.title,{super.key});
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.blue,
      child: Row(
        children: const [
          SizedBox(
            width: 20,
          ),
          Text(
            'Employee List',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
