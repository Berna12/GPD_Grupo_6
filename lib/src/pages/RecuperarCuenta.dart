import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Home.dart';

class RecuperarCuenta extends StatefulWidget {
  @override
  _RecuperarCuentaState createState() => _RecuperarCuentaState();
}

class _RecuperarCuentaState extends State<RecuperarCuenta> {
  TextEditingController controllerEmail = new TextEditingController();

  TextEditingController controllerNumero = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  void backpress() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: CustomDrawer(),
        appBar: CustomBar(
          appBar: AppBar(),
          function: backpress,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: width,
              height: height * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text(
                        "Recuperar Cuenta",
                        style: Utils.styleGreenTitle,
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      TextFieldWidget(
                        controller: controllerEmail,
                        labelText: "Aquí tu correo electronico",
                        validator: "Correo Electronico requerido",
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "Se procederá a enviar a tu correo registrado el formulario para restablecer la contraseña",
                        textAlign: TextAlign.center,
                        style: Utils.styleGreenNormalText,
                      ),
                      SizedBox(height: 20),
                      CustomMaterialButton(
                        typebutton: false,
                        width: width * 0.50,
                        text: "Enviar información",
                        function: sendmessage,
                      ),
                      if (loading) ...[
                        CircularProgressIndicator()
                      ] else ...[
                        Container()
                      ],
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//TODO ESTA VALIDADO SE MOSTRARA UNA CIRCULAR PROGRESSINDICATOR MIENTRAS HACE EL ENVIO DEL CORREO
  void sendmessage() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
              email: controllerEmail.text.trim()) //aca se envia el correo
          .then((value) async {
        setState(() {
          loading = false;
        });
        CustomFlush().showCustomBar(context, "Correo Enviado.");

        Timer(Duration(seconds: 3), () {
          Navigator.pushNamed(context, "Home");
        });
      }).catchError((error) {
        //  se evalua si no tiene correo asociado
        setState(() {
          loading = false;
        });
        CustomFlush().showCustomBar(context, error.toString());
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      });
    } else {
      setState(() {
        loading = false;
      });
      CustomFlush().showCustomBar(context,
          "Completa los ampos y verifica que tus contraseñas sean iguales");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  void createMessageReport() {}
}
