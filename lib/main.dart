import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/pages/pages.dart';
import 'package:flutter_qr_reader/providers/scan_list_provider.dart';
import 'package:flutter_qr_reader/providers/ui_provider.dart';
import 'package:provider/provider.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     /* El WIDGET PROVIDER nos va a servir en la aplicación para que busque en el arbol de WIDGETS la clase llamada UiProvider en este caso  así se llama, y así mismo
     poder acceder la propiedad privada que se tiene en esa clase y así saber con el dato enviado en el SET que página mostrar*/
    return MultiProvider(

      // La propiedad providers dentro del WIDGET MultiProvider es necesaria o requerida
      providers: [

        //Este WIDGET es para cambiar depenediendo de las opciones seleccionadas
        ChangeNotifierProvider(

          //La propiedad create es la instrucción que se va a ejecutar cuando no hay ninguna instancia del provider creado y este recibe una función, en este caso es UiProvider()
          create: (_) => UiProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ScanListProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Scanner',
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomePage(),
          'mapa': (_) => const MapaPage(),
        },
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(selectedItemColor: Colors.deepPurple)
        ),
      ),
    );
  }
}