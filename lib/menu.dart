import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<menu> {

  final iconList = <IconData>[
    Icons.qr_code,
    Icons.map,
    Icons.person,
    Icons.expand_circle_down_rounded, //Este último icono se tendría que cambiar por otro que representase la configuración.
  ];

  var _bottomNavIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constantes.backgroundColor,
   body: Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Prueba'),
        ],
      ),
    ),
   ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Acción al presionar el botón
          },
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_upward_rounded),
          elevation: 2,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
