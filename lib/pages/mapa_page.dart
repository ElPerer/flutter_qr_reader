import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/scan_model.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final Completer<GoogleMapController> _controller = Completer();

  MapType mapType = MapType.normal;

  
  @override
  Widget build(BuildContext context) {

    //Esto es para recibir o leer la información que nos envia en pushNamed(arguments: valor), de la siguiente manera leemos o rezibimos la información
    //TODO: IMPORTANTE: Para convertir los datos que recibimos por parámetros a uno en especifico es necesario colocar el "as" para darle como un alias
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition puntoInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17.5,
      tilt: 50
    );

    //Marcadores
    final Set<Marker> markers = Set<Marker>();
    markers.add( Marker(markerId: const MarkerId('geo-location'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_pin),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: scan.getLatLng(), zoom: 17.5, tilt: 50)));
            },
          )
        ],
      ),
      body: GoogleMap(
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.layers),
        onPressed: () {
          if(mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }

          //El siguiente método llamado setState nos sirve para redibujar el WIDGET
          setState(() {
            
          });
        },
      ),
    );
  }
}