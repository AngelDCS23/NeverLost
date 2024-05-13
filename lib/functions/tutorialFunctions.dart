class tutorialFunctions{
  
  String titulo($index) {
    if ($index == 0) {
      return 'Comienza en Neverlost';
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
}