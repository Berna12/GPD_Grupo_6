import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Provider.dart';
import 'package:rep_gpd_work/src/widgets/ContainerPerson.dart';

class DataSearch extends SearchDelegate {
  DataSearch({this.userFirebase});
  Usuario userFirebase;

  String selection = ""; //QUERY
  List<Usuario> data; // DAATA QUE SE MOSTRARA

  //METODO PARA SETEAR EL CLEAR DE LOS CAMPOS LA DATA Y EL QUERY SE LIMPIA
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), // LIMPIAR EL ECAMPO
        onPressed: () {
          print("CLICK");
          query = "";
          data = [];
        },
      )
    ];
  }

  //ICONO A LA IZQUIERDA PARA REGRESAR
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
      onPressed: () {
        print("LEADING ICCONSS");
        close(context, null);
      },
    );
  }

  //crear los resultados q mostrare
  @override
  Widget buildResults(BuildContext context) {
    if (data == null) {
      return Center(child: CircularProgressIndicator());
    } else if (data != null) {
      ContainerPersons(
        items: data,
        userFirebase: userFirebase,
        controller: query,
      );
    } else {
      ContainerPersons(
        items: data,
        userFirebase: userFirebase,
        controller: query,
      );
    }
    return ContainerPersons(
      items: data,
      userFirebase: userFirebase,
      controller: query,
    );
  }

  //SUGERENCIAS QUE HACE CUANDO LA PERSONA ESCRIBE
  @override
  Widget buildSuggestions(BuildContext context) {
    double numberLess;
    double numberBase;
    final providerInfo = Provider.of<ProviderInfo>(context);

    if (providerInfo.number == 1.0) {
      numberLess = 0.0;
    } else if (providerInfo.number == 2.0) {
      numberLess = 1.0;
    } else if (providerInfo.number == 3.0) {
      numberLess = 2.0;
    } else if (providerInfo.number == 4.0) {
      numberLess = 3.0;
    } else if (providerInfo.number == 5.0) {
      numberLess = 4.0;
    }

    print(numberLess);
      print(providerInfo.number);

    print(providerInfo.city);

    double width = MediaQuery.of(context).size.width;
    if (query.isEmpty) {
      return Container();
    }

    //Aqui DEBERIA ESTAR EL RANGO DE LA FECHA  1-2 , 2-3 3-4 4-5
    return StreamBuilder(
        stream: Firestore.instance
            .collection('usuarios')
            .where("oficios", arrayContains: query.toLowerCase())
            //.where("estado",isEqualTo: "Activada")
            .where("ciudad", isEqualTo: providerInfo.city)
            .where("rating", isLessThanOrEqualTo: providerInfo.number)
            .where("rating", isGreaterThanOrEqualTo: numberLess)
            .snapshots()
            .map(toUsersList),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Usuario> items = snapshot.data;
          if (items.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width,
                  height: 200,
                  child: Image.asset(
                    "assets/found.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  "ELEMENTOS NO ENCONTRADOS",
                  style: TextStyle(
                      color: Utils.colorgreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              ],
            );
          }

          data = items;
          return ContainerPersons(
            items: items,
            userFirebase: userFirebase,
            controller: query,
          );
        });
  }
}
