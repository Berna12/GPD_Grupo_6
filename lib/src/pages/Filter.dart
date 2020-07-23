import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/TextFieldIcons.dart';

class Filter extends StatefulWidget {
  Filter({this.textosearch});
  String textosearch;
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.textosearch;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: TextIconsField(
                              controller: controller,
                              bandera: true,
                              hintText: "Información Requerida",
                            ),
                          ),
                        ),
                        MaterialButton(
                          child: Text("Cancelar"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('usuarios')
                            .where("oficios",
                                arrayContains: controller.text.trim())
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
                                      fontWeight: FontWeight.bold,fontSize: 15),
                                )
                              ],
                            );
                          }
                          return containerPersons(items, width);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget containerPersons(
    List<Usuario> items,
    double width,
  ) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom:15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Utils.colorgreen.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              width: width,
              height: 160,
              //color: Colors.red,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 160,
                    width: 150,
                    // color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipOval(
                        child: Image.network(
                          items[index].imagen,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //  color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              items[index].nombre,
                               overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("ESTRELLAS"),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                             
                              height: 35,
                              child: Text(items[index].espacio,
                              overflow: TextOverflow.fade,
                              
                                  style: TextStyle(fontSize: 14)),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  MaterialButton(
                                      minWidth: width * 0.22,
                                      elevation: 4,
                                      onPressed: () {},
                                      child: Text(
                                        "Abrir",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Utils.colorgreen),
                                  MaterialButton(
                                    elevation: 4,
                                    minWidth: width * 0.22,
                                    onPressed: () {},
                                    child: Text("Denunciar"),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
