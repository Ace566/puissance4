import 'dart:math';

import '../game/game_board.dart';
import '../game/game_page.dart';

abstract class Phone {
  final Color color;
  final Random _random = Random(DateTime.now().millisecond);
   Phone(this.color);

  Color get otherPlayer => color == Color.RED ? Color.YELLOW : Color.RED;

  Future<int> chooseCol(GameBoard board);
}

class PlayerPhone extends Phone {
  PlayerPhone(Color player) : super(player);

  Color get otherPlayer => color == Color.RED ? Color.YELLOW : Color.RED;

  @override
  Future<int> chooseCol(GameBoard board) async {

    await Future.delayed(Duration(seconds: 2 + _random.nextInt(2)));
    int col = _random.nextInt(7);

    return col;
  }

}
