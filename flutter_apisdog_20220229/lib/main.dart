import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_apisDog_20220229',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Characteristics',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> _futureCharacter;

  @override
  void initState() {
    super.initState();
    _futureCharacter = _fetchCharacter();
  }

  Future<Map<String, dynamic>> _fetchCharacter() async {
    final response = await http.get(
      Uri.parse('https://api.thedogapi.com/v1/breeds/12'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                      'https://fwkc-cloudinary.corebine.com/fwkc-production/image/upload/v1/fwkc-prod/EskimoDog'),
                  Text('Name: ${snapshot.data!['name']}'),
                  Text('Height: ${snapshot.data!['height']['imperial']}'),
                  Text('Mass: ${snapshot.data!['weight']['imperial']}'),
                  Text('Temperament: ${snapshot.data!['temperament']}'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}