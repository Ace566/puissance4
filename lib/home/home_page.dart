import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puissance_quatre/ia/phone.dart';

import '../game/game_page.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 100,
              width: 150,
              child: FlatButton(
                color: Colors.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(180.0)),
                child: Text(
                  'Contre Joueur',
                  style:TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/game',
                    arguments: {
                      'mode': Mode.PVPLocal,
                    },
                  );
                },
              ),
            ),
            Container(
              height: 100,
              width: 150,
              child: FlatButton(
                color: Colors.orangeAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(180.0)),
                child: Text(
                  'Contre IA',
                  style:TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/game',
                    arguments: {
                      'mode': Mode.PVE,
                      'phone': PlayerPhone(
                          Random().nextBool() ? Color.RED : Color.YELLOW),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}