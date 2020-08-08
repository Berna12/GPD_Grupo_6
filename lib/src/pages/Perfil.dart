import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rep_gpd_work/model/Ciudades.dart';
import 'package:rep_gpd_work/model/Usuario.dart';
import 'package:rep_gpd_work/src/pages/Home.dart';

import 'package:rep_gpd_work/src/utils/Clipper.dart';
import 'package:rep_gpd_work/src/utils/Colors.dart';
import 'package:rep_gpd_work/src/widgets/AppBar.dart';
import 'package:rep_gpd_work/src/widgets/CustomFlush.dart';
import 'package:rep_gpd_work/src/widgets/Drawer.dart';

import 'package:rep_gpd_work/src/widgets/MaterialButton.dart';
import 'package:rep_gpd_work/src/widgets/Textfield.dart';

import 'Aprobado.dart';
import 'Banco.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({this.userFirebase, this.account});
  Usuario userFirebase;
  String account;

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<PerfilPage> {
  TextEditingController controllerNombre = new TextEditingController();
  TextEditingController controllerEspacio = new TextEditingController();

  TextEditingController controllerPrimerOficio = new TextEditingController();
  TextEditingController controllerPrimerOficio2 = new TextEditingController();
  TextEditingController controllerPrimerOficio3 = new TextEditingController();
  TextEditingController controllerPrimerOficio4 = new TextEditingController();

  TextEditingController controllerEducacion1 = new TextEditingController();
  TextEditingController controllerEducacion2 = new TextEditingController();
  TextEditingController controllerEducacion3 = new TextEditingController();

  TextEditingController controllerexperiencia1 = new TextEditingController();
  TextEditingController controllerexperiencia2 = new TextEditingController();
  TextEditingController controllerexperiencia3 = new TextEditingController();
  TextEditingController controlleranualidad1 = new TextEditingController();
  TextEditingController controlleranualidad2 = new TextEditingController();
  TextEditingController controlleranualidad3 = new TextEditingController();

  TextEditingController controlleremail = new TextEditingController();
  TextEditingController controllerpagina = new TextEditingController();
  TextEditingController controllertelefono = new TextEditingController();

  //-----

  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerPassword2 = new TextEditingController();

  bool oficio2 = false;
  bool oficio3 = false;
  bool oficio4 = false;

  bool image = false;

  //final _formKey = GlobalKey<FormState>();

  File imgFile;
  String url;

  String city = "Altamira";

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {});

    imgFile = picture;

    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {});

    imgFile = picture;

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    //CONDICIONAL PARA USUARIO NUEVO Y USUARIO YA EXISTENTE MODULO IF
    // PARA RECONOCER SI EL USUARIO ESTA ACCEDIENDO AL SISTEMA DESDE EL REGISTRO O DESDE
    // EL INICIO DE SESION
    if (widget.userFirebase != null) {
      controllerPrimerOficio.text = widget.userFirebase.oficios[0];
      controllerPrimerOficio2.text = widget.userFirebase.oficios[1];
      controllerPrimerOficio3.text = widget.userFirebase.oficios[2];
      controllerPrimerOficio4.text = widget.userFirebase.oficios[3];
      controllerNombre.text = widget.userFirebase.nombre;
      controllerEspacio.text = widget.userFirebase.espacio;
      controllerEducacion1.text = widget.userFirebase.educacion1;
      controllerEducacion2.text = widget.userFirebase.educacion2;
      controllerEducacion3.text = widget.userFirebase.educacion3;
      controllerexperiencia1.text = widget.userFirebase.experiencia1;
      controllerexperiencia2.text = widget.userFirebase.experiencia2;
      controllerexperiencia3.text = widget.userFirebase.experiencia3;
      controlleranualidad1.text = widget.userFirebase.anualidad1;
      controlleranualidad2.text = widget.userFirebase.anualidad2;
      controlleranualidad3.text = widget.userFirebase.anualidad3;
      controlleremail.text = widget.userFirebase.email;
      controllerpagina.text = widget.userFirebase.pagina;
      controllertelefono.text = widget.userFirebase.telefono;
      city = widget.userFirebase.ciudad;
      widget.account = widget.userFirebase.tipocuenta;
    } else {
      /*      controllerPrimerOficio.text = "Primer oficio o Profesión";
      controllerPrimerOficio2.text = "Segundo oficio o Profesión";
      controllerPrimerOficio3.text = "Tercer oficio o Profesión";
      controllerPrimerOficio4.text = "Cuarto oficio o Profesión";
      controllerNombre.text = "Escribe tu nombre completo aquí";
      controllerEspacio.text = "Dinos algo sobre ti en este espacio"; */
    } // ANTERIOR ELSE PARA SETEAR LOS CAMPOS VISIBILES / INVISIBLES

