import 'package:flutter/material.dart';

//Para poder notificar a cualquier WIDGET que esté escuchando cuando la propiedad privada cambie es necesario que nuestra clase extienda de ChangeNotifier
class UiProvider extends ChangeNotifier {
  //Las variables con guion bajo son propiedades privadas
  int _selectedMenuOpt = 0;

  //Esto es un GET donde se retorna el valor de la propiedad privada pero el método GET es público 
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  //Esto es un SET donde se manda el valor por parámetro para poderselo asignar a la propiedad privada
  set selectedMenuOpt(int selectedMenuOpt) {
    _selectedMenuOpt = selectedMenuOpt;
    // EL notifyListeners se llama cuando se cambia el valor que recibimos por parámetro en el método SET en el cual lo colocamos, y notifica a todos los WIDGETS que estén escuchando
    notifyListeners();
  }
}