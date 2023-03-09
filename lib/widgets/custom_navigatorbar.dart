import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/providers/ui_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;


    //El WIDGET BottomNavigationBar tiene que tener obligatoriamente la propiedad items, lo cual es un arreglo de BottomNavigationBarItem
    return BottomNavigationBar(
      elevation: 0,
      onTap: (int index) => uiProvider.selectedMenuOpt = index,
      //La propiedad currentIndex nos permite indicar que elemento va a estar seleccionado al momento de cargar nuestra aplicación, recibe valores númericos
      currentIndex: currentIndex,
      items: const <BottomNavigationBarItem>[

        //Una de las reglas del BottomNavigationBarItem es que por lo menos deben de ser dos items para que no nos marque error, las dos propiedades son el label y el icon
        BottomNavigationBarItem(
           label: 'Mapa',
           icon: Icon(Icons.map)
        ),
        BottomNavigationBarItem(
           label: 'Direcciones',
           icon: Icon(Icons.compass_calibration)
        )
      ],
    );
  }
}
