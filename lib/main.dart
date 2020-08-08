import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Login.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Provider.dart';
import 'src/pages/Cuentas.dart';
import 'src/pages/Home.dart';
import 'src/pages/RecuperarCuenta.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Usuario userFirebase;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderInfo(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPD',
          color: Utils.colorgreen,
          initialRoute: 'Home',
          //MAPA DE RUTAS
          routes: {
            'Home': (BuildContext context) => Home(),
            'Cuentas': (BuildContext context) => Cuentas(),
            'Acceso': (BuildContext context) => AccesoPage(),
            'RecuperarCuenta': (BuildContext context) => RecuperarCuenta(),
          }),
    );
  }
}
