// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/main.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class DeudaScreen extends StatelessWidget {
  const DeudaScreen({Key? key, this.index=0 }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: containerDeudas(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _BtnAgregarDeuda( index: index ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        backgroundColor: Colors.indigo,
        elevation: 5,
        leadingWidth: 40,
        title: BlocBuilder<DeudasBloc, DeudasState>(
           builder: (context, state) {
            final name = state.personDeudas.lista[index].nombre;
            return Text(name, style:TextStyle(color:Colors.white, fontSize: 22,fontWeight: FontWeight.w500));  
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
               child: Text('\$$total ', style:TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w400)),
             );
           },
                  ),
         ),
       ],
      );
  }

  Container containerDeudas() {
    return Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          // color: Colors.white,
        ),
        child: BlocBuilder<DeudasBloc, DeudasState>(builder: (context, state) {
            final persona = state.personDeudas.lista[index];
            return ListView.builder(
                itemCount: persona.deudas.length,
                itemBuilder: (context, i) => containerDeuda(context, i, persona));
          }
        )
      );
  }

  Card containerDeuda(BuildContext context, int i, PersonaConDeuda persona) {
    
    final prov = Provider.of<ChangeToDark>(context); 

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation:!prov.dark ? 10 : 0,
      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
      color: !prov.dark ? Colors.white : Colors.white12,
      child: GestureDetector(
          onLongPress: () {
            BlocProvider.of<DeudasBloc>(context).add(EliminaDeuda(indexPersona: index, indexDeuda: i));
          },
          child: Container(

            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text('\$ ${persona.deudas[i].valor}', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800, color: Colors.blue)),
              // title: Text(persona.deudas[i].valor.toString(), style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: Colors.black)),
              trailing : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(persona.deudas[i].fecha,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.blueGrey)),
                  Text(persona.deudas[i].nota,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.blue)),        
                ],
              ),
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

    TextEditingController _contDeuda = TextEditingController( text: '');
    TextEditingController _contNota = TextEditingController( text: '');

    return BtnAddBottom(
      func: () {
        showDialog(
            context: context,
            builder: (context) => alertDialogAddDeuda(_contDeuda, _contNota, context, index));
      },
    );
  }

 
  AlertDialog alertDialogAddDeuda(
    TextEditingController _contDeuda,
    TextEditingController _contNota,
    BuildContext context,
   int index
  ) => AlertDialog( content: SingleChildScrollView(child: FormTwo(index)),);
  }

  //SEGUNDO FORMULARIO

class FormTwo extends StatefulWidget {
  FormTwo ( this.index );
  final int index;

  @override
  State<FormTwo> createState() => _FormTwoState();
}

class _FormTwoState extends State<FormTwo> {

  final TextEditingController _contDeuda = TextEditingController(text: '');
  final TextEditingController _contNota = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(10),
        //color: Colors.white,
        child: Column(
          children: [
            TextFormField(
              controller: _contDeuda,
              keyboardType: TextInputType.number,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 9,
              style: TextStyle( fontSize: 17),
              decoration: const InputDecoration(
                hintText: 'Ejemplo: 48.5',
                helperText: 'Escriba cuanto le deben',
                labelText: 'Deuda'
              ),
              onChanged: (value) {},
              validator: (source) {
                // if (source != null && source.length < 3)  return 'Muy Corta';
                if (source == null || source.isEmpty || double.tryParse(source) == null)  return 'Escriba un numero';
              },
            ),
            TextFormField(
              controller: _contNota,
              keyboardType: TextInputType.text,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 20,
              style: TextStyle( fontSize: 17),
              decoration: const InputDecoration(
                hintText: 'Ejemplo: Una nota..',
                helperText: 'Para recordar',
                labelText: 'Nota'
              ),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: (() {
              if ( formKey.currentState!.validate() ) {
                  final deuda = _contDeuda.text;
                  String nota = _contNota.text;
                  if (nota.isEmpty) nota = 'sin nota';
                  final deudaState = BlocProvider.of<DeudasBloc>(context);
                  deudaState.add( AgregarDeuda(index: widget.index, deuda: double.parse(deuda), nota: nota)  ); 
                   _contDeuda.text ='';
                  _contNota.text ='';
                   Navigator.pop(context);
              
              }
            }), 
            child: Text('Add'))
          ],
        )),
    );
  }
}



