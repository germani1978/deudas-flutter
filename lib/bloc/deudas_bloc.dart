import 'package:bloc/bloc.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/services/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

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

    on<AgregarContact>((event, emit) {
        final personDeudas = state.personDeudas;
        personDeudas.lista[event.index].contact = event.contacto;
        print('uno');
        emit( SetDeuda(personDeudas:ListaPersonas(personDeudas.lista)));
        print('dos');
    });

    on<AgregarDeuda>((event, emit) {
      final personDeudas = state.personDeudas;
      personDeudas.lista[event.index].agregarDeuda(valor: event.deuda, nota: event.nota);
      emit( SetDeuda(personDeudas:ListaPersonas(personDeudas.lista)));
    });

    on<EliminaDeuda>((event, emit) {
      final personDeudas = state.personDeudas;
      // if (personDeudas[event.indexPersona].deudas.length > 1) {
        personDeudas.lista[event.indexPersona].eliminarDeuda( event.indexDeuda);
      // } else {
        // personDeudas.removeAt(event.indexDeuda);
      // }
      emit( SetDeuda(personDeudas:ListaPersonas(personDeudas.lista)));
    });
    on<EliminarPersonaDeuda>((event, emit) {
      final personaDeuda = state.personDeudas;
      personaDeuda.lista.removeAt(event.index);  
      emit( SetDeuda(personDeudas: ListaPersonas(personaDeuda.lista)));
    });
  }
}
