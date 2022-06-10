import 'package:bloc/bloc.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/services/service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'deudas_event.dart';
part 'deudas_state.dart';

class DeudasBloc extends Bloc<DeudasEvent, DeudasState> {
  late Datos datos;
  // late FlutterSecureStorage storage;

  DeudasBloc() : super(DeudasInitial()) {

    on<CargarDeudas>((event, emit) async {
      datos = Datos();
      final js = await Datos().cargarDatos();
      if (js.isEmpty) {
         emit( SetDeuda(personDeudas: ListaPersonas([])));
      }
      else {
        emit( SetDeuda(personDeudas: ListaPersonas.fromJson(js)) );         
      }
      // emit( SetDeuda(personDeudas: ListaPersonas([])));
    });

    on<AgregarPersonaDeuda>((event, emit) {
      emit( SetDeuda(personDeudas: ListaPersonas([...state.personDeudas.lista, event.deuda])));
      
    });

    on<AgregarDeuda>((event, emit) {
      final personDeudas = state.personDeudas;
      personDeudas.lista[event.index].agregarDeuda(valor: event.deuda, nota: event.nota);
      emit( SetDeuda(personDeudas:ListaPersonas(personDeudas.lista)));
    });

    on<EliminaDeuda>((event, emit) {
      final personDeudas = state.personDeudas;
        personDeudas.lista[event.indexPersona].eliminarDeuda( event.indexDeuda);
      emit( SetDeuda(personDeudas:ListaPersonas(personDeudas.lista)));
    });
    on<EliminarPersonaDeuda>((event, emit) {
      final personaDeuda = state.personDeudas;
      personaDeuda.lista.removeAt(event.index);  
      emit( SetDeuda(personDeudas: ListaPersonas(personaDeuda.lista)));
    });
  }
}
