import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Loading.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Home.dart';
import 'Perfil.dart';

class Reportar extends StatefulWidget {
  Reportar({this.userFirebase, this.report});
  Usuario userFirebase;
  Usuario report;

  @override
  _ReportarState createState() => _ReportarState();
}

class _ReportarState extends State<Reportar> {
  TextEditingController controllerNombre = new TextEditingController();
  TextEditingController controllerCiudad = new TextEditingController();
  TextEditingController controllerProfesion = new TextEditingController();
  TextEditingController controllerProblema = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      controllerNombre.text = widget.report.nombre;
      controllerCiudad.text = widget.report.ciudad;
      controllerProfesion.text = widget.report.espacio;
    }
  }

  void backpress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  userFirebase: widget.userFirebase,
                )));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: CustomDrawer(
          userFirebase: widget.userFirebase,
        ),
        appBar: CustomBar(
          appBar: AppBar(),
          function: backpress,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: width,
              //height: height * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      "Reportar Usuario",
                      style: Utils.styleGreenTitle,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: controllerNombre,
                      labelText: "Nombre del usuario que deseas reportar",
                      validator: "Nombre del usuario requerido",
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: controllerCiudad,
                      labelText: "Ciudad del usuario que deseas reportar",
                      validator: "Ciudad del usuario requerido",
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: controllerProfesion,
                      labelText: "Profesión u oficio del usuario a reportar",
                      validator: "Profesión del usuario requerida",
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      lenght: 8,
                      controller: controllerProblema,
                      labelText:
                          "Descríbenos cual fue el problema con este usuario",
                      validator: "Problema requerido",
                      inputType: TextInputType.text,
                    ),
                    /* Expanded(
                      child: Container(),
                    ), */
                    Text(
                      "Nuestro equipo verificara la información que nos has brindado y nos comunicaremos contigo en la mayor brevedad posible",
                      textAlign: TextAlign.center,
                      style: Utils.styleGreenNormalText,
                    ),
                    SizedBox(height: 20),
                    if (widget.userFirebase == null) ...[
                      Text(
                        "Debes por lo menos iniciar sesión para realizar un reporte.",
                        textAlign: TextAlign.center,
                        style: Utils.styleGreenNormalText,
                      ),
                      SizedBox(height: 5),
                      CircularProgressIndicator()
                    ] else ...[
                      CustomMaterialButton(
                        typebutton: false,
                        width: width * 0.50,
                        text: "Reportar",
                        function: send,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    controllerCiudad.clear();
    controllerNombre.clear();
    controllerProblema.clear();
    controllerProfesion.clear();
  }

  //ACA VAMOS A ENVIAR EL REPORTE SE VALIDA EL FORM Y SE CREA LA ESTRUCTURA
  //Y LISTO.
  void send() async {
    if (_formKey.currentState.validate()) {
      // VALIDACION DE COMPLETITUD DE LOS DATOS
      Loading().loading(
          context); // SE AGREGO UNA NUEVA UTILIDAD PARA EVITAR LA PROGRAMACION EN CADA CLASE.

      try {
        Firestore.instance.collection("reportes").document().setData({
          "nombre": controllerNombre.text.trim(),
          "ciudad": controllerCiudad.text.trim(),
          "profesion": controllerProfesion.text.trim(),
          "problema": controllerProblema.text.trim()
        }).then((result) {
          //SUCCESS
          Navigator.pop(context);

          CustomFlush().showCustomBar(context, "Reporte creado".toString());
          clear();

          Timer(Duration(seconds: 2), () {
            //NAVEGAR A LA OTRA PAGINA
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          userFirebase: widget.userFirebase,
                        )));
          });
        });
      } catch (exception) {
        Navigator.pop(context);

        CustomFlush().showCustomBar(context, exception.toString());
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
      print("SUCCESS");
    } else {
      Navigator.pop(context);
      CustomFlush().showCustomBar(context, "Debes completar los campos");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}
