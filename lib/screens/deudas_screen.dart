// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/screens/deuda_screen.dart';
import 'package:deudas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ListaDeudaScreen extends StatelessWidget {
  const ListaDeudaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            elevation: 0,
            title: ListTile(leading:  Text('Deudas',  style: TextStyle( fontSize: 21, color: Colors.white, fontWeight: FontWeight.w400 ))),
          ),
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              children: [
                ListaDeudasWidget(),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _BtnFinal(),
        ),
      ),
    );
  }
}

class ListaDeudasWidget extends StatefulWidget {

  @override
  State<ListaDeudasWidget> createState() => _ListaDeudasWidgetState();
}

class _ListaDeudasWidgetState extends State<ListaDeudasWidget> {

@override
  void initState() {
    BlocProvider.of<DeudasBloc>(context).add(CargarDeudas());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, 
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: BlocBuilder<DeudasBloc, DeudasState>(builder: (context, state) {
          final persons = state.personDeudas;
          return state.isLoading
              ? Center(child: CircularProgressIndicator(),)
              : ListViewDeudores(persons: persons);
        }),
      ),
    );
  }
}

class ListViewDeudores extends StatelessWidget {

  const ListViewDeudores({required this.persons,});
  final ListaPersonas persons;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: persons.lista.length,
        itemBuilder: ((context, index) => 
          GestureDetector(
            onTap: (() { Navigator.push(context,MaterialPageRoute(builder: (context) => DeudaScreen( index: index))); }),
            onLongPress: () { BlocProvider.of<DeudasBloc>(context).add( EliminarPersonaDeuda(index) ); },
            child: ListTile(
              leading: GestureDetector(
                child: persons.lista[index].contact == null ||  persons.lista[index].contact!.photo == null 
                        ?  CircleAvatar(backgroundColor: Colors.indigo,child: Icon(Icons.face))
                        :  CircleAvatar( backgroundImage : Image.memory(persons.lista[index].contact!.photo!).image ),
                onTap:() async {
                          if (await FlutterContacts.requestPermission()) {

                            final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);

                            if (contacts.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(children: [
                                        Container(
                                          height: 500,
                                          width: 400,
                                          child: ListView.builder(
                                            itemCount: contacts.length,
                                            itemBuilder: ((context, index) {
                                              Contact contact = contacts[index];
                                              return Card(
                                                color: Colors.grey[100],
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage: contact.photo !=null
                                                        ? Image.memory(contact.photo!).image : null,
                                                    child: contact.photo == null ? Icon(Icons.face) : null,
                                                  ),
                                                  title: Text(contact.name.first),
                                                  trailing:Text(contact.phones.first.number),
                                                  subtitle: const Text('Nombre'),
                                                  visualDensity: VisualDensity.compact,
                                                  onTap: () {
                                                     BlocProvider.of<DeudasBloc>(context).add(AgregarContact(index: index, contacto: contact));
                                                     Navigator.pop(context); 
                                                  },
                                                ),
                                              );
                                            }),
                                          ),
                                        )
                                      ]));
                            }
                  }
                },        
              ),
              title: Text(persons.lista[index].nombre,style: TextStyle(fontSize: 16,color: Colors.black,),),
              trailing: Text('\$${persons.lista[index].total()}',style: TextStyle(fontSize: 15,color: Colors.black,),),
              subtitle: Text( 
                persons.lista[index].deudas.isEmpty ? 'sin fecha' :  persons.lista[index].deudas[0].fecha,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9d9fa4),
                ),
              ),
            ),
          )),
      );
  }
}

// class ContactPhoneListView extends StatelessWidget {
//   ContactPhoneListView(this.func);

//   // List<Contact>? contacts;
//   final Function func;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future:
//             FlutterContacts.getContacts(withProperties: true, withPhoto: true),
//         builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           List<Contact>? contacts = snapshot.data;

//           return
//           Navigator.pop(context);
//         });
//   }
// }



class _BtnFinal extends StatelessWidget {
  const _BtnFinal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _contName = TextEditingController();
    TextEditingController _contDeuda = TextEditingController();
    TextEditingController _contNota = TextEditingController();

    return BtnAddBottom(
      func: (() {
        showDialog(
            context: context,
            builder: (context) => alertDialogAddDeuda(_contName, _contDeuda, _contNota, context));
      }),
    );
  }

  AlertDialog alertDialogAddDeuda(TextEditingController _contName, TextEditingController _contDeuda, TextEditingController _contNota, BuildContext context) {
    return AlertDialog(
                content: Container(
                  height: 295,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      alertDialogTitle('Nombre'),
                      inputDiaolog(_contName, 'Escriba el nombre'),
                      espacioVertical(),
                      alertDialogTitle('Deuda'),
                      inputDiaolog(_contDeuda, 'Escriba la deuda'),
                      espacioVertical(),
                      alertDialogTitle('Notas'),
                      inputDiaolog(_contNota, 'Escriba la nota(opcional)'),
                      espacioVertical(),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context) => SimpleDialog(
                          ));
                        }, 
                        child: Text('Contact'),
                      )
                    ],
                  ),
                ),
                actions: [
                  Container(
                    alignment: Alignment.center,
                    child: BtnAddBottom(func: () {
                      final nombre = _contName.text;
                      final deuda = _contDeuda.text;
                      String nota = _contNota.text;
                      if (nota.isEmpty) nota = 'sin nota';
                      if (int.tryParse(deuda) != null) {
                        final deudaState = BlocProvider.of<DeudasBloc>(context);
                        deudaState.add( AgregarPersonaDeuda( PersonaConDeuda(nombre: nombre, deudas: [ Deuda(nota: nota, valor: int.parse(deuda))] ,) ) ); 
                       
                      }
                      Navigator.pop(context);
                    }),
                  ),
                ],
              );
  }

  TextField inputDiaolog(TextEditingController _cont, String hint) {
    return TextField(
                      // autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _cont,
                      decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: TextStyle(color: Colors.grey)),
                    );
  }

  SizedBox espacioVertical() {
    return SizedBox(height: 10);
  }

  Text alertDialogTitle( String titulo) {
    return Text(titulo,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: Colors.blue));
  }
}
