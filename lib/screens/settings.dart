import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:theHub/constants/Theme.dart';
import 'package:theHub/my_cool_page_route.dart';
import '../widgets/drawer.dart';
import './client_management.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _showThemeSelectDialog(BuildContext ctx) async {
    switch (await showDialog<Select>(
        context: ctx,
        builder: (_) {
          return SimpleDialog(
            title: const Text('Choose App Theme'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(ctx, Select.light);
                },
                child: const Text('Light'),
              ),
              Divider(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(ctx, Select.dark);
                },
                child: const Text('Dark'),
              ),
            ],
          );
        })) {
      case Select.light:
        getThemeManager(ctx).setThemeMode(ThemeMode.light);
        break;
      case Select.dark:
        getThemeManager(ctx).setThemeMode(ThemeMode.dark);
        break;
      default:
        return;
    }
  }

  void _openDataManagementScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DataManagement()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: getThemeManager(context).isDarkMode
              ? Colors.grey[900]
              : ArgonColors.primary,
        ),
        drawer: ArgonDrawer(currentPage: "settings"),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                ListItem(
                  title: 'Theme',
                  icon: Icon(Icons.brightness_medium),
                  onSelected: _showThemeSelectDialog,
                  subtitle: 'Set them to light or dark',
                ),
                ListItem(
                  title: 'Data',
                  icon: Icon(Icons.data_usage),
                  onSelected: _openDataManagementScreen,
                  subtitle: 'Manage app data',
                ),
              ],
            )));
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final String subtitle;
  final Function onSelected;

  const ListItem({this.icon, this.onSelected, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(context),
      child: ListTile(
        title: Text(title),
        leading: icon,
        subtitle: Text(subtitle),
      ),
    );
  }
}

class DataManagement extends StatefulWidget {
  @override
  _DataManagementState createState() => _DataManagementState();
}

class _DataManagementState extends State<DataManagement> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  QuerySnapshot _snaps;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      _snaps = await FirebaseFirestore.instance.collection('clients').get();
    });
  }

  void _clearEverything(BuildContext context) async {
    switch (await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure, this action is irreversible?'),
          actions: <Widget>[
            TextButton(
              child: Text('yes'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('no'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    )) {
      case true:
        WriteBatch batch = FirebaseFirestore.instance.batch();
        _snaps.docs.forEach((element) {
          batch.delete(element.reference);
        });
        await batch.commit();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('All data is cleared'),
          duration: Duration(seconds: 2),
        ));
        break;
      case false:
        return;
      default:
    }
  }

  void _openClientManagementScreen(BuildContext context) {
    Navigator.push(
      context,
      MyCoolPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return ClientManagement();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Data Management'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            ListItem(
              title: 'Manage Clients',
              icon: Icon(Icons.data_usage),
              onSelected: _openClientManagementScreen,
              subtitle: 'Delete unwanted clients',
            ),
            SizedBox(height: 40),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              color: Theme.of(context).errorColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      width: 3, color: Theme.of(context).errorColor)),
              onPressed: () => _clearEverything(context),
              child: Text(
                "clear all data".toUpperCase(),
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Select { dark, light }
