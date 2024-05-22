import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neverlost/constants.dart';

class BorrarCuenta extends StatefulWidget {
  const BorrarCuenta({ Key? key }) : super(key: key);

  @override
  _BorrarCuenta createState() => _BorrarCuenta();
}

class _BorrarCuenta extends State<BorrarCuenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Borrar Cuenta',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Constantes.backgroundColor,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child:  Image.asset('assets/advertencia.png'),
            ),
            SizedBox(
              height: 55,
            ),
            Text('¿Estás seguro que quieres eliminar tu cuenta?',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Constantes.backgroundColor,
              fontSize: 30,
            ),),
            Padding(padding: EdgeInsets.only(top: 20),
            child: Text('Esta acción no podrá deshacerse',
            style: GoogleFonts.montserrat(
              color: Constantes.backgroundColor,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),),),
            Padding(padding: EdgeInsets.only(top: 120),
            child: ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/menu');
            }, child: Text('Borrar',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 218, 55, 55)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Cambia el radio del borde aquí
                  ),
                  ),),))
          ],
        ),)
        
      ),
    );
  }
}