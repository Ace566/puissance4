import 'package:flutter/material.dart';

import 'game_page.dart';

class GamePiece extends StatelessWidget {
  const GamePiece({
    Key key,
    this.translation,
    @required this.color,
  }) : super(key: key);

  final Animation<double> translation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: Material(
          shape: CircleBorder(),
          color: color == Color.RED ? Colors.red : color == Color.YELLOW ? Colors.yellow : Colors.white,
        ),
      ),
    );
  }
}
