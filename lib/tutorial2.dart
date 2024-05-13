import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:google_fonts/google_fonts.dart';


class tutorial2 extends StatefulWidget {
  @override
  _tutorial2 createState() => _tutorial2();
}

class _tutorial2 extends State<tutorial2> {

  late int selectedPage;
  late final PageController _pageController;
  final int pageCount = 3;

  @override
  void initState() {
    selectedPage = 0;
    super.initState();
    _pageController = PageController(initialPage: selectedPage);
  }

  String texto($index) {
    if ($index == 0) {
      return 'Con nuestra aplicación siempre llegarás a tu destino';
    } else if ($index == 1) {
      return 'Para utilizar NeverLost necesitarás conceder los permisos a la ubicación y la cámara';
    } else if ($index == 2) {
      return 'Esperamos que con nuestra aplicación llegues a tu destino';
    }
    return 'Sin Foto';
  }

  Color colorTexto($index){
    if($index == 0){
      return Colors.white;
    }else if($index == 1){
      return Constantes.backgroundColor;
    }else if($index == 2){
      return Colors.white;
    }
    return Colors.white;
  }

  String titulo($index) {
    if ($index == 0) {
      return 'Comienza en Neverlost';
    } else if ($index == 1) {
      return 'Autorización y permisos';
    } else if ($index == 2) {
      return '!Disfruta la experiencia!';
    } 
    return 'Sin Foto';
  }

  String imagen($index) {
    if ($index == 0) {
      return 'assets/tutorial/1.png';
    } else if ($index == 1) {
      return 'assets/tutorial/3.png';
    } else if ($index == 2) {
      return 'assets/tutorial/2.png';
    }
    return 'assets/error128px.png';
  }

  Color color($index){
    if($index == 0){
      return Constantes.backgroundColor;
    }else if($index == 1){
      return Constantes.blueSky;
    }else if($index == 2){
      return Constantes.blue2;
    }
    return Constantes.blue2;
  }

  Color SelectColor($index){
    if($index == 0){
      return Colors.white;
    }else if($index == 1){
      return Constantes.backgroundColor;
    }else if($index == 2){
      return Constantes.backgroundColor;
    }
    return Constantes.blue2;
  }

  Color UnseLColor($index){
    if($index == 0){
      return Constantes.blue2;
    }else if($index == 1){
      return Constantes.blue2;
    }else if($index == 2){
      return Colors.white;
    }
    return Constantes.blue2;
  }

  Color colorBotones($index){
    if($index == 0){
      return Constantes.blue2;
    }
    return Constantes.backgroundColor;
  }

  void incrementar() {
  setState(() {
    if (selectedPage < pageCount - 1) {
      selectedPage++;
      _pageController.animateToPage(selectedPage,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: color(selectedPage),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 90,),
              Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 25.0),
                          height: 35,
                          child: ElevatedButton(onPressed: (){
                            Navigator.pushNamed(context, '/menu');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(colorBotones(selectedPage)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: Text('Saltar',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
              Expanded(
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 20), // Establece el espacio arriba y abajo según lo deseado
    child: Container(
      child: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            selectedPage = page;
          });
        },
        children: List.generate(pageCount, (index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 350,
                      child: Image.asset(imagen(index)),
                    )
                  ],
                ),
                Container(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(
                          titulo(selectedPage),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 35,
                            color: colorTexto(selectedPage),
                          ),
                        ),
                          ],
                        )
                        
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 120,
                        width: 350,
                        child: Text(
                          texto(selectedPage),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 19,
                            height: 1.3,
                            letterSpacing: 0,
                            color: colorTexto(selectedPage),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Row(
                        children: [

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    ),
  ),
),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PageViewDotIndicator(
                      currentItem: selectedPage,
                      count: pageCount,
                      unselectedColor: UnseLColor(selectedPage),
                      selectedColor: SelectColor(selectedPage),
                      duration: const Duration(milliseconds: 200),
                      boxShape: BoxShape.circle,
                      onItemClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
                Spacer(),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(onPressed: incrementar,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(colorBotones(selectedPage)),
                ),
                child: 
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  
                ),
                )
              ],
            ),

             
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