//SETEAR LOS CAMPOS QUE DE SEDEBEN OCULTAR.
    switch (widget.account) {
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
    setState(() {});
    /*   */
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(
                          context); // se busca seleccionar que opcion escogio
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(
                          context); // se busca seleccionar que opcion escogio
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void backPress() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(userFirebase: widget.userFirebase)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            appBar: CustomBar(
              appBar: AppBar(),
              function: backPress,
            ),
            endDrawer: CustomDrawer(
              userFirebase: widget.userFirebase,
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        child: ClipShadowPath(
                            clipper: CircularClipper(),
                            shadow: Shadow(blurRadius: 20.0),
                            child: Container(
                              height: 350.0,
                              width: double.infinity,
                              color: Utils.colorgreen,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, top: 5.0, right: 25.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Presiona abajo para subir tu foto",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              decideImgView(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: 300,
                                child: TextFormField(
                                  controller: controllerNombre,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    hintText: "Escribe tu nombre completo aquí",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: 300,
                                child: TextFormField(
                                  controller: controllerEspacio,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    hintText:
                                        " Dinos algo sobre ti en este espacio",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              if (widget.account == "Premium") ...[
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 40,
                                ),
                                Text(
                                  "Profesional Verificado",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Container(
                            color: Utils.colorgreen,
                            height: 50,
                            width: width * 0.55,
                            child: TextFieldWidget(
                              controller: controllerPrimerOficio,
                              validator: "Oficio Requerido",
                              inputType: TextInputType.text,
                              bandera: false,
                              hintText: "Primer oficio o Profesión",
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Visibility(
                      visible: oficio2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                              color: Utils.colorgreen,
                              height: 50,
                              width: width * 0.55,
                              child: TextFieldWidget(
                                controller: controllerPrimerOficio2,
                                validator: "Oficio Requerido",
                                inputType: TextInputType.text,
                                bandera: false,
                                hintText: "Segundo oficio o Profesión",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Visibility(
                      visible: oficio3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                              color: Utils.colorgreen,
                              height: 50,
                              width: width * 0.55,
                              child: TextFieldWidget(
                                controller: controllerPrimerOficio3,
                                validator: "Oficio Requerido",
                                inputType: TextInputType.text,
                                bandera: false,
                                hintText: "Tercer oficio o Profesión",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Visibility(
                      visible: oficio4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Container(),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Container(
                              color: Utils.colorgreen,
                              height: 50,
                              width: width * 0.55,
                              child: TextFieldWidget(
                                controller: controllerPrimerOficio4,
                                validator: "Oficio Requerido",
                                inputType: TextInputType.text,
                                bandera: false,
                                hintText: "Cuarto oficio o Profesión",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Educación",
                            style: Utils.styleGreenTitleNormal,
                          ),
                          Text("Detalle tu educación en orden de relevancia"),
                          SizedBox(
                            height: 15,
                          ),
                          TextFieldWidget(
                            controller: controllerEducacion1,
                            validator: "Grado de Educacion Requerido",
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controllerEducacion2,
                            validator: "Grado de Educacion Requerido",
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controllerEducacion3,
                            validator: "Grado de Educacion Requerido",
                            inputType: TextInputType.text,
                          ),

                          //-----------EXPERIENCIA
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Experiencia",
                            style: Utils.styleGreenTitleNormal,
                          ),
                          Text("Detalle tu experiencia en orden de relevancia"),
                          SizedBox(
                            height: 15,
                          ),
                          TextFieldWidget(
                            controller: controllerexperiencia1,
                            validator: "Grado de Experiencia Requerido",
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Text("Años de experiencia"),
                              Container(
                                // color: Colors.red,
                                height: 25,
                                width: 70,
                                child: TextFieldWidget(
                                  controller: controlleranualidad1,
                                  validator: "Requerido",
                                  inputType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controllerexperiencia2,
                            validator: "Grado de Experiencia Requerido",
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Text("Años de experiencia"),
                              Container(
                                // color: Colors.red,
                                height: 25,
                                width: 70,
                                child: TextFieldWidget(
                                  controller: controlleranualidad2,
                                  validator: "Requerido",
                                  inputType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controllerexperiencia3,
                            validator: "Grado de Experiencia Requerido",
                            inputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              Text("Años de experiencia"),
                              Container(
                                height: 25,
                                width: 70,
                                child: TextFieldWidget(
                                  controller: controlleranualidad3,
                                  validator: "Requerido",
                                  inputType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ), //------
                          if (widget.userFirebase == null) ...[
                            Text(
                              "Contraseña",
                              style: Utils.styleGreenTitleNormal,
                            ),
                            Text("Establece la contraseña para tu cuenta"),
                            SizedBox(
                              height: 10,
                            ),
                            TextFieldWidget(
                              controller: controllerPassword,
                              validator: "Contraseña Requerido",
                              inputType: TextInputType.text,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFieldWidget(
                              controller: controllerPassword2,
                              validator: "Contraseña Requerido",
                              inputType: TextInputType.text,
                            ),
                          ],

                          ///-----------------

                          SizedBox(
                            height: 10,
                          ),
                          //-------------CONTACTO
                          Text(
                            "Contacto",
                            style: Utils.styleGreenTitleNormal,
                          ),
                          Text("Dinos por donde te podemos contactar"),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey[100],
                              padding: EdgeInsets.only(
                                  left: 15, right: 15.0, bottom: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Correo", style: Utils.stylegreytext),
                                  TextFieldWidget(
                                    controller: controlleremail,
                                    validator: "Email Requerido",
                                    inputType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Pagina", style: Utils.stylegreytext),
                                  TextFieldWidget(
                                    controller: controllerpagina,
                                    validator: "Pagina Requerido",
                                    inputType: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Telefono", style: Utils.stylegreytext),
                                  TextFieldWidget(
                                    controller: controllertelefono,
                                    validator: "Telefono Requerido",
                                    inputType: TextInputType.number,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Ciudad de residencia",
                                      style: Utils.stylegreytext),
                                  /* TextFieldWidget(
                                    controller: controllerciudad,
                                    validator: "Ciudad Requerido",
                                    inputType: TextInputType.text,
                                  ), */
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.10),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        items:
                                            Ciudades.citys.map((String value) {
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.userFirebase == null) ...[
                      Center(
                        child: CustomMaterialButton(
                          typebutton: false,
                          width: 150,
                          text: "Crear perfil",
                          function: save,
                        ),
                      ),
                    ] else ...[
                      Center(
                        child: CustomMaterialButton(
                          typebutton: false,
                          width: 150,
                          text: "Editar perfil",
                          function: edit,
                        ),
                      ),
                    ],
                  ]),
            ))),
      ),
    );
  }

  // SE DEBETOMAR EN CUANTO LA HORA Y FECHA DEL DIA COMO DATO UNICO ("PARA NOMBRAR LA FOOT")
  dynamic setimagen() async {
    var timeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE , hh:mm aaa');

    String date = formatDate.format(timeKey);
    String time = formatDate.format(timeKey);

    final StorageReference perfilImage =
        FirebaseStorage.instance.ref().child("Fotos");

    final StorageUploadTask uploadTask =
        perfilImage.child(timeKey.toString() + ".jpg").putFile(imgFile);
    var imageUrl = await (await uploadTask.onComplete)
        .ref
        .getDownloadURL(); // ESE NOMBRE LO MANTENDREMOS ALEOJADO EN ALGUN CAMPO DE LA BD
    //AGREGAR ESE REGISTRO A LA TABLA DE USUARIOS
    url = imageUrl.toString();
    return url;
  }

  void edit() async {
    print("press edit");
    if (controllerEspacio.text.isNotEmpty &&
        controllerNombre.text.isNotEmpty &&
        controlleremail.text.isNotEmpty) {
      Map<String, dynamic> data = {
        "tipocuenta": widget.account.toString(),
        if (imgFile == null) ...{
          "imagen": widget.userFirebase.imagen,
        } else if (imgFile != null) ...{
          //EDITA ESTO
          "imagen": await setimagen(),
        },
        "correo": controlleremail.text.trim(),
        "contraseña": controllerPassword.text.trim(),
        "nombre": controllerNombre.text.trim(),
        "espacio": controllerEspacio.text.trim(),
        "anualidad1": controlleranualidad1.text.trim(),
        "anualidad2": controlleranualidad2.text.trim(),
        "anualidad3": controlleranualidad3.text.trim(),
        "ciudad": city,
        "educacion1": controllerEducacion1.text.trim(),
        "educacion2": controllerEducacion2.text.trim(),
        "educacion3": controllerEducacion3.text.trim(),
        "experiencia1": controllerEducacion1.text.trim(),
        "experiencia2": controllerexperiencia2.text.trim(),
        "experiencia3": controllerexperiencia3.text.trim(),
        "oficios": [
          controllerPrimerOficio.text.trim().toLowerCase(),
          controllerPrimerOficio2.text.trim().toLowerCase(),
          controllerPrimerOficio3.text.trim().toLowerCase(),
          controllerPrimerOficio4.text.trim().toLowerCase()
        ],
        "pagina": controllerpagina.text.trim(),
        "telefono": controllertelefono.text.trim(),
      };

      Firestore.instance
          .collection("usuarios")
          .document(widget.userFirebase.uid)
          .updateData(data)
          .then((_) => {
                Firestore.instance
                    .collection("usuarios")
                    .document(widget.userFirebase.uid)
                    .get()
                    .then((DocumentSnapshot result) async => {
                          widget.userFirebase = Usuario.fromSnapshot(result),
                        }),
              });
      setState(() {});
    } else {
      print("else");
    }
  }
// SE DEBE EVALUAR TODAS LAS CONDICIONES
//ACTUALES

  Widget decideImgView() {
// SI EL USUARIO EXISTE PERO QUIERE CAMBIAR DE FOTO.
    if (imgFile != null && widget.userFirebase != null) {
      image = true;

      return ClipOval(
          child: Image.file(
        imgFile,
        height: 125,
        width: 125,
        fit: BoxFit.cover,
      ));
      // - NO EXISTEN EL REGISTRO DE ALGUNA FOTO ( REGISTRO - VACIO SE COLOCA LA IMAGEN NOT FOUND )
    } else if (imgFile == null && widget.userFirebase == null) {
      return GestureDetector(
          onTap: () {
            _showChoiceDialog(context);
          },
          child: ClipOval(
              child: Image.asset(
            "assets/found.png",
            height: 125,
            width: 125,
             fit: BoxFit.cover,
          )));
      // - YA EXISTE REGISTRO DE LA FOTO MAS NO ESTA LOGUEADO EL USUARIO
    } else if (imgFile != null && widget.userFirebase == null) {
      return ClipOval(
          child: Image.file(
        imgFile,
        height: 125,
        width: 125,
        fit: BoxFit.cover,
      ));
      // SI EL USUARIO EXISTE SETEAR LA FOTO
    } else if (widget.userFirebase != null) {
      return GestureDetector(
        onTap: () {
          _showChoiceDialog(context);
        },
        child: ClipOval(
            child: CachedNetworkImage(
          imageUrl: widget.userFirebase.imagen,
          placeholder: (context, url) => CircularProgressIndicator(),
          height: 125,
          width: 125,
            fit: BoxFit.cover,
        )),
      );
    }
  }
  // ANIMACION

// PARA GRABAR SE DEBE TOMAR EN CUENTA SI EXISTE CAMBIO EN LA FOTO O NO

  void save() async {
    if (controlleremail.text.isNotEmpty &&
        controllerPassword.text.isNotEmpty &&
        controllerPassword2.text.isNotEmpty &&
        controllerNombre.text.isNotEmpty &&
        imgFile != null &&
        controllerPassword.text == controllerPassword2.text) {
      Map<String, dynamic> data = {
        "tipocuenta": widget.account.toString(),
        "estado": widget.account == "Gratuita" ? "Activada" : "Desactivada",
        "imagen": imgFile,
        "correo": controlleremail.text.trim(),
        "contraseña": controllerPassword.text.trim(),
        "nombre": controllerNombre.text.trim(),
        "espacio": controllerEspacio.text.trim(),
        "anualidad1": controlleranualidad1.text.trim(),
        "anualidad2": controlleranualidad2.text.trim(),
        "anualidad3": controlleranualidad3.text.trim(),
        "ciudad": city,
        "educacion1": controllerEducacion1.text.trim(),
        "educacion2": controllerEducacion2.text.trim(),
        "educacion3": controllerEducacion3.text.trim(),
        "experiencia1": controllerEducacion1.text.trim(),
        "experiencia2": controllerexperiencia2.text.trim(),
        "experiencia3": controllerexperiencia3.text.trim(),
        "oficios": [
          controllerPrimerOficio.text.trim().toLowerCase(),
          controllerPrimerOficio2.text.trim().toLowerCase(),
          controllerPrimerOficio3.text.trim().toLowerCase(),
          controllerPrimerOficio4.text.trim().toLowerCase()
        ],
        "pagina": controllerpagina.text.trim(),
        "telefono": controllertelefono.text.trim(),
        "puntaje": 0,
        "totalvotos": 0,
        "rating": 0.0,
        "calificaciones": []
      };

      print(data);

      if (widget.account == "Gratuita") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Aprobado(
                      data: data,
                      file: imgFile,
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Banco(
                      data: data,
                      file: imgFile,
                    )));
      }

      setState(() {});
    } else {
      CustomFlush().showCustomBar(context,
          "Completa los campos y verifica que tus contraseñas sean iguales");
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }
}
