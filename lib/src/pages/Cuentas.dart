import 'package:flutter/material.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';

import 'Perfil.dart';

class Cuentas extends StatefulWidget {


  @override
  _CuentasState createState() => _CuentasState();
}

class _CuentasState extends State<Cuentas> {
  bool gratis = false;
  bool estandar = false;
  bool premium = false;
  String tipocuenta = "";




  void backpress(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; //GET ANCHO DE LA PANTALLA
    return WillPopScope(
      onWillPop: () async=>false ,
          child: Scaffold(
        endDrawer: CustomDrawer(),
        //drawer: CustomDrawer(),
        appBar: CustomBar(
          appBar: AppBar(),
          function: backpress,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Selecciona el tipo de cuenta que deseas",
                        textAlign: TextAlign.justify,
                        style: Utils.styleGreenTitle),
                    SizedBox(
                      height: 20,
                    ),
                    materialRow(
                        "Gratuita",
                        "",
                        "Veras anuncios debes en cuando y solo podras agregar un oficio o profesion",
                        width,
                        gratis),
                    SizedBox(
                      height: 20,
                    ),
                    materialRow(
                        "Estándar",
                        "Pago Unico US5",
                        "No veras anuncios y  podrás agregar dos oficios o profesiones",
                        width,
                        estandar),
                    SizedBox(
                      height: 20,
                    ),
                    materialRow(
                        "Premium",
                        "Pago Unico US10",
                        "No veras anuncios, podrás agregar todos los oficios o profesiones que quieras y te contactaremos para mostrarte como un profesional verificado, lo cual aumentara tus ofertas laborales...",
                        width,
                        premium),
                    SizedBox(
                      height: 10,
                    ),
                    CustomMaterialButton(
                      height: 40,
                      typebutton: false,
                      width: width * 0.45,
                      text: "Continuar",
                      function: changeWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeWidget() {
    Navigator.push(
        (context),
        MaterialPageRoute(
            builder: (context) => PerfilPage(
                  account: tipocuenta,
                )));
  }

  Widget materialRow(
      String title, String pago, String text, double width, bool bandera) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: bandera,
          onChanged: (bool newValue) {
            switch (title) {
              case "Gratuita":
                gratis = true;
                estandar = false;
                premium = false;
                tipocuenta = "Gratuita";
                break;
              case "Estándar":
                gratis = false;
                estandar = true;
                premium = false;
                tipocuenta = "Estándar";
                break;
              case "Premium":
                gratis = false;
                estandar = false;
                premium = true;
                tipocuenta = "Premium";
                break;
              default:
            }
            setState(() {});
          },
        ),
        Container(
          height: 180,
          width: width * 0.70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Utils.colorgreen)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  title,
                  style: Utils.styleGreenTitle,
                ),
                Text(pago),
                Text(text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
