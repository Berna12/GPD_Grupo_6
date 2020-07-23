import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/pages/Acceso.dart';
import 'src/pages/Cuentas.dart';
import 'src/pages/Filter.dart';
import 'src/pages/Home.dart';
import 'src/pages/Register.dart';

void main() {
  runApp(new MyApp());
}
//fgfdg
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GPD',
        color: Colors.green,
        initialRoute: 'Home',
        //MAPA DE RUTAS
        routes: {
          'Home': (BuildContext context) => Home(),
          'Cuentas': (BuildContext context) => Cuentas(),
          'Acceso': (BuildContext context) => AccesoPage(),
           'Filter': (BuildContext context) => Filter(),
        });
  }
}
