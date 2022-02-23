import 'package:flutter/material.dart';

class weatherDetailCard extends StatelessWidget {
  // const weatherDetailCard({Key? key}) : super(key: key);

  String name;
  var value;
  Icon weather_icon;

  weatherDetailCard(this.name, this.value, this.weather_icon, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 25,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: weather_icon,
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            value,
            style: const TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
