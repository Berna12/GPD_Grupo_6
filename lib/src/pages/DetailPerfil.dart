import 'dart:io';
import 'dart:typed_data';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/utils/Clipper.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/Clipper.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';
import 'package:rep_gpd_work/src/widgets/Options.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'Calificacion.dart';
import 'Home.dart';

class DetailPerfil extends StatefulWidget {
  Usuario userFirebase;
  Usuario dataperfil;

  DetailPerfil({
    this.userFirebase,
    this.dataperfil,
  });

  @override
  _DetailPerfilState createState() => _DetailPerfilState();
}

class _DetailPerfilState extends State<DetailPerfil> {
  bool oficio2 = false;
  bool oficio3 = false;
  bool oficio4 = false;
  File _imageFile;
  int value = 0;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    value = widget.dataperfil.calificaciones.length;
    print(value);
    switch (widget.dataperfil.tipocuenta) {
      case "Gratuita":
        oficio2 = false;
        oficio3 = false;
        oficio4 = false;

        break;
      case "Estándar":
        oficio2 = true;
        oficio3 = false;
        oficio4 = false;

        break;
      case "Premium":
        oficio2 = true;
        oficio3 = true;
        oficio4 = true;
        break;
      default:
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
    return Screenshot(
      controller: screenshotController,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          /*  floatingActionButton:  FoldableOptions(), */
          backgroundColor: Color(0xFFFEFCFB),
          endDrawer: CustomDrawer(
            userFirebase: widget.userFirebase,
          ),
          appBar: CustomBar(
            appBar: AppBar(),
            function: backpress,
          ),
          body: SingleChildScrollView(
            child: Container(
              // height: height,
              width: width,

              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            height: 250,
                            padding: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                                color: Utils.colorgreen,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red,
                                      blurRadius: 20,
                                      offset: Offset(0, 0))
                                ]),
                          )),
                      Positioned(
                        top: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: ClipOval(
                              child: CachedNetworkImage(
                            imageUrl: widget.dataperfil.imagen,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            height: 125,
                            width: 125,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      Positioned(
                        left: 150,
                        top: 50.0,
                        child: Container(
                          // color: Colors.red,
                          height: 200,
                          width: width * 0.62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.dataperfil.nombre,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text(widget.dataperfil.espacio,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              Text(widget.dataperfil.email,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              Row(
                                children: <Widget>[
                                  iconstar(),
                                  iconstar(),
                                  iconstar(),
                                  iconstar(),
                                  iconstar(),
                                  Text(
                                    widget.dataperfil.rating.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              if (widget.dataperfil.tipocuenta ==
                                  "Premium") ...[
                                Text(
                                  "Profesional verificado",
                                  style: Utils.styleWhite,
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      if (widget.userFirebase != null &&
                          widget.userFirebase.email !=
                              widget.dataperfil.email) ...[
                        Positioned(
                          bottom: -60,
                          right: 10,
                          child: Transform.rotate(
                            angle: (math.pi * 0.05),
                            child: FoldableOptions(
                              fshare: _takeScreenshotandShare,
                              fpost: enviarCalificacion,
                            ),
                          ),
                        ),
                      ] else ...[
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Transform.rotate(
                            angle: (math.pi * 0.05),
                            child: GestureDetector(
                              onTap: () async {
                                await _takeScreenshotandShare();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Color(0XFF212121),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    height: 335,
                    width: width,
                    child: PageView(
                      children: <Widget>[
                        Container(
                          //color: Colors.red,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildtitle("Oficios"),
                              SizedBox(height: 5.0),
                              buildExperienceRow(
                                  company: "1º Mi primer oficio",
                                  position: widget.dataperfil.oficios[0],
                                  icondata: FontAwesomeIcons.brain),
                              buildExperienceRow(
                                  company: "2º Mi segundo oficio",
                                  position: widget.dataperfil.oficios[1],
                                  icondata: FontAwesomeIcons.earlybirds),
                              buildExperienceRow(
                                  company: "3º Mi tercer oficio",
                                  position: widget.dataperfil.oficios[2],
                                  icondata: FontAwesomeIcons.heart),
                              buildExperienceRow(
                                  company: "4º Mi cuarto oficio",
                                  position: widget.dataperfil.oficios[3],
                                  icondata: FontAwesomeIcons.globe),
                            ],
                          ),
                        ),
                        Container(
                          //color: Colors.red,
                          //color:Colors.yellowAccent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildtitle("Educación"),
                              SizedBox(height: 5.0),
                              buildExperienceRow(
                                  company: "Nivel 1º",
                                  position: widget.dataperfil.educacion1,
                                  icondata: FontAwesomeIcons.school),
                              buildExperienceRow(
                                  company: "Nivel 2º",
                                  position: widget.dataperfil.educacion2,
                                  icondata: FontAwesomeIcons.university),
                              buildExperienceRow(
                                company: "Nivel 3º",
                                position: widget.dataperfil.educacion3,
                                icondata: FontAwesomeIcons.userGraduate,
                              )
                            ],
                          ),
                        ),
                        Container(
                          //color: Colors.red,
                          //color:Colors.yellowAccent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              buildtitle("Experiencia"),
                              SizedBox(height: 5.0),
                              buildExperienceRow(
                                  company: "Nivel 1º",
                                  position: widget.dataperfil.experiencia1,
                                  icondata: FontAwesomeIcons.briefcase),
                              buildExperienceRow(
                                  company: "Nivel 2º",
                                  position: widget.dataperfil.experiencia2,
                                  icondata: FontAwesomeIcons.building),
                              buildExperienceRow(
                                company: "Nivel 3º",
                                position: widget.dataperfil.experiencia3,
                                icondata: FontAwesomeIcons.laptopHouse,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void enviarCalificacion(){
    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalificacionPage(
                                                  dataPerfil: widget.dataperfil,
                                                  userFirebase: widget.userFirebase
                                                ))); 
  }

  Widget buildExperienceRow(
      {String company, String position, IconData icondata}) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 20.0),
        child: Icon(
          icondata,
          size: 20.0,
          color: Colors.blue[700],
        ),
      ),
      title: Text(
        company,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$position"),
    );
  }

  Widget buildtitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Utils.colorgreen),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  _takeScreenshotandShare() async {
    _imageFile = null; // SE OBLIGA EL NULL
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
        ; // SE ASIGNA LA FOTO
      });
      final directory = (await getApplicationDocumentsDirectory())
          .path; // SE CONVIERTE A UNA CADENA DE BYTES
      Uint8List pngBytes =
          _imageFile.readAsBytesSync(); // PARA QUE LA IMAGEN PUEDA VIAJAR
      File imgFile = new File(
          '$directory/screenshot.png'); // se obliga a tomar un directorio para guardarla
      imgFile.writeAsBytes(pngBytes); //  se escribe la imagen.

      await Share.file('Comparte la foto de este Perfil', 'screenshot.png',
          pngBytes, 'image/png'); // se prepara a compartir la imagen.
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget containerstyle(double width, String texto) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        alignment: Alignment.centerLeft,
        color: Utils.colorContainergrey,
        height: 50,
        width: width * 0.90,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            texto,
            style: Utils.stylebuttongrey,
          ),
        ),
      ),
    );
  }
}

Widget iconstar() {
  return Icon(
    Icons.star,
    color: Colors.yellow,
  );
}
/* 
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Screenshot(
      controller: screenshotController,
      child: WillPopScope(
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
              child: Container(
                  width: width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -50.0, 0.0),
                              child: ClipShadowPath(
                                  clipper: CircularClipper(),
                                  shadow: Shadow(blurRadius: 20.0),
                                  child: Container(
                                    height: 350.0,
                                    width: double.infinity,
                                    color: Utils.colorgreen,
                                  )),
                            ),
                            Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  ClipOval(
                                      child: CachedNetworkImage(
                                    imageUrl: widget.dataperfil.imagen,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    height: 125,
                                    width: 125,
                                    fit: BoxFit.cover,
                                  )),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(widget.dataperfil.nombre,
                                      style: Utils.styleWhite),
                                  Text(widget.dataperfil.espacio,
                                      style: Utils.styleWhite),
                                  Text(widget.dataperfil.email,
                                      style: Utils.styleWhite),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  if (widget.dataperfil.tipocuenta ==
                                      "Premium") ...[
                                    Icon(
                                      Icons.star,
                                      size: 35,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      "Profesional verificado",
                                      style: Utils.styleWhite,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Oficios",
                                style: Utils.styleGreenTitle,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.oficios[0].toString()),
                              SizedBox(
                                height: 5.0,
                              ),
                              Visibility(
                                visible: oficio2,
                                child: containerstyle(width,
                                    widget.dataperfil.oficios[1].toString()),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Visibility(
                                visible: oficio3,
                                child: containerstyle(width,
                                    widget.dataperfil.oficios[2].toString()),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Visibility(
                                  visible: oficio4,
                                  child: containerstyle(width,
                                      widget.dataperfil.oficios[3].toString())),
                              SizedBox(height: 10.0),
                              Text(
                                "Educación",
                                style: Utils.styleGreenTitle,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.educacion1.toString()),
                              SizedBox(
                                height: 5.0,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.educacion2.toString()),
                              SizedBox(
                                height: 5.0,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.educacion3.toString()),
                              Text(
                                "Experiencia",
                                style: Utils.styleGreenTitle,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.experiencia1.toString()),
                              SizedBox(
                                height: 5.0,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.experiencia2.toString()),
                              SizedBox(
                                height: 5.0,
                              ),
                              containerstyle(width,
                                  widget.dataperfil.experiencia3.toString()),
                              SizedBox(
                                height: 20.0,
                              ),
                              if (widget.dataperfil.calificaciones.length ==
                                  0) ...[
                                Center(
                                    child: Text(
                                        "Este perfil no posee calificaciones")),
                              ] else ...[
                                Text(widget
                                    .dataperfil.calificaciones[value-1].mensaje),
                                Text(widget
                                    .dataperfil.calificaciones[value-1].puntuacion
                                    .toString()),
                              ],
                              if (widget.userFirebase != null &&
                                  widget.userFirebase.email !=
                                      widget.dataperfil.email) ...[
                                Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        print(widget.dataperfil.uid);
                                        print(widget.userFirebase.uid);
                                  
                                      },
                                      child: AvatarGlow(
                                        glowColor: Utils.colorgreen,
                                        endRadius: 60.0,
                                        duration: Duration(milliseconds: 2000),
                                        repeat: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        child: Material(
                                          elevation: 8.0,
                                          shape: CircleBorder(),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[100],
                                            child: Icon(
                                              Icons.star,
                                              size: 50,
                                            ),
                                            radius: 30.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: MaterialButton(
                                            color: Utils.colorgreen,
                                            height: 50,
                                            minWidth: width * 0.50,
                                            onPressed: () async {
                                              await _takeScreenshotandShare();
                                            },
                                            child: Text(
                                              "Compartir perfil",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        )
                      ])),
            ),
          )),
    );
  } */

// SE EVALUA LA FOTO Y SE REALIZA LAS ACCIONES NECESARIAS PARA COMPARTIR.
