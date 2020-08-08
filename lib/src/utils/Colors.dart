import 'package:flutter/material.dart';

//Colores y tamano de letras Para la app.... 
class Utils {
  static final colorgreen = Color(0xFF0066a8);

  static final styleGreenTitle = TextStyle(
      color: Utils.colorgreen, fontWeight: FontWeight.bold, fontSize: 30);

  static final styleGreenNormalText = TextStyle(
      color: Utils.colorgreen, fontWeight: FontWeight.w300, fontSize: 14);

  static final styleGreenTitleNormal = TextStyle(
      color: Utils.colorgreen, fontWeight: FontWeight.w600, fontSize: 22);

      static final stylegreytext  = TextStyle(
      color: Colors.black.withOpacity(.45), fontWeight: FontWeight.bold, fontSize: 13);

      static final styleWhite = TextStyle(color: Colors.white,fontSize: 14);

      static final stylebuttongrey = TextStyle(color: Colors.black.withOpacity(.45));

      static final colorContainergrey = Colors.grey.withOpacity(.45);
}
