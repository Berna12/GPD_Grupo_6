import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/pages/Perfil.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Loading.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
//prueva

import 'Cuentas.dart';

class AccesoPage extends StatefulWidget {
  @override
  _AccesoPageState createState() => _AccesoPageState();
}

class _AccesoPageState extends State<AccesoPage> {
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword =
      new TextEditingController(); // INPUTS
  //TextEditingController controllerPhone = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool bandera = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    /*  controllerEmail.text = "edu@gmail.com";
    controllerPassword.text = "123456"; */
  }

  void backtoPressArrow() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: CustomDrawer(),
        //drawer: CustomDrawer(),
        appBar: CustomBar(
          appBar: AppBar(),
          function: backtoPressArrow,
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
                          validator: "Email o Número Requerido",
                          labelText: "Correo electronico",
                          inputType: TextInputType.emailAddress,
                          //prefixIconData: Icons.email,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFieldWidget(
                          controller: controllerPassword,
                          validator: "Contraseña Requerido",
                          labelText: "Contraseña",
                          inputType: TextInputType.text,
                          //prefixIconData: Icons.email,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: bandera,
                                  onChanged: (bool value) {
                                    //SE EVALUA QUE TITLE ESTA MARCANDO PARA MOVER LOS CHECK BOX
                                    bandera = value;
                                    print(bandera);
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  "Recordar tu contraseña",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "RecuperarCuenta");
                              },
                              child: Text(
                                "¿Olvidastes tu contraseña?",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ],
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
                          width: width * 0.455,
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
      ),
    );
  }

  setDefaultAccount() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setBool('value', bandera);

    prefs.setString('email', controllerEmail.text.trim());

    prefs.setString('password', controllerPassword.text.trim());
  }

  void navigator() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Cuentas()));
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      Loading().loading(context);
      try {
        await FirebaseAuth.instance // SE VALIDA SI EL USUARIO EXISTE
            .signInWithEmailAndPassword(
                email: controllerEmail.text.trim(),
                password: controllerPassword.text.trim())
            .then((currentUser) async => await Firestore.instance
                    .collection("usuarios")
                    .document(currentUser.user.uid)
                    .get()
                    .then((DocumentSnapshot result) async {
                  setDefaultAccount();
                  Usuario user = Usuario.fromSnapshot(
                      result); // SE REALIZA EL DESMAPEO DEL DOCUMENTO.
                  if (user.estado == "Activada") {
                    //SE EVALUA EL ESTADO DE LA CUENTA
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilPage(
                                  userFirebase: user,
                                )));
                  } else {
                    Navigator.pop(context);
                    CustomFlush().showCustomBar(context,
                        "Tu cuenta no esta activa debes esperar a que se verifique tu informacion");
                    Timer(Duration(seconds: 2), () {
                      FirebaseAuth.instance.signOut().then((value) => {
                            Navigator.pushReplacementNamed(context, "Home"),
                          });
                    });
                  }
                }))
            .catchError((error) {
          Navigator.pop(context);
          CustomFlush().showCustomBar(context, error.toString());
          Timer(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        }).catchError((err) {
          Navigator.pop(context);
          CustomFlush().showCustomBar(context, err.toString());
          Timer(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        });
      } on PlatformException catch (e) {
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, e.toString());
        Timer(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
    } else {
      CustomFlush().showCustomBar(context, "Debes completar los campos");
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }
}
