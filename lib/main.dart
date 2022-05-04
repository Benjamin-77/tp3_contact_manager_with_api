import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'package:tp3_api/models/user.dart';
import 'package:tp3_api/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tp Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Contacts'),
    );
  }
}

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$         Home Page          $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String photoPath = "assets/images/photosProfil/";
  List<User> _users = [];
  // This function is used to fetch all data from the database
  void _refreshUsers() async {
    final data = await SQLHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUsers(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    _refreshUsers();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Contacts')));
            },
            icon: Icon(Icons.home),
          ),
          SizedBox(width: 10),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistrationPage()));
        },
        label: const Text(
          'Nouveau contact',
        ),
        icon: const Icon(
          Icons.person_add_alt_1,
          size: 40,
        ),
        backgroundColor: Colors.indigo,
        extendedPadding: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
      ),
      body: _users.isNotEmpty
          ? ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _users.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    shadowColor:
                    MaterialStateProperty.all<Color>(Colors.white24),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                              id: _users[index].getId(),
                            )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          child: _users[index].getPhoto() == "null"
                              ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.indigo,
                          )
                              : ClipOval(
                            child: Image.file(
                              File(_users[index].getPhoto()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          _users[index].getFirstName() +
                              " " +
                              _users[index].getLastName(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(_users[index].getPhone()),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          })
          : Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Save-Contacts",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
              SizedBox(
                height: 10,
              ),
              /* CircularProgressIndicator(
                      color: Colors.indigo,
                      semanticsLabel: 'Chargement...',
                    ),*/
              SizedBox(
                height: 10,
              ),
              Image(image: AssetImage("assets/images/accueil.jpg")),
              SizedBox(
                height: 10,
              ),
              Text(
                "Vous n'avez aucun contact",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$         Registration          $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  User user = User();
  Map<String, dynamic> json = {};

  File? image;
  String path = "null";
  String profilText = "Sélectionnez une image de profil";

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
      path = image.path;
      profilText = "Une image sélectionnée";
    });
  }

  bool isObscurePassword = true;
  var _firtNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _addresseController = TextEditingController();
  var _mailController = TextEditingController();
  var _birthdayController = TextEditingController();
  var _citationController = TextEditingController();
  String _genderController = "Masculin";

  // Insert a new journal to the database
  Future<void> _addUser() async {
    refresh();
    user = await SQLHelper.createUser(user);
  }

  void refresh() {
    json = {
      'id': 0,
      'firstName': _firtNameController.text,
      'lastName': _lastNameController.text,
      'gender': _genderController,
      'phone': _phoneController.text,
      'adresse': _addresseController.text,
      'mail': _mailController.text,
      'birthday': _birthdayController.text,
      'citation': _citationController.text,
      'photo': path
    };
    user = User.fromJson(json);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Contacts')));
            },
            icon: Icon(Icons.home),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Ajouter un nouveau contact",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.indigo),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Stack(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1)),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: path == "null"
                              ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                              : ClipOval(
                            child: Image.file(
                              File(path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: Colors.indigo,
                          ),
                          child: Icon(
                            Icons.photo_camera_back,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(profilText),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField("First Name", "Nom", false,
                          _firtNameController, TextInputType.name),
                      buildTextField("Last Name", "Pénom", false,
                          _lastNameController, TextInputType.name),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Genre',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: _genderController,
                              hint: Text(
                                'Sélectionner votre genre',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _genderController = newValue!;
                                });
                              },
                              items: <String>['Masculin', 'Féminin', 'Autre']
                                  .map((String values) {
                                return new DropdownMenuItem<String>(
                                  value: values,
                                  child: new Text(values),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      buildTextField("Phone", "Téléphone", false,
                          _phoneController, TextInputType.phone),
                      buildTextField("Adresse", "Résidence", false,
                          _addresseController, TextInputType.name),
                      buildTextField("Mail", "example@gmail.com", false,
                          _mailController, TextInputType.emailAddress),
                      buildTextField("Birthday", "Naissance", false,
                          _birthdayController, TextInputType.datetime),
                      buildTextField("Citation", "...", false,
                          _citationController, TextInputType.text,
                          minLines: 7,
                          maxLines: 50,
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _addUser();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: 'Contacts')));
                    Fluttertoast.showToast(
                        msg: "Enrégistrement Réussi",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM);
                  },
                  child: Text("Enrégistrer",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 12),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, var controller, var keyboardType,
      {int minLines = 1, int maxLines = 1, var textAlign = TextAlign.start}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextFormField(
        keyboardType: keyboardType,
        autocorrect: true,
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        minLines: minLines,
        maxLines: maxLines,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ))
              : null,
          contentPadding: EdgeInsets.all(15),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        validator: (String? value) {
          return (value == null || value == "")
              ? "Ce champ est obligatoire"
              : null;
        },
      ),
    );
  }
}

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$         Detail          $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String photoPath = "assets/images/photosProfil/";
  bool isObscurePassword = true;
  var _firtNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  String _genderController = "Masculin";
  var _phoneController = TextEditingController();
  var _addresseController = TextEditingController();
  var _mailController = TextEditingController();
  var _birthdayController = TextEditingController();
  var _citationController = TextEditingController();

  User user = User();
  Map<String, dynamic> json = {};
  File? image;
  String path = "null";
  String profilText = "Modifier la photo de profil";

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this.image = imageTemporary;
      path = image.path;
      profilText = "Une image sélectionnée";
    });
  }

  // This function is used to fetch all data from the database
  void _refresh() async {
    user.setId(widget.id);
    user = await SQLHelper.getUser(user);

    setState(() {
      _firtNameController.text = user.getFirstName();
      _lastNameController.text = user.getLastName();
      _genderController = user.getGender();
      _phoneController.text = user.getPhone();
      _addresseController.text = user.getAdresse();
      _mailController.text = user.getMail();
      _birthdayController.text = user.getBirthday();
      _citationController.text = user.getCitation();
      path = user.getPhoto();
    });
  }

  void _updateUser() async {
    json = {
      'id': user.getId(),
      'firstName': _firtNameController.text,
      'lastName': _lastNameController.text,
      'gender': _genderController,
      'phone': _phoneController.text,
      'adresse': _addresseController.text,
      'mail': _mailController.text,
      'birthday': _birthdayController.text,
      'citation': _citationController.text,
      'photo': path,
    };
    user = await SQLHelper.updateUser(User.fromJson(json));
    _refresh();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(((_) => _refresh()));
  }

  _displayDialogProfil(BuildContext context) async {
    bool _isOK = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextButton(
              onPressed: (){
                Navigator.pop(context, "Cancel");
              },
              child: Icon(Icons.close,color: Colors.indigo,size: 30,),
            ),

            actions: [

              _isOK==true ?
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "Cancel");
                    setState(() {

                    });
                  },
                  child: const Text("OK")) : SizedBox(width: 0,),

              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  onPressed: () {

                    setState(() {
                      pickImage();
                      _isOK=true;
                    });
                    Future.delayed(const Duration(seconds: 5), () {
                      setState(() {

                      });
                    });
                    Navigator.pop(context, "Ok");
                  },

                  child: const Text("Modifier")),
            ],
            content: path == "null"
                ? Icon(
              Icons.person,
              size: 100,
              color: Colors.white,
            )
                : Image.file(
              File(path),
              fit: BoxFit.cover,
            ),

          );
        });
  }

  Widget build(BuildContext context) {
    // Delete an item
    void _deleteUser() async {
      await SQLHelper.deleteUser(user);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: 'Contacts')));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted a journal!'),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Contacts",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Contacts')));
            },
            icon: Icon(Icons.home),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  _displayDialogProfil(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1)),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: path == "null"
                              ? Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          )
                              : ClipOval(
                            child: Image.file(
                              File(path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: Colors.indigo,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text("Profil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
              SizedBox(
                height: 30,
              ),
              buildTextField("First Name", "Ecrivez votre nom ici ...", false,
                  _firtNameController),
              buildTextField("Last Name", "Ecrivez votre prénom ici ...", false,
                  _lastNameController),
              Padding(
                padding:
                EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Genre',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    DropdownButton<String>(
                      underline: widget,
                      isExpanded: true,
                      value: _genderController,
                      hint: Text(
                        'Sélectionner votre genre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _genderController = newValue!;
                        });
                      },
                      items: <String>['Masculin', 'Féminin', 'Autre']
                          .map((String values) {
                        return new DropdownMenuItem<String>(
                          value: values,
                          child: new Text(values),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildTextField("Phone", "Ecrivez votre contact ici ...", false,
                  _phoneController),
              buildTextField("Adress", "Ecrivez votre addresse ici ...", false,
                  _addresseController),
              buildTextField(
                  "Mail", "example@gmail.com", false, _mailController),
              buildTextField(
                  "Bithday",
                  "Ecrivez votre date de naissance ici ...",
                  false,
                  _birthdayController),
              buildTextField("Citation", "Les montagnes, la mer, ...", false,
                  _citationController,
                  minLines: 3, maxLines: 50, textAlign: TextAlign.justify),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _deleteUser();
                    },
                    child: Text(
                      "Supprimer",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateUser();
                      Fluttertoast.showToast(
                          msg: "Mosdifications enrégistrées",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM);
                    },
                    child: Text(
                      "Sauvegarder",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, var controller,
      {int minLines = 1, int maxLines = 1, var textAlign = TextAlign.start}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        minLines: minLines,
        maxLines: maxLines,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ))
              : null,
          contentPadding: EdgeInsets.all(15),
          disabledBorder: UnderlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}