// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

//La siguiente línea lo que hace es que toma el JSON str y crea una instancia del modelo
ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
    ScanModel({
        this.id,
        this.tipo,
        required this.valor,
        //Podemos poner condicionales de la siguiente manera, colocando las llaves en lugar del ;
    }) {
      if(valor.contains('http')) {
        tipo = 'http';
      } else {
        tipo = 'geo';
      }
    }

    //Estas son las propiedades de la clase ScanModel
    int? id;
    String? tipo;
    String valor;

    LatLng getLatLng(){
      final latlng = valor.substring(4).split(',');
      final lat = double.parse(latlng[0]);
      final lng = double.parse(latlng[1]);
      return LatLng(lat, lng);
    }

    //El siguiente fromJson lo que hace es si recibimos un JSON objeto de .... tipo String y valor dynamic los toma y crea una nueva instancia de la clase ScanModel
    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    //El siguiente es lo que retorna un mapa, toma la instancia de la clase y la pasa a un MAPA para SQFLite
    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };
}
