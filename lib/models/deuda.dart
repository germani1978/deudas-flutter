import 'dart:convert';

// import 'package:flutter_contacts/contact.dart';

//ClASE DEUDA 
class Deuda {
  double valor = 0;
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
  List<Deuda> deudas = [];

  PersonaConDeuda({required this.nombre, required this.deudas});
  factory PersonaConDeuda.fromJson( String str ) => PersonaConDeuda.fromMap(json.decode(str));

  factory PersonaConDeuda.fromMap(Map<String, dynamic> json) => PersonaConDeuda(
    nombre : json['nombre'], 
    deudas : List<Deuda>.from( json['deudas'].map((x) => Deuda.fromMap(x))),
  );

  String toJson() =>  json.encode(toMap());
  Map<String,dynamic> toMap() => {
    "nombre": nombre,
    "deudas": List<dynamic>.from( deudas.map((e) => e.toMap()) ),
 }; 


  agregarDeuda({ required double valor, String nota =''}) {   deudas.add(Deuda(valor: valor, nota: nota)); }
  
  eliminarDeuda(int index) {   deudas.removeAt(index);}

  String total(){ 
    double sum = 0;
    for(var element in deudas) {sum+= element.valor;}
    return sum.toString();
  }
}

class ListaPersonas {
  List<PersonaConDeuda> lista;

  ListaPersonas( this.lista);

  factory ListaPersonas.fromMap(Map<String, dynamic> json) => ListaPersonas(List<PersonaConDeuda>.from( json['lista'].map((persona) => PersonaConDeuda.fromMap( persona))));
  factory ListaPersonas.fromJson(String str) => ListaPersonas.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {'lista': List<dynamic>.from( lista.map((persona) => persona.toMap())),};
  String toJson() => json.encode(toMap());

  String total() {
    double sum = 0;
    for(var element in lista) {sum+= double.parse(element.total());}
    return sum.toString();
  }
  
}

