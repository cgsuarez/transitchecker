import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './inputcard.dart';
import './outputcard.dart';
import '../providers/trafficheck_provider.dart';

class VerifyTrafficWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TrafficCheckProvider trafficCheckProvider = 
          Provider.of<TrafficCheckProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('Transit Checker'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _showURLDialog(context);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            InputCardWidget(),
            Expanded(
              child: TrafficCheckListWidget(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.restore_from_trash),
          onPressed: () {
              trafficCheckProvider.clearTrafficList();
          },
        ));
  }

  Future<void> _showURLDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('URL_TO_CONNECT') ?? 'http://10.0.2.2:8080';
    var urlController = TextEditingController();
    urlController.text = url;
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text('Actualizar la URL del Servicio'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(),
                    controller: urlController,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Actualizar'),
                  onPressed: () async {
                    if (urlController.text.isNotEmpty) {
                      await prefs.setString(
                          'URL_TO_CONNECT', urlController.text);
                    }

                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
