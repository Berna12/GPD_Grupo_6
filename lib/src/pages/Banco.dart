import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';
import 'Aprobado.dart';

class Banco extends StatefulWidget {
  Banco({this.file, this.data});
  Map data;
  File file;

  @override
  _BancoState createState() => _BancoState();
}

class _BancoState extends State<Banco> {
  bool deposito = false;
  bool tarjeta = false;
  TextEditingController controllerrecibo = new TextEditingController();

  TextEditingController controllertarjeta = new TextEditingController();
  TextEditingController controllerfecha = new TextEditingController();
  TextEditingController controllercodigo = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void backpress() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  SizedBox(
                    height: 20,
                  ),
                  materialRow(
                      "Deposito Bancario",
                      "Envíanos un deposito a la cuenta 8766552 en el Banco Popular " +
                          "o a la cuenta 2546456 del Banco de Reservas " +
                          "y coloca el numero de recibo aquí. Nosotros haremos la confirmación.",
                      width,
                      deposito),
                  SizedBox(
                    height: 20,
                  ),
                  materialRow("Tarjeta de Crédito", "", width, tarjeta),
                  SizedBox(
                    height: 20,
                  ),
                  CustomMaterialButton(
                    typebutton: false,
                    width: width * 0.40,
                    text: "Crear perfil",
                    function: save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save() async {
  
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Aprobado(
                    data: widget.data,
                    file: widget.file,
                    recibo: controllerrecibo.text.trim()
                  )));
    
  }


  Widget materialRow(String title, String text, double width, bool bandera) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: bandera,
          onChanged: (bool newValue) {
            //SE EVALUA QUE TITLE ESTA MARCANDO PARA MOVER LOS CHECK BOX
            switch (title) {
              case "Deposito Bancario":
                deposito = true;
                tarjeta = false;

                break;
              case "Tarjeta de Crédito":
                deposito = false;
                tarjeta = true;

                break;

              default:
            }
            setState(() {});
          },
        ),
        Container(
          height: 250,
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
                Text(
                  text,
                  textAlign: TextAlign.center,
                ),
                if (title == "Tarjeta de Crédito") ...[
                  Row(
                    children: <Widget>[],
                  ),
                  TextFieldWidget(
                    controller: controllertarjeta,
                    validator: "Tarjeta Requerido",
                    labelText: "Numero de tarjeta",
                    inputType: TextInputType.text,
                    bandera: true,
                  ),
                  TextFieldWidget(
                    controller: controllerfecha,
                    validator: "Fecha Requerido",
                    labelText: "Fecha de Vencimiento",
                    inputType: TextInputType.text,
                    bandera: true,
                  ),
                  TextFieldWidget(
                    controller: controllerfecha,
                    validator: "Codigo Requerido",
                    labelText: "Codigo cvc",
                    inputType: TextInputType.text,
                    bandera: true,
                  ),
                ] else ...[
                  TextField(
                      controller: controllerrecibo,
                      decoration: InputDecoration(
                        focusColor: Utils.colorgreen,
                        hintText: "Escribe el numero de recibo",
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
                      )),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
