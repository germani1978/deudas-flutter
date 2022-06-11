// ignore_for_file: prefer_const_constructors

import 'package:deudas/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TituloInicio extends StatelessWidget {

  final String titulo;
  final bool left;

  const TituloInicio({
    Key? key, required this.titulo, this.left = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(titulo,
        style: TextStyle(
          color:Color(0xFF6956E4),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ));
  }
}

class BtnAddBottom extends StatelessWidget {


   final void Function() ? func;
   BtnAddBottom({
    Key? key, this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ChangeToDark>(context);
    
    return ElevatedButton(
      child: Container(
        height: 45,
        width: 85,
        alignment: Alignment.center,
        child: const Text('Agregar',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),),
      ),
      style: ElevatedButton.styleFrom(
        primary:  !pro.dark ? Theme.of(context).primaryColor :  Color(0xFF02293C),
        shape: StadiumBorder(),
        //shadowColor: Colors.indigo,
        
      ),
      onPressed: func,
    );
  }
}

  Text alertDialogTitle( String titulo) {
    return Text(titulo,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: Colors.indigo));
  }


  SizedBox espacioVertical() {
    return SizedBox(height: 10);
  }


 // TextFormField inputDiaolog(TextEditingController _cont, String hint, {bool autoFocus = false,bool checkReal = false, int? maxLines}) {

class InputDialog extends StatefulWidget {

  InputDialog( this._cont, this.hint, this.maxLines, { this.autoFocus = false, this.checkReal = false});

  TextEditingController _cont;
  String hint;
  bool autoFocus;
  bool checkReal;
  int? maxLines;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
   bool isNumReal = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
                      onChanged: widget.checkReal 
                        ? (value){
                            double.tryParse(value) == null 
                              ? { isNumReal = false }
                              : { isNumReal = true };
                            setState(() {});
                          }
                        : null,
                      textCapitalization: TextCapitalization.sentences,
                      controller: widget._cont,
                      autofocus: widget.autoFocus,
                      maxLength: widget.maxLines,
                      decoration: InputDecoration(
                          errorText: !widget.checkReal
                                       ? null
                                       : isNumReal 
                                             ? null
                                             : 'Error',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo)
                          ),
                          hintText: widget.hint,
                          hintStyle: TextStyle(color: Colors.grey)),

                    );


  }
}


extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}


