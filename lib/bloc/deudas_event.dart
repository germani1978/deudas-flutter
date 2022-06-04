part of 'deudas_bloc.dart';

@immutable
abstract class DeudasEvent {}

class CargarDeudas extends DeudasEvent {}

class AgregarPersonaDeuda extends DeudasEvent {
  final PersonaConDeuda deuda;
  AgregarPersonaDeuda(this.deuda);
}

class AgregarContact extends DeudasEvent {
  final int index;
  final Contact contacto;
  AgregarContact({required this.index, required this.contacto});
}

class AgregarDeuda extends DeudasEvent {
  final int index;
  final int deuda;
  final String nota;
  AgregarDeuda({required this.index, required this.deuda, required this.nota});
}

class EliminaDeuda extends DeudasEvent {
  final int indexPersona, indexDeuda;
  EliminaDeuda({required this.indexPersona, required this.indexDeuda});
}

class EliminarPersonaDeuda extends DeudasEvent {
  final int index;
  EliminarPersonaDeuda(this.index);
}
