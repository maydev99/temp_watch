import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/api_service.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var log = Logger();
  var apiService = ApiService();
  final _cityTextController = TextEditingController();
  var myCity = 'City';
  double temp = 0.0;
  dynamic low = 0;
  dynamic high = 0;
  String description = '';
  String windDir = '';
  String windSpeed = '';
  String cityImageLink =
      'https://s27107.pcdn.co/wp-content/uploads/2018/05/4-768x432.jpg';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
  }

  Future getWxData(String city) async {
    var jsonData = await apiService.getWeatherByCity(city);
    var mainData = jsonData['main'];
    var weatherData = jsonData['weather'][0];
    var windData = jsonData['wind'];

    setState(() {
      myCity = jsonData['name']; //From Root Json
      temp = mainData['temp']; //Direct from Main node
      description = weatherData[
          'description']; //The weather node is an array index zero above
      low = mainData['temp_min'];
      high = mainData['temp_max'];
      windDir = windData['deg'].toString();
      windSpeed = windData['speed'].toString();
    });

    getCityImage(city);
  }

  Future getCityImage(String city) async {
    var imageJsonData = await apiService.getCityImage(city);
    var firstImage = imageJsonData[0];
    setState(() {
      cityImageLink = firstImage['webformatURL'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 58.0, bottom: 8, right: 8, left: 8),
              child: TextFormField(
                controller: _cityTextController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: 'City',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      getWxData(_cityTextController.text);
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      _cityTextController.text = '';
                    },
                      child: const Icon(Icons.search))
                ),

              ),
            ),
            CachedNetworkImage(
              imageUrl: cityImageLink,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 400,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                myCity,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${temp.toStringAsFixed(0)}°',
                style:
                    const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'High: ${high.toStringAsFixed(0)} | Low: ${low.toStringAsFixed(0)}')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(description),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Wind from $windDir at $windSpeed mph'),
            ),

          ],
        ));
  }
}
