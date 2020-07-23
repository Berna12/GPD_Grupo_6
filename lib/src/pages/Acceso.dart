import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/pages/Perfil.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/Loader.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Cuentas.dart';
//hello
class AccesoPage extends StatefulWidget {
  @override
  _AccesoPageState createState() => _AccesoPageState();
}

class _AccesoPageState extends State<AccesoPage> {
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController(); // INPUTS
  //TextEditingController controllerPhone = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
   /*  controllerEmail.text = "edu@gmail.com";
    controllerPassword.text = "123456"; */
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      endDrawer: CustomDrawer(),
      //drawer: CustomDrawer(),
      appBar: CustomBar(
        appBar: AppBar(),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    //  mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Accede con tu perfil",
                        style: TextStyle(
                            color: Utils.colorgreen,
                            fontSize: 32,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFieldWidget(
                        controller: controllerEmail,
                        hintText: "Email o Número Requerido",
                        labelText: "Correo o Número telefónico",
                        inputType: TextInputType.emailAddress,
                        //prefixIconData: Icons.email,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        controller: controllerPassword,
                        hintText: "Contraseña Requerido",
                        labelText: "Contraseña",
                        inputType: TextInputType.text,
                        //prefixIconData: Icons.email,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomMaterialButton(
                        height: 55,
                        typebutton: true,
                        width: width,
                        text: "Entrar",
                        function: save,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      /*     Expanded(
                     child: Container(),
                   ), */
                      Text(
                        "Si un no tienes una cuenta, regístrate para empezar a recibir ofertas de trabajo.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Utils.colorgreen),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                   /*    Expanded(child: Container(),), */
                      CustomMaterialButton(
                        height: 45,
                        typebutton: false,
                        width: width*0.455,
                        text: "Registrarse",
                        function: navigator,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void navigator(){

     Navigator.push(context, MaterialPageRoute(builder: (context) => Cuentas(
             
            )));
  }

  Future<bool> loader() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ColorLoader3(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      loader();
      try {
        await FirebaseAuth.instance  // SE VALIDA SI EL USUARIO EXISTE
            .signInWithEmailAndPassword(
                email: controllerEmail.text.trim(),
                password: controllerPassword.text.trim())
            .then((currentUser) async => await Firestore.instance
                .collection("usuarios")
                .document(currentUser.user.uid)
                .get()
                .then((DocumentSnapshot result) async => ({
                      /*   localUser = await ClientDatabaseProvider.db
                          .getLocalData(controllerEmail.text.trim()), */
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PerfilPage(
                                    userFirebase: Usuario.fromSnapshot(result), // SE REALIZA EL DESMAPEO DEL DOCUMENTO.
                                  ))),
                    })))
            .catchError((error) {
          Navigator.pop(context);
          CustomFlush().showCustomBar(context, error.toString());
          Timer(Duration(seconds: 5), () {
            Navigator.pop(context);
          });
        }).catchError((err) {
          Navigator.pop(context);
          CustomFlush().showCustomBar(context, err.toString());
          Timer(Duration(seconds: 5), () {
            Navigator.pop(context);
          });
        });
      } on PlatformException catch (e) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, e.toString());
        Timer(Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      CustomFlush().showCustomBar(context, "Debes completar los campos");
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
  }
}
