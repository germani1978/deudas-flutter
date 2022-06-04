// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TituloInicio extends StatelessWidget {

  final String titulo;
  final bool left;

  const TituloInicio({
    Key? key, required this.titulo, this.left = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(titulo,
            style: TextStyle(
              color:Color(0xFF6956E4),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )));
  }
}

class BtnAddBottom extends StatelessWidget {
   final void Function() ? func;
  const BtnAddBottom({
    Key? key, this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Container(
          height: 50,
          width: 100,
          alignment: Alignment.center,
          child: const Text('Agregar',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),)
        ),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          shadowColor: Colors.blue,
          primary: Color(0xFF6956E4),
        ),
        onPressed: func
      ),
    );
  }
}

