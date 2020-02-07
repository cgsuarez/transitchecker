import 'dart:io';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/traffic_check.dart';

class TrafficCheckProvider with ChangeNotifier {
  List<TrafficCheck> _trafficsList;

  TrafficCheckProvider(this._trafficsList);

  List<TrafficCheck> get trafficList {
    return [..._trafficsList];
  }

  void clearTrafficList(){
    _trafficsList.clear();
    notifyListeners();
  }

  Future<void> verifyTrafficAllowed(
      String vehicleId, String date, String time) async {
    try {
      print('verifyTrafficAllowed $time, $date');

     SharedPreferences prefs = await SharedPreferences.getInstance();
     String baseurl = prefs.getString('URL_TO_CONNECT') ?? 'http://10.0.2.2:8080';    

      final url = baseurl + '/api/transitcheck/isAllowTransit';

      final response = await http.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode({
          'vehicleId': vehicleId,
          'date': date,
          'time': time,
        }),
      );

      if (response.statusCode != 200) {
        throw HttpException('Ocurrio un error en el envio del mensaje');
      }

      Map<String, Object> _responseData = json.decode(response.body);
      if (!_responseData.containsKey('header')) {
        throw HttpException('Respuesta Invalida, por favor intente nuevamente');
      }

      Map<String, Object> _headerData = _responseData['header'];
      int headerCode = _headerData['code'];
      print('headerCode: $headerCode');
      if (headerCode != 0) {
        throw HttpException(_headerData['message']);
      }

      _trafficsList.add(
        TrafficCheck(
          vehicleId: vehicleId,
          date: date,
          time: time,
          allowed: _responseData['allowToTransit'],
        ),
      );
    } catch (error) {
      //En caso de ocurrir un error grabo el mensaje de replica
      //en la base de datos para posterior envio

      throw error;
    } finally {
      notifyListeners();
    }
  }
}
