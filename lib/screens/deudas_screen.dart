// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable

import 'dart:io';

import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/main.dart';
import 'package:deudas/models/deuda.dart';
import 'package:deudas/screens/deuda_screen.dart';
import 'package:deudas/services/service.dart';
import 'package:deudas/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class ListaDeudaScreen extends StatelessWidget  {
  const ListaDeudaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ChangeToDark>(context);

    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            elevation: 0,
            title: ListTile(
              leading: Text('Deudas',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
            ),
            actions: [
              MenuLateral(pro: pro),
            ],
          ),
          body: ListaDeudasWidget(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: BlocBuilder<DeudasBloc, DeudasState>(builder: (context, state) {
        final persons = state.personDeudas;
        return state.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListViewDeudores(persons: persons);
      }),
      // ),
    );
  }
}

class ListViewDeudores extends StatelessWidget {
  const ListViewDeudores({
    required this.persons,
  });
  final ListaPersonas persons;

  @override
  Widget build(BuildContext context) {

    final prov = Provider.of<ChangeToDark>(context); 


    return ListView.builder(
      itemCount: persons.lista.length,
      itemBuilder: ((context, index) => GestureDetector(
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeudaScreen(index: index)));
            }),
            onLongPress: () {
              BlocProvider.of<DeudasBloc>(context)
                  .add(EliminarPersonaDeuda(index));
            },
            child: Card(
                   
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   elevation:!prov.dark ? 10 : 0,
                   margin: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
                   color: !prov.dark ? Colors.white : Colors.white12,
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    )),
                title: Text(
                  persons.lista[index].nombre,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:FontWeight.w900,
                    color: Colors.blue
                  ),
                ),
                trailing: Text(
                  '\$ ${persons.lista[index].total()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                  ),
                ),
                subtitle: Text(
                  persons.lista[index].deudas.isEmpty
                      ? 'sin fecha'
                      : persons.lista[index].deudas[0].fecha,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class _BtnFinal extends StatelessWidget {
  const _BtnFinal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _contName = TextEditingController(text: '');
    TextEditingController _contDeuda = TextEditingController(
      text: '',
    );
    TextEditingController _contNota = TextEditingController(text: '');

    return BtnAddBottom(
      func: (() {
        showDialog(
            context: context,
            builder: (context) => alertDialogAddDeuda(
                  context,
                  _contName,
                  _contDeuda,
                  _contNota,
                ));
      }),
    );
  }

  AlertDialog alertDialogAddDeuda(
    BuildContext context,
    TextEditingController _contName,
    TextEditingController _contDeuda,
    TextEditingController _contNota,
  ) =>
      AlertDialog(
        content: SingleChildScrollView(child: FormOne()),
      );
}

//PRIMER FORMULARIO

class FormOne extends StatefulWidget {
  FormOne({Key? key}) : super(key: key);

  @override
  State<FormOne> createState() => _FormOneState();
}

class _FormOneState extends State<FormOne> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _contName = TextEditingController(text: '');
  final TextEditingController _contDeuda = TextEditingController(text: '');
  final TextEditingController _contNota = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
          padding: const EdgeInsets.all(10),
          // color: Colors.white,
          child: Column(
            children: [
              TextFormField(
                controller: _contName,
                keyboardType: TextInputType.text,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 20,
                decoration: const InputDecoration(
                    hintText: 'Ejemplo: Juan Perez',
                    helperText: 'Solo numeros',
                    labelText: 'Nombre'),
                onChanged: (value) {},
                validator: (source) {
                  return (source == null || source.isEmpty || source.length < 2)
                      ? 'Un nombre de mas de 2 caracteres'
                      : null;
                },
              ),
              TextFormField(
                controller: _contDeuda,
                keyboardType: TextInputType.number,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 9,
                decoration: const InputDecoration(
                    hintText: 'Ejemplo: 48.5',
                    helperText: 'Escriba cuanto le deben',
                    labelText: 'Deuda'),
                onChanged: (value) {},
                validator: (source) {
                  return (source == null ||
                          source.isEmpty ||
                          double.tryParse(source) == null)
                      ? 'Escriba un numero'
                      : null;
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
                decoration: const InputDecoration(
                    hintText: 'Ejemplo: Una nota..',
                    helperText: 'Algo para recordar(opcional)',
                    labelText: 'Nota'),
                onChanged: (value) {},
                validator: (source) {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (() {
                    if (formKey.currentState!.validate()) {
                      final nombre = _contName.text;
                      final deuda = _contDeuda.text;
                      String nota = _contNota.text;
                      if (nota.isEmpty) nota = 'sin nota';
                      final deudaState = BlocProvider.of<DeudasBloc>(context);
                      deudaState.add(AgregarPersonaDeuda(PersonaConDeuda(
                        nombre: nombre.toCapitalized(),
                        deudas: [Deuda(nota: nota, valor: double.parse(deuda))],
                      )));
                      _contName.text = '';
                      _contDeuda.text = '';
                      _contNota.text = '';
                      Navigator.pop(context);
                    }
                  }),
                  child: const Text('Agregar'))
            ],
          )),
    );
  }
}

class MenuLateral extends StatelessWidget {
  const MenuLateral({
    Key? key,
    required this.pro,
  }) : super(key: key);

  final ChangeToDark pro;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Compartir copia de Seguridad'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Cargar copia seguridad externa'),
                value: 2,
              ),
              PopupMenuItem(
                child: Text('Modo oscuro'),
                value: 3,
              ),
            ],
        onSelected: (int value) async {
          switch (value) {
            case 1:
              //cargar datos
              final String copiaSeguridad = await Datos().cargarDatos();

              //prepara el fichero copia.txt con los datos
              final path = (await getApplicationDocumentsDirectory()).path + '/copia.txt';
              File fileIn = File(path);
              await fileIn.writeAsString(copiaSeguridad);

              //comparte
              await Share.shareFiles([path], text: 'nada');

              break;

            case 2:
              //buscar el archivo con los datos en el telefono
              final result = await FilePicker.platform.pickFiles();

              if ( result == null ) return;

              //tomar el primer elemento
              final Platfile = result.files.first;

              //lo guarda en un File
              final File fileOut = File(Platfile.path!); 

              //extra el str
              String str = await (fileOut).readAsString() ;

              //salvar datos en SecureStotage
              Datos().salvarDatos(str);

              //actualizar
              BlocProvider.of<DeudasBloc>(context).add(CargarDeudas());

              break;

            case 3:
              pro.invertTheme();
              break;

            default:
          }
        });
  }
}