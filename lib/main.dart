import 'package:flutter/material.dart';

import 'game/game_page.dart';
import 'home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Puissance 4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        if (settings.name == '/game') {
          return MaterialPageRoute(
            builder: (context) => GamePage(
              mode: args['mode'],
              phone: args['phone'],
            ),
          );
        }
        return null;
      },
    );
  }
}
