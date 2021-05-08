import 'package:flutter/material.dart';

class UnknownWelcomeFB extends StatelessWidget {
  const UnknownWelcomeFB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("FireBase Unknown Exception"),
      ),
    );
  }
}
