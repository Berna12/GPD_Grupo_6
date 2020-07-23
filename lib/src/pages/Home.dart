import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_gpd_work/model/Busquedas.dart';
import 'package:rep_gpd_work/src/pages/Filter.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Cuentas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
   final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: CustomBar(
        appBar: AppBar(),
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
                    Image.asset("assets/logo.png",height: 150,width: 150,),
                    Text("GPD", style: Utils.styleGreenTitle),
                    SizedBox(height: 15),
                    Text(
                      "Buscar tu profesional, técnico o colaborador",
                      style: Utils.styleGreenNormalText,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFieldWidget(
                      controller: controller,
                      hintText: "Agregar una profesión",
                      inputType: TextInputType.text,
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
    );
  }

  void changeWidget() {
 
  }

  void searchJob() async {
    if (_formKey.currentState.validate()) {
      var date = new DateTime.now(); //  TOMAR LA FECHA DEL DIA

      //APILAR LOS ELEMENTOS DE LA COLA
      QuerySnapshot snapshot =
          await Firestore.instance.collection('busquedas').getDocuments();  // SE SELECCIONA LOS DOCUMENTOS 

      Busquedas items = Busquedas.fromMap(snapshot.documents[0]); // SE BUSCA PARSEAR LOS REGISTROS ES UNA LISTA
      Parametro parametro = new Parametro();
      parametro.fecha = format.format(DateTime.parse(date.toString())); // SE PARSEA LA FECHA AL FROMATO
    
      parametro.oficio = controller.text.trim();
      //AGREGAR NUEVO ELEMENTO AL FINAL Y EMPUJAR LOS SIGUIENTES ELEMENTOS
      items.parametros[3] = items.parametros[2]; // SE ENCOLA EN LA PILA
      items.parametros[2] = items.parametros[1];
      items.parametros[1] = items.parametros[0];
      items.parametros[0] = parametro;

      Map data = items.toMap(); // SE SETEA EL MAPA
      Firestore.instance
          .collection("busquedas")
          .document(items.uid)
          .updateData(data)  // se actualiza el registr
          .then((value) => ({
            Navigator.push(context, MaterialPageRoute(builder: (context) => Filter(
              textosearch: controller.text.trim(), // y se lo pasamos a la pantalla donde podra ver esos registros por esa profesion. oficio, titulo.
            )),)
          }));
    } else {}
  }
  //SE SOLICITA SE DE MANERA ASINCRONA LAS BUSQUEDAS
  Widget streamWidget() {
    return StreamBuilder(
        stream: Firestore.instance.collection('busquedas').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError || !snapshot.hasData) { // SE EVALUA SI NO TIENE REGISTROS O SI EXISTE ALGUN ERROR
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Busquedas items = Busquedas.fromMap(snapshot.data.documents[0]);

          return listChildrens(items);
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
