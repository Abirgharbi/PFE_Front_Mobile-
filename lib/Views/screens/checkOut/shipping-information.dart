import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Model/service/network_handler.dart';
import 'package:arkea/utils/shared_preferences.dart';

class ShippingInfo extends StatelessWidget {
  const ShippingInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 15,
    );
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          FutureBuilder<String>(
            future: sharedPrefs.getPref('customerName'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    child: Column(children: <Widget>[
                      ShippingInfoItem(
                        iconData: Icons.person_outline,
                        text: '${snapshot.data}',
                      ),
                    ]),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[Text('${snapshot.error}')];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  children: children,
                ),
              );
            },
          ),
          FutureBuilder<String>(
            future: sharedPrefs.getPref('address'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 15),
                    child: ShippingInfoItem(
                      iconData: Icons.location_on_outlined,
                      text: '${snapshot.data}',
                    ),
                  ),
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[Text('${snapshot.error}')];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  children: children,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShippingInfoItem extends StatelessWidget {
  final TextStyle textStyle = TextStyle(fontSize: 15);
  final String text;
  final IconData? iconData;
  ShippingInfoItem({Key? key, this.text = '', this.iconData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            iconData,
            size: 28,
            color: Color(0XFF200E32),
          ),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
