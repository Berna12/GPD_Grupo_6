import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';

//TEXTFIELD EDITADO Y PARAMETRIZADO PARA TODOS LOS CASOS

class TextFieldWidget extends StatelessWidget {
  final String validator;
  /* final IconData prefixIconData;
  final IconData suffixIconData; */
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool bandera;
  final int lenght;
  final String hintText;

  TextFieldWidget({
    this.validator,
    /*   this.prefixIconData,
    this.suffixIconData, */
    this.labelText,
    this.controller,
    this.inputType,
    this.lenght,
    this.bandera = true,
    this.hintText ="",

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '' + validator.toString();
        }
        return null;
      },
      //textAlign: TextAlign.center,
      keyboardType: inputType,
      maxLines:  lenght == null ? 1 : lenght,
      obscureText: validator == "Contraseña Requerido" ? true : false,
      controller: controller,
      cursorColor: Utils.colorgreen,
      textAlign: bandera == false ? TextAlign.center : TextAlign.start,
      style: bandera == true
          ? TextStyle(color: Utils.colorgreen, fontSize: 14)
          : TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
      decoration: InputDecoration(
        focusColor: Utils.colorgreen,
        fillColor: bandera == false ? Colors.transparent : null,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Utils.colorgreen,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color:Colors.white)
      ),
    );
  }
}
