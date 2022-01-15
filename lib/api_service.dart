import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:layout/secrets.dart';

import 'package:logger/logger.dart';


class ApiService {

  var log = Logger();
  var secrets = Secrets();


  Future getWeatherByCity(String city) async {
    final weatherUrl = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${secrets.weatherKey}&units=imperial');
    final response = await http.get(weatherUrl);
    log.i(response.statusCode);
    log.i(response.body);
    return json.decode(response.body);
  }

  Future getCityImage(String city) async {
    final weatherUrl = Uri.parse('https://pixabay.com/api/?key=${secrets.imageKey}&q=$city&image_type=preview');
    final response = await http.get(weatherUrl);
    log.i(response.statusCode);
    log.i(response.body);
    return json.decode(response.body)['hits'];
  }
}