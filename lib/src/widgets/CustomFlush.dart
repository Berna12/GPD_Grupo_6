import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
// CLASE QUE RECREA LA NOTIFICACION
class CustomFlush {

  void showCustomBar(BuildContext context,String mensaje) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: Duration(milliseconds: 1500),
      title: "Mensaje",
      message: mensaje,
      icon: Icon(
        Icons.announcement,
        size: 28.0,
        color: Colors.blue[300],
      ),
    )..show(context);
  }

  
}