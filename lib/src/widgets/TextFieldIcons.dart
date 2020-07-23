import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';

//TEXTFIELD EDITADO Y PARAMETRIZADO PARA TODOS LOS CASOS

class TextIconsField extends StatelessWidget {
  final String hintText;
  /* final IconData prefixIconData;
  final IconData suffixIconData; */
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool bandera;

  TextIconsField({
    this.hintText,
    /*   this.prefixIconData,
    this.suffixIconData, */
    this.labelText,
    this.controller,
    this.inputType,
    this.bandera = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return '' + hintText.toString();
        }
        return null;
      },
      //textAlign: TextAlign.center,
      keyboardType: inputType,
      obscureText: hintText == "Contraseña Requerido" ? true : false,
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
        prefixIcon: Icon(
          Icons.search,
          size: 25,
          color: Utils.colorgreen,
        ),
        suffixIcon: Icon(
          Icons.tune,
          size: 25,
        ),
        /* prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Utils.colorgreen,
        ), */
      ),
    );
  }
}
