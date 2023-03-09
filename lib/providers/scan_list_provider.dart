//Este provider será el que nos ayudará a manejar la información de La BD en la aplicación

import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/models/scan_model.dart';
import 'package:flutter_qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  //El String valor que recibimos como parámetro es el mismo que será cuando leamos el código QR
  Future<ScanModel> nuevoScan(String valor) async{

    //Recibmos el valor que tenemos de argumento y se lo mandamos al Modelo que ya tenemos creado y aún no lo inserta en la BD
    final nuevoScan = ScanModel(valor: valor);

    //Para insertarlo hacemos lo siguiente, mandando como parámetro la instancia del Modelo ScanModel, el cual ya tiene el id, tipo, y el valor
    //Recordemos que el método llamado nuevoScan instanciado de la clase DBProvider regresa el último ID que se insertó
    final id = await DBProvider.db.nuevoScan(nuevoScan);

    //Aquí le asinamos el ID al registro que se halla creado
    nuevoScan.id = id;

    //Aquí indicamos si el tipo que que viene es igual a http se añade a la lista, a la BD ya fue insertado anteriormente
    if(tipoSeleccionado == nuevoScan.tipo) {

      //Aquí añadimos la información a la lista que tenemos creada en la parte superior de forma global
      scans.add(nuevoScan);

      //Aquí notificamos a cualquier WIDGET que contenga la instancia de ScanModel y de DBProvider cuando cambie la información
      notifyListeners();
    }
    return nuevoScan;
  }

  cargarScans() async{

    //El tipo que retorna el método getAllScans es un Future<List<ScanModel>> pero con el await solo toma o solo recupera el List<ScanModel>
    final scans = await DBProvider.db.getAllScans();

    //Aquí añadimos toda la lista de la BD a la lista de scans que tenemos definida globalmente
    if(scans != null) {
      this.scans = [...scans];
    }
  }

  cargarScansPorTipo (String tipo) async{

    //El DBProvider es el que se encarga de hacer las interacciones con la Base de Datos
    final scans = await DBProvider.db.getScansPorTipo(tipo);
    if(scans != null) {
      this.scans = [...scans];
      tipoSeleccionado = tipo;
      notifyListeners();
    }
  }

  borrarTodos() async{
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  borrarScansPorId(int id) async {
    await DBProvider.db.deleteScan(id);
    // cargarScansPorTipo(tipoSeleccionado);
  }
}