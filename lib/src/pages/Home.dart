import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_gpd_work/model/Busquedas.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/services/stream_busquedas.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Usuario userFirebase;

  Home({
    this.userFirebase,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  String email;
  String password;

  @override
  void initState() {
    super.initState();

   /*  if (widget.userFirebase == null) {
      getAccountDefault();
    } */
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: CustomDrawer(
          userFirebase: widget.userFirebase,
        ),
        appBar: CustomBar(
          appBar: AppBar(),
          function: navigatorbackpress,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        height: 150,
                        width: 150,
                      ),
                      Text("GPD", style: Utils.styleGreenTitle),
                      SizedBox(height: 15),
                      Text(
                        "Buscar tu profesional, técnico o colaborador",
                        style: Utils.styleGreenNormalText,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: DataSearch(
                                  userFirebase: widget.userFirebase));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.search),
                            ),
                            height: 50,
                            width: width,
                            color: Colors.grey.withOpacity(0.15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomMaterialButton(
                        typebutton: false,
                        height: 50,
                        width: width * 0.50,
                        text: "Buscar",
                        function: searchJob,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text('Busqueda previas:'),
                      SizedBox(
                        height: 12.0,
                      ),
                      streamWidget(),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomMaterialButton(
                        typebutton: false,
                        width: width * 0.45,
                        text: "Politicas de uso",
                        function: changeWidget,
                      ),
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

  getAccountDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool boolValue = await prefs.getBool('value');

    if (boolValue == true) {
      email = await prefs.getString('email');
      password = await prefs.getString('password');

      setData();
    } else {}
  }

  void setData() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((currentUser) async => await Firestore.instance
                .collection("usuarios")
                .document(currentUser.user.uid)
                .get()
                .then((DocumentSnapshot result) async {
              Usuario user = Usuario.fromSnapshot(result);
              if (user.estado == "Activada") {
                widget.userFirebase = user;
                setState(() {});
              } else {
                CustomFlush().showCustomBar(context,
                    "Tu cuenta no esta activa debes esperar a que se verifique tu informacion");
              }
            }))
        .catchError((error) {
      CustomFlush().showCustomBar(context, error.toString());
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }).catchError((err) {
      CustomFlush().showCustomBar(context, err.toString());
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    });
  }

  void navigatorbackpress() {
    print("BACK TO PRESS IN HOME!");
  }

  void changeWidget() {
    /*  Navigator.push(
        context, MaterialPageRoute(builder: (context) => CalificacionPage())); */
  }

  void searchJob() async {
    showSearch(
        context: context,
        delegate: DataSearch(userFirebase: widget.userFirebase));
    /*  else {} */
  }

  //SE SOLICITA SE DE MANERA ASINCRONA LAS BUSQUEDAS
  Widget streamWidget() {
    return StreamBuilder(
        stream: Firestore.instance.collection('busquedas').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            // SE EVALUA SI NO TIENE REGISTROS O SI EXISTE ALGUN ERROR
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Busquedas items;
          if (snapshot.hasData) {
            items = Busquedas.fromMap(snapshot.data.documents[0]);
          }

          if (items.parametros.length == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return listChildrens(items);
          }
        });
  }

  Widget listChildrens(Busquedas items) {
    return ListView.builder(
      itemCount: items.parametros.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(items.parametros[index].oficio),
              Text(items.parametros[index].fecha)
            ],
          ),
        );
      },
    );
  }
}
