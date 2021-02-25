import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../constants/Theme.dart';
import '../widgets/navbar.dart';

class NewClient extends StatefulWidget {
  @override
  _NewClientState createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String number;

  void _onFormSaved() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await FirebaseFirestore.instance
          .collection('clients')
          .add({'name': name, 'number': number});

      await Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: ArgonColors.primary),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 24.0, right: 24.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  color: getThemeManager(context).isDarkMode
                                      ? Colors.grey[900]
                                      : Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: ArgonColors.muted))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("Register New Client",
                                        style: TextStyle(
                                            color: getThemeManager(context)
                                                    .isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 25.0)),
                                  )),
                                ],
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              color: getThemeManager(context).isDarkMode
                                  ? Colors.grey[900]
                                  : Colors.white12,
                              child: Form(
                                key: _formKey,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              hintText: 'Name',
                                              prefixIcon: Icon(Icons.person)),
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          onSaved: (value) => name = value,
                                          validator: (value) => value.isEmpty
                                              ? 'Name is required'
                                              : null,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: 'Phone Number',
                                                prefixIcon: Icon(Icons.phone)),
                                            onSaved: (value) => number = value,
                                            validator: (value) => value.isEmpty
                                                ? 'Phone number is required please'
                                                : null),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Center(
                                          child: FlatButton(
                                            textColor: ArgonColors.white,
                                            color: ArgonColors.primary,
                                            onPressed: _onFormSaved,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Text("Register",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.0))),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ]),
            )
          ],
        ));
  }
}
