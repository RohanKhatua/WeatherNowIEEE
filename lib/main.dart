import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'weather_detail_card.dart';
// import 'package:weather_icons/weather_icons.dart';

WeatherFactory wf = WeatherFactory("5ec44bf05545563287c04b754ddd53f0");
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherNow',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        // fontFamily: 'Roboto Mono',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentAddress = "";
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  String description = "";
  double temp_celsius = 0.0;
  String tempString = "";
  String iconString = "";
  double humidity = 0.0;
  double cloudCover = 0.0;
  int weatherCode = 0;
  String areaName = "";
  String country = "";
  double windSpeed = 0;
  double feelTempCelsius = 0;
  String feelTempCelsiusString = "";
  String maxTemp = "";
  String minTemp = "";
  DateTime sunrise = DateTime.now();
  DateTime sunset = DateTime.now();

  // @override
  // void initState() {
  //   currentAddress = "";
  //   currentLatitude = 0.0;
  //   currentLongitude = 0.0;

  //   description = "";
  //   temp_celsius = 0.0;
  //   tempString = "";
  //   iconString = "";
  //   humidity = 0.0;
  //   cloudCover = 0.0;
  //   weatherCode = 0;
  //   areaName = "";
  //   country = "";
  //   windSpeed = 0;
  //   feelTempCelsius = 0;
  //   feelTempCelsiusString = "";
  //   maxTemp = "";
  //   minTemp = "";
  //   _determinePosition();
  //   _getWeather(longitude: currentLongitude, latitude: currentLatitude);
  //   super.initState();
  // }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please turn on location");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permission denied forever");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });

    // return await Geolocator.getCurrentPosition();
  }

  void _getWeather(
      {String location = "", double latitude = 0, double longitude = 0}) async {
    Weather weatherAtLocation;
    if (location == "") {
      weatherAtLocation =
          await wf.currentWeatherByLocation(latitude, longitude);
    } else {
      weatherAtLocation = await wf.currentWeatherByCityName(location);
    }

    Temperature temperature = weatherAtLocation.temperature!;

    setState(() {
      description = weatherAtLocation.weatherDescription!;
      temp_celsius = temperature.celsius!;
      tempString = temp_celsius.toStringAsFixed(1);
      iconString = weatherAtLocation.weatherIcon!;
      weatherCode = weatherAtLocation.weatherConditionCode!;
      humidity = weatherAtLocation.humidity!;
      cloudCover = weatherAtLocation.cloudiness!;
      areaName = weatherAtLocation.areaName!;
      country = weatherAtLocation.country!;
      currentAddress = areaName + ", " + country;
      windSpeed = weatherAtLocation.windSpeed!;
      feelTempCelsius = weatherAtLocation.tempFeelsLike!.celsius!;
      feelTempCelsiusString = feelTempCelsius.toStringAsFixed(1);
      maxTemp = weatherAtLocation.tempMax!.celsius!.toStringAsFixed(1);
      minTemp = weatherAtLocation.tempMin!.celsius!.toStringAsFixed(1);
      sunrise = weatherAtLocation.sunrise!.toUtc();
      sunset = weatherAtLocation.sunset!.toUtc();
    });

    // print(temp_celsius);
  }

  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Weather Now"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Form(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: _searchController,
              key: _formKey,
              decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Enter City Name",
                  contentPadding: EdgeInsets.only(left: 8)),
              onFieldSubmitted: (data) {
                _getWeather(location: data);
              },
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          Text(
            currentAddress,
            style: const TextStyle(
              fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "$tempString °C",
                      style: const TextStyle(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Feels like $feelTempCelsiusString °C",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.arrow_upward_rounded),
                        Text("$maxTemp °C"),
                        const Icon(Icons.arrow_downward_rounded),
                        Text("$minTemp °C"),
                      ],
                    ),
                    // Row(children: [
                    //   const Icon(WeatherIcons.sunrise),
                    //   const SizedBox(width: 10),
                    //   Text(
                    //       "${sunrise.hour}:${sunrise.minute.toStringAsPrecision(2)}"),
                    //   const SizedBox(width: 10),
                    //   const Icon(WeatherIcons.sunset),
                    //   const SizedBox(width: 10),
                    //   Text(
                    //       "${sunset.hour}:${sunset.minute.toStringAsPrecision(2)}"),
                    // ]),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                  ],
                ),
                // const SizedBox(
                //   width: 200,
                // ),
                if (iconString != "")
                  Image.network(
                      "http://openweathermap.org/img/wn/$iconString@2x.png")
                else
                  Container()
              ],
            ),
          ),
          weatherDetailCard(
              "Humidity", humidity.toString() + "%", const Icon(Icons.water)),
          weatherDetailCard("Wind Speed", windSpeed.toString() + " m/s",
              const Icon(Icons.air)),
          weatherDetailCard(
              "Cloud Cover", cloudCover.toString(), const Icon(Icons.cloud)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _determinePosition();
                _getWeather(
                  longitude: currentLongitude,
                  latitude: currentLatitude,
                );
              });
            },
            child: const Text(
              "Locate Me",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
