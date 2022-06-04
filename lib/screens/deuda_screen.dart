// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/screens/deudas_screen.dart';
import 'package:deudas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeudaScreen extends StatelessWidget {
  const DeudaScreen({Key? key, this.index=0 }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: ContainerDeudas(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _BtnAgregarDeuda( index: index ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        leadingWidth: 35,
        title: BlocBuilder<DeudasBloc, DeudasState>(
           builder: (context, state) {
            final name = state.personDeudas.lista[index].nombre;
            return Text('$name', style:TextStyle(color:Colors.white, fontSize: 17,fontWeight: FontWeight.bold));  
          },
       ),
       actions: [
         Align(
           alignment: Alignment.center,
           child: BlocBuilder<DeudasBloc, DeudasState>(
             builder: (context, state) {
             final total = state.personDeudas.lista[index].total();
             return Padding(
               padding: const EdgeInsets.only( right: 20),
               child: Text('\$$total ', style:TextStyle(color:Colors.white, fontSize: 17,fontWeight: FontWeight.bold)),
             );
           },
                  ),
         ),
       ],
      );
  }

  Container ContainerDeudas() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: BlocBuilder<DeudasBloc, DeudasState>(builder: (context, state) {
            final persona = state.personDeudas.lista[index];
            return ListView.builder(
                itemCount: persona.deudas.length,
                itemBuilder: (context, i) => ContainerDeuda(context, i, persona));
          }
        )
      );
  }

  Card ContainerDeuda(BuildContext context, int i, PersonaConDeuda persona) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      color: Colors.blueGrey[50],
      child: GestureDetector(
          onLongPress: () {
            BlocProvider.of<DeudasBloc>(context).add(EliminaDeuda(indexPersona: index, indexDeuda: i));
          },
          child: ListTile(
            title: Text(persona.deudas[i].valor.toString(), style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            trailing : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(persona.deudas[i].fecha,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey)),
                Text(persona.deudas[i].nota,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.blue)),        
              ],
            ),
          ),
        ),
    );
  }
}



class _BtnAgregarDeuda extends StatelessWidget {
  final int index;
  const _BtnAgregarDeuda({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController _textEditingControllerDeuda = TextEditingController();
    TextEditingController _textEditingControllerNota = TextEditingController();

    return BtnAddBottom(
      func: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deuda',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.blue)),
                        TextField(controller: _textEditingControllerDeuda,decoration: InputDecoration(hintText: 'Escriba la deuda(numero)',hintStyle: TextStyle( color: Colors.grey)),),
                        SizedBox( height: 20, ),
                        Text('Notas',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: Colors.blue)),
                        TextField(controller: _textEditingControllerNota,decoration: InputDecoration(hintText: 'Escriba la nota(opcional)',hintStyle: TextStyle( color: Colors.grey)),),SizedBox( height: 20, ),
                      ],
                    ),
                  ),
                  actions: [
                     Container(
                       alignment: Alignment.center,
                       child: BtnAddBottom(func: () {
                           final deuda = _textEditingControllerDeuda.text;
                           final nota = _textEditingControllerNota.text;
                           if (int.tryParse(deuda) != null ) {
                             //TODO: agrega deuda a persona index
                             final deudaBloc = BlocProvider.of<DeudasBloc>(context);
                             deudaBloc.add( AgregarDeuda(index: index, deuda: int.parse(deuda), nota: nota == '' ? 'sin nota' : nota));
                           } 
                           Navigator.pop(context);
                          }),
                     ),
                   ],
                ));
      },
    );
  }
}


