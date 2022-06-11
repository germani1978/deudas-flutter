import 'package:deudas/bloc/deudas_bloc.dart';
import 'package:deudas/screens/deuda_screen.dart';
import 'package:deudas/screens/deudas_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() => runApp( ChangeNotifierProvider(
                          create: ((context) => ChangeToDark()),
                          child: MyApp()
                      ));

class MyApp extends StatelessWidget {

  
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ChangeToDark>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => DeudasBloc()))
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          brightness:   !pro.dark ? Brightness.light : Brightness.dark,
          scaffoldBackgroundColor:  !pro.dark ? Theme.of(context).primaryColor : Color(0xFF02293C) ,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: 'panelDeuda',
        routes: {
          'panelDeuda' : (context) => const ListaDeudaScreen(),
          'deuda':(context) => const DeudaScreen(),
        },
      ),
    );
  }
}

class ChangeToDark with ChangeNotifier {
  bool dark = false;
  ChangeToDark();
  invertTheme(){
    dark = !dark;
   notifyListeners();
  }

}