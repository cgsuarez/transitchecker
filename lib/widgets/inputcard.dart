import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../providers/trafficheck_provider.dart';

class InputCardWidget extends StatefulWidget {
  @override
  _InputCardWidgetState createState() {
    return _InputCardWidgetState(
      
    );
  }
}

class _InputCardWidgetState extends State<InputCardWidget> {
  final vehicleIdController = TextEditingController();
  String dateToSend;
  String timeToSend;



  Future<void> sendTrafficCheckerRequest(
      TrafficCheckProvider trafficCheckProvider) async {
    if (vehicleIdController.text.isNotEmpty &&
        vehicleIdController.text.length != 6 &&
        isNumeric(vehicleIdController.text
            .substring(vehicleIdController.text.length - 1))) {
      await trafficCheckProvider.verifyTrafficAllowed(
          vehicleIdController.text, dateToSend, timeToSend);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Error"),
              content: new Text("Ingrese una placa valida"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cerrar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    TrafficCheckProvider trafficCheckProvider =
        Provider.of<TrafficCheckProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Ingrese la Placa'),
                controller: vehicleIdController,
              ),
              FlatButton(
                child: Text(
                  dateToSend == null
                      ? 'Pulse para seleccionar fecha y hora'
                      : "$dateToSend $timeToSend",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2020, 1, 1),
                      maxTime: DateTime(2023, 12, 31), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    print('confirm $date');
                    setState(() {
                      dateToSend = "${date.day}/${date.month}/${date.year}";
                      timeToSend = "${date.hour}:${date.minute}";  
                    });
                    
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
              ),
              RaisedButton(
                child: Text('Verificar Pico y Placa'),
                onPressed: () {
                  sendTrafficCheckerRequest(trafficCheckProvider);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
