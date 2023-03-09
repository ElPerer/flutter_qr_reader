import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_reader/providers/scan_list_provider.dart';
import 'package:flutter_qr_reader/utils/utils.dart';
import 'package:provider/provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //El siguiente WIDGET nos crea un botón flotante, en la parte derecha inferior de la pantalla, esto lo coloca de la manera por defecto de la aplicación
    //Requiere la propiedad onPressed como obligatoria, y su child, puede ser cualquier WIDGET, por ahora será un ícono, para que el botón tenga un ícono
    return FloatingActionButton(
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {

        //EL siguiente WIDGET necesita varios parámetros, el primero es el color de la ralla, el segundo es el nombre que tendrá el botón para salir de la cámara
        //El tercero es si queremos activar el flash de la cámara y el último el tipo de escaner que usaremos, en este caso es el ScanMode.QR
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancelar', false, ScanMode.QR);
        //String barcodeScanRes = 'geo:19.203008,-104.682449';

        if(barcodeScanRes == '-1') {
          return;
        }

        //Instanciamos toda la clase y obtenemos los métodos de ScanListProvider
        //UN PUNTO IMPORTANTE ES QUE NO SE PUEDE REDIBUJAR UN MÉTODO DARÍA ERROR, POR LO TANTO COLOCAMOS LA PROPIEDAD listen en false
        //La siguiente línea se traduce en busca en el arbol de WIDGETS la clase ScanListProvider
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
        final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);

        urlLaunch(context, nuevoScan);
      },
    );
  }
}