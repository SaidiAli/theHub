import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/new_user.dart';
import '../my_cool_page_route.dart';

class ClientManagement extends StatefulWidget {
  @override
  _ClientManagementState createState() => _ClientManagementState();
}

class _ClientManagementState extends State<ClientManagement> {
  QuerySnapshot _snaps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Clients Management'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MyCoolPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return NewClient();
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('clients').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _snaps = snapshot.data;
              return Container(
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Total Number of clients:'),
                            Text(
                              _snaps.docs.length.toString(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        )),
                    Divider(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_snaps.docs[index].data()['name']),
                            trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('clients')
                                      .doc(_snaps.docs[index].id)
                                      .delete();
                                  setState(() {});
                                }),
                          );
                        },
                        itemCount: _snaps.docs.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
