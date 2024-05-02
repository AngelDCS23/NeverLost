//imports
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

//constants
const backgroundColor = Color(0xFF142942);
const bone = Color(0xFFfefced);
const fontColorMain = Colors.white;

class tutorial extends StatefulWidget {
  @override
  _tutorial createState() => _tutorial();
}

class _tutorial extends State<tutorial> {
  late int selectedPage;
  late final PageController _pageController;

  @override
  void initState() {
    selectedPage = 0;
    super.initState();
    _pageController = PageController(initialPage: selectedPage);
  }

//En esta función obtengo el valor de la variable index para asignarle un mensaje personalizado.
  String texto($index) {
    if ($index == 0) {
      return 'A continuación tendrás una guía paso a paso de como utilizar NeverLost';
    } else if ($index == 1) {
      return 'Para empezar a utilizar nuestra aplicación tendrás que escanear el QR de tu billete';
    } else if ($index == 2) {
      return 'Una vez tengas escaneado el billete solo tendrás que ir al apartado AR y disfrutar de la experiencia NeverLost';
    } else if ($index == 3) {
      return 'En caso de que quieras eliminar algun billete escanado solo tendrás que acceder a tu menú y quitarlo desde ahí';
    } else if ($index == 4) {
      return 'Con esto ya estarías listo para utilizar Neverlost, esperamos que te guste';
    }
    return 'asdasd';
  }

  String imagen($index) {
    //RECUERDA QUE TODAS LAS IMÁGENES TIENES QUE TENER LAS MISMAS DIMENSIONES O SI NO,
    //ALGUNAS SE VERAN MÁS GRANDES QUE OTRAS.
    if ($index == 0) {
      return 'assets/info_blanco2.png';
    } else if ($index == 1) {
      return 'assets/tutorial/codigo-qr190px.png';
    } else if ($index == 2) {
      return 'assets/tutorial/camara-ar190px.png';
    } else if ($index == 3) {
      return 'assets/tutorial/billete-de-avion170.png';
    } else if ($index == 4) {
      return 'assets/tutorial/billete-de-avion170.png';
    }
    return 'assets/logo.png';
  }

  @override
  Widget build(BuildContext context) {
    const pageCount = 5;
    return MaterialApp(
      title: 'Page view dot indicator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                    });
                  },
                  //
                  children: List.generate(pageCount, (index) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          imagen(index),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            //aquí llamo a la función "texto" y le paso como argumento de entrada el index para que sepa en que "página" está.
                            texto(index),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontFamily: AutofillHints.name,
                                fontSize: 21,
                                height: 1.3,
                                letterSpacing: 0,
                                color: fontColorMain,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ));
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PageViewDotIndicator(
                  currentItem: selectedPage,
                  count: pageCount,
                  unselectedColor: Color.fromARGB(116, 123, 121, 121),
                  selectedColor: Colors.white,
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
