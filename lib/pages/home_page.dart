import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/models/scan_model.dart';
import 'package:flutter_qr_reader/pages/pages.dart';
import 'package:flutter_qr_reader/providers/db_provider.dart';
import 'package:flutter_qr_reader/providers/scan_list_provider.dart';
import 'package:flutter_qr_reader/providers/ui_provider.dart';
import 'package:flutter_qr_reader/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //La propiedad elevation nos sirve para quitar o marcar más el sombreado por defecto que tiene el AppBar
        elevation: 0,
        title: Container(
          child: Center(
            child: Text('Historial'),
          ),
          margin: const EdgeInsets.only(left: 50),
        ),

        //La propiedad actions es un arreglo de elementos que nos permite poner íconos en el AppBar
        actions: <Widget>[
          IconButton(
             icon: const Icon(Icons.delete),
             onPressed: () async {
              //Forma normal de hacerlo
              // final ScanListProvider scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
              // scanListProvider.borrarTodos();

              //Otra forma de hacer lo de arriba de mejor manera es la siguiente
              Provider.of<ScanListProvider>(context, listen: false).borrarTodos();
            },
          )
        ],
      ),
      body: _HomePageBody(),
      //Aquí mandamos a llamar al WIDGET CustomNavigationBar el cual es un WIDGET instanciado desde otra carpeta del proyecto
      bottomNavigationBar: const CustomNavigationBar(),

      //Aquí mandamos a llamar al WIDGET ScanButton el cual es un WIDGET instanciado desde otra carpeta del proyecto
      floatingActionButton: const ScanButton(),

      //Esta propiedad nos permite ubicar el FloatingActionButton en un lugar distinto al que nos pone por defecto
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override

  //El provider ya se encuentra en la variable siguiente llamada context en el arbol de WIDGETS
  Widget build(BuildContext context) {

    //Obtener el selected menuOpt donde mandamos como argumento el context y le indicamos el tipo de provider que buscará, en este caso es UiProvider
    final uiProvider = Provider.of<UiProvider>(context);

    //Este WIDGET es para mostrar las demás WIDGETS de forma condicional

    //En la siguiente línea accedemos a la propiedad o get llamado selectedMenuOpt
    final currentIndex = uiProvider.selectedMenuOpt;

    //TODO: Temporal leer la base de datos
    //final tempScan = ScanModel(id: 1, tipo: 'String', valor: 'http://google.com');
    //DBProvider.db.nuevoScan(tempScan);
    //DBProvider.db.getScanById(1).then((value) => print(value!.tipo));
    //DBProvider.db.getAllScans().then((value) => print(value));
    //DBProvider.db.deleteAllScans().then((value) => print(value));


    //Usar el ScanListProvider
    //La siguiente línea  nos regresa la instancia de nuestra clase ScanListProvider ya que tenemos 
    //La propiedad listen por defecto está en true, y eso hace que se redibuje, por lo tanto si no queremos que se redibuje en este punto es necesario colocarlo en false
    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
    switch(currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return const HistorialMapasPage();
      
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return const DireccionesPage();

      default: return const HistorialMapasPage();
    }
  }
}