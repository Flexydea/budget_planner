import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tips Screen',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
