import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
//BOTON PERSONALIZADO
class CustomMaterialButton extends StatelessWidget {
  final String text;
  final Function function;
  final double width;
  final double height;
  final bool typebutton;
  CustomMaterialButton({this.text, this.function, this.width, this.typebutton,this.height});
//  obscureText: hintText == "Contraseña Requerido" ? true : false,
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 10,
      minWidth: width,
      height: height,
      color: typebutton == true ? Colors.white : Utils.colorgreen,
      shape: RoundedRectangleBorder(
        side: typebutton == true
            ? BorderSide(
                width: 0.75,
                color: Utils.colorgreen,
              )
            : BorderSide(
                width: 0.75,
                color: Utils.colorgreen,
              ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Text(
        text,
        style: typebutton == true
            ? TextStyle(color: Utils.colorgreen,fontSize: 14)
            : TextStyle(color: Colors.white,fontSize: 14),
      ),
      onPressed: function,
    );
  }
}

