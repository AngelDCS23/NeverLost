import 'package:flutter/material.dart';
import 'package:neverlost/constants.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return 'Sin Foto';
  }

  String titulo($index) {
    if ($index == 0) {
      return 'Tutorial';
    } else if ($index == 1) {
      return 'Escanear QR';
    } else if ($index == 2) {
      return 'Una vez tengas escaneado el billete solo tendrás que ir al apartado AR y disfrutar de la experiencia NeverLost';
    } else if ($index == 3) {
      return 'En caso de que quieras eliminar algun billete escanado solo tendrás que acceder a tu menú y quitarlo desde ahí';
    } else if ($index == 4) {
      return 'Con esto ya estarías listo para utilizar Neverlost, esperamos que te guste';
    }
    return 'Sin Foto';
  }

  String imagen($index) {
    if ($index == 0) {
      return 'assets/info_blanco2.png';
    } else if ($index == 1) {
      return 'assets/tutorial/codigo-qr190px.png';
    } else if ($index == 2) {
      return 'assets/tutorial/camara-ar190px.png';
    } else if ($index == 3) {
      return 'assets/tutorial/billete-de-avion160px.png';
    } else if ($index == 4) {
      return 'assets/tutorial/cheque128px.png';
    }
    return 'assets/error128px.png';
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
        backgroundColor: Constantes.backgroundColor,
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
                  children: List.generate(pageCount, (index) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          child: Image.asset(
                          imagen(index),
                        ),
                        ),
                        Container(
                          width: 300,
                          child: Text(
                            texto(index),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontFamily: AutofillHints.name,
                                fontSize: 21,
                                height: 1.3,
                                letterSpacing: 0,
                                color: Constantes.fontColorMain,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Visibility(
                          visible: (selectedPage == 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Solicitar permiso de ubicación
                              var status = await Permission.location.request();
                              var status2 = await Permission.camera.request();
                              if (status.isGranted && status2.isGranted) {
                                Navigator.pushNamed(context, '/menu');
                              } else {
                                print('El usuario denegó el permiso de ubicación o de la camara');
                                // Aquí podrías mostrar un diálogo o una snackbar para informar al usuario
                              }
                            },
                            child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Inicio',
                              style: TextStyle(
                                fontSize: 20,
                                color: Constantes.backgroundColor
                              ),
                            ),
                          ),
                        )
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
