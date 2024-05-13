import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class inicio extends StatefulWidget {
  @override
  _inicio createState() => _inicio();
}

class _inicio extends State<inicio> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
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
            Text('NeverLost',
            style: GoogleFonts.tenorSans(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600
            ),)
            // SizedBox(
            //   height: 200.0,
            //   width: 350.0,
            //   child: SvgPicture.asset(
            //     'assets/NeverLost.svg',
            //     width: 200, // ajusta el ancho según sea necesario
            //     height: 200, // ajusta la altura según sea necesario
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ), 
            // Text('NeverLost',
            //   style: GoogleFonts.montserrat(
            //     fontSize: 35,
            //     color: Colors.white,
            //     fontWeight: FontWeight.w600
            //   ),
            // ),
            // SizedBox(
            //   height: 30,
            // ),   
            // LoadingAnimationWidget.staggeredDotsWave(
            // color: Colors.white,
            // size: 40,
            // ),
          ],
        ),
      ),
    );
  }
}
