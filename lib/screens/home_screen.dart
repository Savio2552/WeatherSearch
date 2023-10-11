import 'dart:convert';

import 'package:clima/models/weather_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class DateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}/${now.month}/${now.year}";

    return Text(
      '$formattedDate',
      style: TextStyle(
          fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  //Variveis
  String cityName = "";
  Future<Weather> fetchWeather(String city) async {
    const apikey = "20b394807e3fed9e69c2decdc1a4f53d";

    final resp = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apikey&lang=pt_br'));
    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);
      print(resp.statusCode);
      return Weather.fromJson(json);
    } else {
      print(resp.statusCode);
      throw Exception('deu errado a chamada');
    }
  }

  void searchCity() async {
    if (cityName.isNotEmpty) {
      try {
        final weather = await fetchWeather(cityName);
        setState(() {
          myWeather = Future.value(weather);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  late Future<Weather> myWeather;
  @override
  void initState() {
    super.initState();
    myWeather = fetchWeather('Capanema');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF676BD0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
            child: Stack(children: [
              SafeArea(
                top: true,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/icon-person.png'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<Weather>(
                      future: myWeather,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                snapshot.data!.weather[0]['main'].toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DateDisplay(),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 250,
                                width: 250,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                  'assets/nuvem-sol.png',
                                ))),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Temp',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${((snapshot.data!.main['temp']).toStringAsFixed(2))}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Speed',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${snapshot.data!.wind['speed']} km/h',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'humidity',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${snapshot.data!.main['humidity']}%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        cityName = value;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Cidade',
                                          filled: true,
                                          fillColor: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      onPressed: searchCity,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error');
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
