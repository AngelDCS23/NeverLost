import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class Ar extends StatefulWidget {
  const Ar({ Key? key }) : super(key: key);

  @override
  _Ar createState() => _Ar();
}

class _Ar extends State<Ar> {
  O3DController o3dController = O3DController();
PageController mainPageController = PageController();


int page=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          O3D(
            src: 'assets/direction_arrow.glb', // Ruta completa del modelo 3D
            controller: o3dController,
            ar: false,
            autoPlay: true,
            autoRotate: false,
            cameraControls: false,
            cameraTarget: CameraTarget(1, 5, 1.5),
            cameraOrbit: CameraOrbit(180, 180, 0),
          ),


          PageView(
            controller: mainPageController,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: page,

        onTap: (page){
          mainPageController.jumpToPage(page);

          if(page==0){
            o3dController.cameraTarget(1, 5, 1.5);
            o3dController.cameraOrbit(180, 180, 0);
          }
          else if(page==1){
            o3dController.cameraTarget(1, 1, -1.5);
            o3dController.cameraOrbit(0, 180, 0);
          }
          else if(page==2){
            o3dController.cameraTarget(0, 1.8, 0);
            o3dController.cameraOrbit(270, 90, 0);
          }

          setState(() {
            this.page= page;
          });
        },

        items: const[
        BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_left),
        label: 'Izquierda'),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_right),
        label: 'Derecha'),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_circle_up),
              label: 'Arriba'),
      ],),
    );
  }
}