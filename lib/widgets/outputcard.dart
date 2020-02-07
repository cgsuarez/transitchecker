import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../providers/trafficheck_provider.dart';
import '../models/traffic_check.dart';

class TrafficCheckListWidget extends StatefulWidget {
  @override
  _TrafficCheckListWidgetState createState() => _TrafficCheckListWidgetState();
}

class _TrafficCheckListWidgetState extends State<TrafficCheckListWidget> {
  @override
  Widget build(BuildContext context) {
    TrafficCheckProvider trafficCheckProvider =
        Provider.of<TrafficCheckProvider>(context);

    return ListView.builder(
      itemBuilder: (ctx, i) => Card(
        elevation: 8,
        child: ListTile(
          leading: Container(
              width: 100,
              height: 100,
              child: trafficCheckProvider.trafficList[i].allowed
                  ? FlareActor(
                      "assets/success.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      animation: "Run",
                    )
                  : FlareActor(
                      "assets/warning_icon.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      animation: "Play",
                    )),
          title: trafficCheckProvider.trafficList[i].allowed
              ? Text(
                  "PUEDE CIRCULAR",
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  "NO PUEDE CIRCULAR",
                  style: TextStyle(color: Colors.red),
                ),
          subtitle: Text(
              "${trafficCheckProvider.trafficList[i].vehicleId} - ${trafficCheckProvider.trafficList[i].date} - ${trafficCheckProvider.trafficList[i].time}"),
        ),
      ),
      itemCount: trafficCheckProvider.trafficList.length,
    );
  }
}
