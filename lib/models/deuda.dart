import 'dart:convert';

import 'package:flutter_contacts/contact.dart';

//ClASE DEUDA 
class Deuda {
  int valor = 0;
  String fecha;
  String nota='';

  Deuda({required this.valor, this.nota ='', this.fecha=''}){
    DateTime fechaNow =  DateTime.now().toLocal();
    final hora = fechaNow.hour;
    final min = fechaNow.minute;
    final dia = fechaNow.day;
    final mes = fechaNow.month;
    final year = fechaNow.year.toString().substring(2,4);
    String result = '$hora:$min   $dia/$mes/$year';
    fecha = result;
  }

  factory Deuda.fromJson( String str) => Deuda.fromMap( json.decode(str) ); 
  factory Deuda.fromMap(Map map) => Deuda(  valor: map['valor'],nota: map['nota'],fecha: map['fecha']);  //en el json debe estar todos los campos

  toJson() => json.encode(toMap()); 
  Map<String, dynamic> toMap() => {
    "valor": valor,
    "nota":nota,
    "fecha": fecha
  };

  }



//ClASE PERSONA con DEUDAS
class PersonaConDeuda {
  String nombre;
  Contact? contact;
  List<Deuda> deudas = [];

  PersonaConDeuda({required this.nombre, required this.deudas});
  factory PersonaConDeuda.fromJson( String str ) => PersonaConDeuda.fromMap(json.decode(str));

  factory PersonaConDeuda.fromMap(Map<String, dynamic> json) => PersonaConDeuda(
    nombre : json['nombre'], 
    deudas : List<Deuda>.from( json['deudas'].map((x) => Deuda.fromMap(x)))
  );

  String toJson() =>  json.encode(toMap());
  Map<String,dynamic> toMap() => {
    "nombre": nombre,
    "deudas": List<dynamic>.from( deudas.map((e) => e.toMap()) )}; 

  PersonaConDeuda copyWith() {
    String? nombre;
    List<Deuda>? deudas;
    return PersonaConDeuda( nombre: nombre ?? this.nombre, deudas: deudas ?? this.deudas );
  }

  agregarDeuda({ required int valor, String nota =''}) {   deudas.add(Deuda(valor: valor, nota: nota)); }
  eliminarDeuda(int index) {   deudas.removeAt(index);}

  String total(){ 
    int sum = 0;deudas.forEach( (element) => sum+= element.valor);return sum.toString();
  }
}

class ListaPersonas {
  List<PersonaConDeuda> lista;

  ListaPersonas( this.lista);

  factory ListaPersonas.fromMap(Map<String, dynamic> json) => ListaPersonas(List<PersonaConDeuda>.from( json['lista'].map((persona) => PersonaConDeuda.fromMap( persona))));
  factory ListaPersonas.fromJson(String str) => ListaPersonas.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {'lista': List<dynamic>.from( lista.map((persona) => persona.toMap())),};
  String toJson() => json.encode(toMap());
  
}


void main(List<String> args) {
  final ListaPersonas y = ListaPersonas([
    PersonaConDeuda(nombre: 'Germani', deudas: [Deuda(valor: 50), Deuda(valor: 60), Deuda(valor: 70)]),
    PersonaConDeuda(nombre: 'Pedro', deudas: [Deuda(valor: 10), Deuda(valor: 20), Deuda(valor: 30)]),
  ]);

  // print(x);
  print(y.toJson());
  
}









 // DateTime berlinWallFell = new DateTime(1989, 11, 9);
 // DateTime moonLanding = DateTime.parse("1969-07-20 20:18:00"); // 8:18pm