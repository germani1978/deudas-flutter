import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/screens/deuda_screen.dart';
import 'package:deudas/screens/deudas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => DeudasBloc()))
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'panelDeuda',
        routes: {
          'panelDeuda' : (context) => ListaDeudaScreen(),
          'deuda':(context) => DeudaScreen(),
        },
      ),
    );
  }
}