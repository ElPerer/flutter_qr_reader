import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_model.dart';

Future<void> urlLaunch(BuildContext context, ScanModel scan) async {
  // final String url = scan.valor;

  if(scan.tipo!.contains('http')){
    final Uri url = Uri.parse(scan.valor);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  } else {

    //Usamos la clase Navigator con la extensión .pushNamed, el cual le mandamos el context, y el nombre del WIDGET que deseamos ir, y por último mandamos los argumentos 
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}