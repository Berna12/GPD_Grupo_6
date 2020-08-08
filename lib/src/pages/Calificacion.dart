import 'package:animated_widgets/animated_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:rep_gpd_work/model/Calificaciones.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';

class CalificacionPage extends StatefulWidget {
  Usuario userFirebase;
  Usuario dataPerfil;
  CalificacionPage({this.dataPerfil, this.userFirebase});
  @override
  _CalificacionPageState createState() => _CalificacionPageState();
}

class _CalificacionPageState extends State<CalificacionPage> {
  TextEditingController controllercomentario = new TextEditingController();
  final Duration animationDuration = Duration(milliseconds: 800);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  double animatedHeight = 0;
  List<bool> isSelected;
  bool showImproveTags = false;
  final _formKey = GlobalKey<FormState>();
  int ratingActual;
  final format = DateFormat("yyyy-MM-dd");
  void _onTap() async {
    if (_formKey.currentState.validate()) {
      print(widget.dataPerfil.calificaciones);
      //----------------------------------------------------------------------------------------------------------
      Calificaciones calificaciones = new Calificaciones();
      calificaciones.email = widget.userFirebase.email;
      calificaciones.mensaje = controllercomentario.text.trim();
      calificaciones.puntuacion = ratingActual;
      var date = new DateTime.now();
      calificaciones.fecha = format.format(DateTime.parse(date.toString()));
     


      widget.dataPerfil.totalvotos = widget.dataPerfil.totalvotos + 1;
      widget.dataPerfil.puntaje = widget.dataPerfil.puntaje + ratingActual;
      widget.dataPerfil.rating =
          widget.dataPerfil.puntaje / widget.dataPerfil.totalvotos;

      // print(calificaciones.toMap());

      List<Calificaciones> listado  = widget.dataPerfil.calificaciones;
      listado.add(calificaciones);
      

      widget.dataPerfil.calificaciones = listado;

      print(widget.userFirebase.toMap());

       Firestore.instance
          .collection("usuarios")
          .document(widget.dataPerfil.uid)
          .updateData(widget.dataPerfil.toMap());/* .then((value)  {

         Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(userFirebase: widget.userFirebase,)));
          });  */
   /*   
 */
      // AGREGAR LAS VARIABLES
      //print(calificaciones.toMap());
      //----------------------------------------------------------------------------------------------------------
        setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() =>
            rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
        Future.delayed(animationDuration, _goToNextPage);
      });
    } else {
      print(" " + controllercomentario.text.length.toString());
    }
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: NextPage(userFirebase: widget.userFirebase,)))
        .then((_) => setState(() => rect = null));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.0,
                ),
                RotationAnimatedWidget.tween(
                  enabled: showImproveTags,
                  rotationDisabled: Rotation.deg(z: 15),
                  rotationEnabled: Rotation.deg(z: 125.0),
                  duration: Duration(milliseconds: 600),
                  child: Container(
                    width: 200,
                    height: 200,
                    child: ClipPath(
                      clipper: StarClipper(
                        5,
                      ),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        color: showImproveTags
                            ? Colors.amber[600]
                            : Colors.grey[350],
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 35,
                              left: 40,
                              child: CircleAvatar(
                                maxRadius: 120,
                                backgroundColor: Colors.white24,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Comparte tu experiencia",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Utils.colorgreen),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 50, left: 50, top: 3, bottom: 8),
                  child: Text(
                    "Ayúdanos a mejorar tu experiencia con los usuarios compartiendo tus opiniones",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                RatingBar(
                  itemSize: 30,
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingActual = rating.toInt();
                    showImproveTags = true;
                    animatedHeight = 260;
                    print(ratingActual);
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    height: animatedHeight,
                    child: TranslationAnimatedWidget.tween(
                      enabled: showImproveTags,
                      duration: Duration(milliseconds: 500),
                      translationDisabled: Offset(0, 100),
                      translationEnabled: Offset(0, 0),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Text(
                              "Escribe tu comentario",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Utils.colorgreen),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Introduce un comentario';
                                        }
                                        if (value.length <= 5) {
                                          return 'Mas largo..';
                                        }
                                        return null;
                                      },
                                      controller: controllercomentario,
                                      maxLines: 8,
                                      decoration: InputDecoration.collapsed(
                                          hintText:
                                              "Introduce tu comentario aquí.."),
                                    ),
                                  ),
                                  color: Colors.grey[300].withOpacity(0.95),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: RectGetter(
                    key: rectGetterKey,
                    child: showImproveTags
                        ? OpacityAnimatedWidget.tween(
                            enabled: showImproveTags,
                            opacityDisabled: 0,
                            duration: Duration(milliseconds: 1000),
                            opacityEnabled: 1,
                            child: ButtonTheme(
                                buttonColor: Utils.colorgreen,
                                height: 48,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.60,
                                child: RaisedButton(
                                    onPressed: _onTap,
                                    child: Text(
                                      "Realizar comentario",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ))),
                          )
                        : Container(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

class NextPage extends StatefulWidget {
  Usuario userFirebase;
   NextPage({this.userFirebase});
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  bool _feedback = false;
  bool _thank = false;
  bool _btn = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.colorgreen,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleAnimatedWidget.tween(
                enabled: true,
                duration: Duration(milliseconds: 600),
                animationFinished: (value) {
                  setState(() {
                    _feedback = true;
                  });
                },
                scaleDisabled: 0.5,
                scaleEnabled: 1,
                child: Icon(
                  LineAwesomeIcons.check_circle_o,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TranslationAnimatedWidget.tween(
                enabled: _feedback,
                translationDisabled: Offset(0, -12),
                translationEnabled: Offset(0, 0),
                child: OpacityAnimatedWidget.tween(
                  enabled: _feedback,
                  opacityDisabled: 0,
                  animationFinished: (value) {
                    setState(() {
                      _thank = true;
                    });
                  },
                  duration: Duration(milliseconds: 800),
                  opacityEnabled: 1,
                  child: Text(
                    "Comentario Enviado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              OpacityAnimatedWidget.tween(
                enabled: _thank,
                opacityDisabled: 0,
                animationFinished: (value) {
                  setState(() {
                    _btn = true;
                  });
                },
                duration: Duration(milliseconds: 500),
                opacityEnabled: 1,
                child: Text(
                  "Gracias por dejar tus sinceros comentarios.",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              OpacityAnimatedWidget.tween(
                enabled: _btn,
                opacityDisabled: 0,
                duration: Duration(milliseconds: 500),
                opacityEnabled: 1,
                child: CustomMaterialButton(
                  //height: 55,
                  typebutton: true,
                  width: 150,
                  text: "Entrar",
                  function: save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userFirebase: widget.userFirebase,)));
  }
}
