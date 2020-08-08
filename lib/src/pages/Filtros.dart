import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_gpd_work/model/Ciudades.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/utils/Provider.dart';
import 'Home.dart';

// ignore: must_be_immutable
class Filtros extends StatefulWidget {
  Usuario userFirebase;

  Filtros({
    this.userFirebase,
  });

  @override
  _FiltrosState createState() => _FiltrosState();
}

class _FiltrosState extends State<Filtros> {
  bool masde10 = false;
  bool masde5 = false;
  bool masde1 = false;
  bool sinexperiencia = false;
  String city = "Altamira";

  bool star5 = false;
  bool star4 = false;
  bool star3 = false;
  bool star2 = false;
  bool star1 = false;
  double numberFilter = 1.0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final providerInfo = Provider.of<ProviderInfo>(context);

    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Color(0xFFFEFCFB),
              body: SingleChildScrollView(
                  child: Container(
                // height: height,
                width: width,
                //height: height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Filtros",
                            style: Utils.styleGreenTitle,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            userFirebase: widget.userFirebase,
                                          )));
                            },
                            child: Text(
                              "Cancelar",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Años de experiencia",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Column(
                        children: <Widget>[
                          materialRow("Mas de 10", masde10),
                          materialRow("Mas de 5", masde5),
                          materialRow("Mas de 1", masde1),
                          materialRow("Sin experiencia", sinexperiencia),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Ciudad",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey.withOpacity(0.10),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: SizedBox(),
                            items: Ciudades.citys.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (String item) {
                              city = item;
                              print(city);
                              print(item);

                              print(city);
                              setState(() {});
                            },
                            hint: Text(
                              city,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Calificación minima aceptada",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      materialRowStar(5, star5),
                      materialRowStar(4, star4),
                      materialRowStar(3, star3),
                      materialRowStar(2, star2),
                      materialRowStar(1, star1),
                      SizedBox(
                        height: 20.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: MaterialButton(
                          height: 45,
                          color: Utils.colorgreen,
                          onPressed: () async {
                            providerInfo.city = city;
                            providerInfo.number = numberFilter;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          userFirebase: widget.userFirebase,
                                        )));
                          },
                          minWidth: width,
                          child: Text(
                            "Guardar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
        ));
  }

  void backpress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  userFirebase: widget.userFirebase,
                )));
  }

  Widget materialRow(String title, bool bandera) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: bandera,
            onChanged: (bool newValue) {
              switch (title) {
                case "Mas de 10":
                  masde10 = true;
                  masde5 = false;
                  masde1 = false;
                  sinexperiencia = false;

                  break;
                case "Mas de 5":
                  masde10 = false;
                  masde5 = true;
                  masde1 = false;
                  sinexperiencia = false;

                  break;

                case "Mas de 1":
                  masde10 = false;
                  masde5 = false;
                  masde1 = true;
                  sinexperiencia = false;

                  break;

                case "Sin experiencia":
                  masde10 = false;
                  masde5 = false;
                  masde1 = false;
                  sinexperiencia = true;

                  break;

                default:
              }
              setState(() {});
            },
          ),
          Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
        ]);
  }

  Widget materialRowStar(int number, bool bandera) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: bandera,
            onChanged: (bool newValue) {
              switch (number) {
                case 5:
                  star5 = true;
                  star4 = false;
                  star3 = false;
                  star2 = false;
                  star1 = false;
                  numberFilter = 5.0;
                  break;
                case 4:
                  star5 = false;
                  star4 = true;
                  star3 = false;
                  star2 = false;
                  star1 = false;
                  numberFilter = 4.0;

                  break;

                case 3:
                  star5 = false;
                  star4 = false;
                  star3 = true;
                  star2 = false;
                  star1 = false;
                  numberFilter = 3.0;
                  break;

                case 2:
                  star5 = false;
                  star4 = false;
                  star3 = false;
                  star2 = true;
                  star1 = false;
                  numberFilter = 2.0;

                  break;
                case 1:
                  star5 = false;
                  star4 = false;
                  star3 = false;
                  star2 = false;
                  star1 = true;

                  numberFilter = 1.0;

                  break;

                default:
              }
              setState(() {});
            },
          ),
          if (number == 5) ...{
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
          } else if (number == 4) ...{
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Colors.grey),
          } else if (number == 3) ...{
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
          } else if (number == 2) ...{
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
          } else if (number == 1) ...{
            Icon(Icons.star, color: Utils.colorgreen),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
            Icon(Icons.star, color: Colors.grey),
          }
        ]);
  }
/* 
  Widget star(Color color){


    return Icon(Icons.star,color:color);
  } */
}
