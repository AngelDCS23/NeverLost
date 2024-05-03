import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class inicio extends StatefulWidget {
  @override
  _inicio createState() => _inicio();
}

class _inicio extends State<inicio> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushNamed(context, '/pantallaTutorial');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constantes.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200.0,
              width: 350.0,
              child: Image.asset('assets/logo.png'),
            ),
            LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
