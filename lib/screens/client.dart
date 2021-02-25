import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../constants/Theme.dart';

class Client extends StatefulWidget {
  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot _doc;
  String _id;
  String _movieTitle = '';
  int _numberOfSeasons = 0;
  int _currentSeason = 0;
  bool _paid = true;

  Future<DocumentSnapshot> getClient() {
    Map<String, String> routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return FirebaseFirestore.instance
        .collection('clients')
        .doc(routeArgs['id'])
        .get();
  }

  void _addMovie(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setModalState) =>
                SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Movie Title', prefixIcon: Icon(Icons.movie)),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => _movieTitle = value,
                    validator: (value) =>
                        value.isEmpty ? 'Name is required' : null,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    trailing: CupertinoSwitch(
                        value: _paid,
                        onChanged: (val) {
                          setModalState(() => _paid = val);
                        }),
                    title: Text('Paid'),
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    textColor: Colors.white,
                    onPressed: () => _save(true),
                    child: Text('Add'),
                    color: ArgonColors.primary,
                  )
                ]),
              ),
            ),
          );
        });
  }

  void _addSeries(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setModalState) =>
                SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Movie Title', prefixIcon: Icon(Icons.movie)),
                    keyboardType: TextInputType.text,
                    onChanged: (value) => _movieTitle = value,
                    validator: (value) =>
                        value.isEmpty ? 'Name is required' : null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Total number of Seasons'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _numberOfSeasons = int.parse(value),
                    validator: (value) =>
                        value.isEmpty ? 'Field is required' : null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'What season is the client taking?'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _currentSeason = int.parse(value),
                    validator: (value) =>
                        value.isEmpty ? 'Field is required' : null,
                  ),
                  ListTile(
                    trailing: CupertinoSwitch(
                        value: _paid,
                        onChanged: (val) {
                          setModalState(() => _paid = val);
                        }),
                    title: Text('Paid'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    onPressed: () => _save(false),
                    child: Text('Add'),
                    color: ArgonColors.primary,
                  )
                ]),
              ),
            ),
          );
        });
  }

  void _save(bool isMovie) async {
    await FirebaseFirestore.instance
        .collection('clients')
        .doc(_id)
        .collection('movies')
        .add({
      'isMovie': isMovie,
      'isPaid': _paid,
      'title': _movieTitle,
      'numberOfSeasons': _numberOfSeasons,
      'currentSeason': _currentSeason
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          switch (await showDialog<Selection>(
              context: context,
              builder: (_) {
                return SimpleDialog(
                  title: Center(child: Text('Add new')),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, Selection.movie);
                      },
                      child: const Text('Movie'),
                    ),
                    Divider(),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, Selection.series);
                      },
                      child: const Text('Series'),
                    ),
                  ],
                );
              })) {
            case Selection.movie:
              _addMovie(context);
              break;
            case Selection.series:
              _addSeries(context);
              break;
            default:
          }
          ;
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder(
        future: getClient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _doc = snapshot.data;
            _id = _doc.id;
            return Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Text(
                          _doc.data()['name'],
                          style: TextStyle(
                              fontSize: 30,
                              color: !getThemeManager(context).isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Contact: ${_doc.data()['number']}',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('clients')
                              .doc(_id)
                              .collection('movies')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return _buildPanel(snapshot.data.docs, _id);
                            }
                          }))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPanel(List<QueryDocumentSnapshot> data, String id) {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: data.map<ExpansionPanelRadio>((doc) {
        return ExpansionPanelRadio(
            value: doc.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      doc.data()['title'],
                    ),
                    doc.data()['isPaid']
                    ? Chip(
                        label: Text('Paid', style: TextStyle(color: Colors.white),),
                        backgroundColor: ArgonColors.success,
                      )
                    : Chip(
                        label: Text('Not Paid', style: TextStyle(color: Colors.white),),
                        backgroundColor: ArgonColors.error,
                      )
                  ],
                ),
              );
            },
            body: !doc.data()['isMovie']
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Number of Seasons taken so far:',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${doc.data()['currentSeason']}/${doc.data()['numberOfSeasons']}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    if (doc.data()['currentSeason'] ==
                                        doc.data()['numberOfSeasons']) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                            'The client has exhausted all seasons'),
                                      ));
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('clients')
                                          .doc(id)
                                          .collection('movies')
                                          .doc(doc.id)
                                          .update({
                                        'currentSeason':
                                            doc.data()['currentSeason'] + 1
                                      });
                                    }
                                  },
                                  child: Text('Add'),
                                  color: ArgonColors.success,
                                  textColor: Colors.white,
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    if (doc.data()['currentSeason'] == 0) {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                            'The client has exhausted all seasons'),
                                      ));
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('clients')
                                          .doc(id)
                                          .collection('movies')
                                          .doc(doc.id)
                                          .update({
                                        'currentSeason':
                                            doc.data()['currentSeason'] - 1
                                      });
                                    }
                                  },
                                  child: Text('Remove'),
                                  color: ArgonColors.error,
                                  textColor: Colors.white,
                                )
                              ]),
                        )
                      ],
                    ),
                  )
                : Container());
      }).toList(),
    );
  }
}

enum Selection { movie, series }
