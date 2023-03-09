import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({Key? key, required this.tipo}) : super(key: key);

  final String tipo;

   @override
   Widget build(BuildContext context){
    //Normalmente cuando estamos dentro de un Build si se pone el listen en true, ya se tiene por defecto
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    //El siguiente WIDGET lo que hace es construirme una lista, requiere dos propiedades obligatorias, el contador de items itemCount y el itemBuilder lo que construye la lista
    return ListView.builder(
      itemCount: scans.length,

      //El WIDGET Dismissible nos permite deslizar el elemento de la lista que deseemos, este necesita una propiedad requerida
      itemBuilder: (_, index) => Dismissible(

        //La propiedad necesaria en el WIDGET Dismissible es el key, el cual requiere una llave unica para poder borrar ese elemento, en este caso usamos el método UniqueKey()
        key: UniqueKey(),

        //La propiedad background del WIDGET Dismissible nos permite colocar un color en la parte de atras del elemento a eliminar solo cuando deslizamos
        background: Container(
          color: Colors.redAccent
        ),

        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false).borrarScansPorId(scans[index].id!);
        },

        //El ListTile es lo que nos permite ver los items en forma de listas, y el itemBuilder que es la propiedad del ListView.builder es lo que construye esas listas
        child: ListTile(
      
          //Las propiedad son las siguientes, leading es para añadir un icono a la izquierda y trailing a la derecha, se pueden colocar ternarios dentro de Icon
          leading: Icon( tipo.contains('geo') ? Icons.map : Icons.compass_calibration, color: Theme.of(context).primaryColor,),
          title: Text(scans[index].valor),
          subtitle: Text(scans[index].id.toString()),
          trailing: const Icon(Icons.arrow_right_rounded),
          onTap: () => urlLaunch(context, scans[index]),
        ),
      ),

    );
   }
}