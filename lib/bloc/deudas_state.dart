part of 'deudas_bloc.dart';

//State raiz
@immutable
abstract class DeudasState {
  //propiedades
  final ListaPersonas personDeudas;
  bool isLoading = false;

  //constructor
  DeudasState(this.personDeudas);
}

//State Inicial donde no hay deudas
class DeudasInitial extends DeudasState {
  DeudasInitial() : super(ListaPersonas([])){
    isLoading = true;
  }
}

//State donde se fijan las deudas
class SetDeuda extends DeudasState {
  SetDeuda({required ListaPersonas personDeudas}) : super( personDeudas ){
    isLoading = false;
    Datos().salvarDatos(personDeudas.toJson());    
  }
}


