class Weather {
  final name;
  var main;
  var wind;
  var weather;

  Weather({this.main, required this.name, this.weather, this.wind});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        main: json['main'],
        name: json['name'],
        weather: json['weather'],
        wind: json['wind']);
  }
}
