import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:theHub/constants/Theme.dart';
import 'package:theHub/screens/new_user.dart';
import 'package:theHub/widgets/card-horizontal.dart';
import './widgets/drawer.dart';
import './widgets/navbar.dart';
import './screens/new_user.dart';
import './screens/client.dart';
import './my_cool_page_route.dart';
import 'package:flutter/services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import './screens/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  await ThemeManager.initialise();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      lightTheme: ThemeData.light(),
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
          title: 'theHub',
          theme: regularTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: MyHomePage(),
          routes: <String, WidgetBuilder>{
            "/home": (BuildContext context) => MyHomePage(),
            "/client": (BuildContext context) => Client(),
            "/new-client": (BuildContext context) => NewClient(),
            '/settings': (BuildContext context) => SettingsScreen(),
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
          title: "Home",
          searchBar: false,
          rightOptions: false,
          bgColor: getThemeManager(context).isDarkMode
              ? Colors.grey[800]
              : Colors.white),
      drawer: ArgonDrawer(currentPage: "Home"),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('clients').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                QuerySnapshot data = snapshot.data;
                return Container(
                  child: ListView.builder(
                    itemBuilder: (context, index) => CardHorizontal(
                      title: data.docs[index].data()['name'],
                      titleTextStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      cta: data.docs[index].data()['number'],
                      ctaTestStyle: TextStyle(fontSize: 15),
                      tap: () => Navigator.of(context).pushNamed('/client',
                          arguments: <String, String>{
                            'id': data.docs[index].id
                          }),
                    ),
                    itemCount: data.docs.length,
                  ),
                );
              }
            }),
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
    );
  }
}
