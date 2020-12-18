import 'dart:math';

import 'package:flutter/material.dart';

import 'coordinate.dart';
import 'game_board.dart';
import '../ia/phone.dart';
import 'game_piece.dart';
import 'hole_color.dart';

enum Color {
  YELLOW,
  RED,
}

enum Mode {
  PVPLocal,
  PVE,
}

class GamePage extends StatefulWidget {
  final Mode mode;
  final Phone phone;

  const GamePage({
    Key key,
    this.mode,
    this.phone,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final board = GameBoard();
  Color turn;
  Color winner;
  int scoreRed;
  int scoreYellow;

  List<List<double>> translations = List.generate(7, (i) => List.generate(7, (i) => null,),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.cyan[800],
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew_rounded),
            color: Colors.white,
            onPressed: (){
              resetBoard();
            },
          ),
        ],
      ),
      backgroundColor: Colors.cyan[800],
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 570,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Affichge du score
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Score Rouge
                    Text(
                      "$scoreRed",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 40
                      ),
                    ),
                    Text(
                      " - ",
                      style: TextStyle(
                          fontSize: 40
                      ),
                    ),
                    //Score Jaune
                    Text(
                      "$scoreYellow",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 40
                      ),
                    ),
                  ],
                ),
                //Table de jeu
                Flexible(
                  flex: 2,
                  child: Container(
                    constraints: BoxConstraints.loose(
                      Size(
                        500,
                        532,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(
                        overflow: Overflow.clip,
                        fit: StackFit.loose,
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                          buildGamePiece(),
                          buildBoardGame(),
                        ],
                      ),
                    ),
                  ),
                ),
                //Affichage du text pour dire à qui de jouer
                //OU quand il y a un gagnant, cela affiche qui a gagné
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: winner != null
                        ? Text(
                      '${winner == Color.RED ? 'Rouge' : 'Jaune'} Gagnant',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(color: winner == Color.RED ? Colors.red : Colors.yellow),
                    )
                        : Column(
                      children: <Widget>[
                        Text(
                          'Jeton ${turn == Color.RED ? 'Rouge' : 'Jaune'}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GamePiece(color: turn),
                        ),
                        _buildPlayerName(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildPlayerName(BuildContext context) {
    String name;

    if (widget.mode == Mode.PVE) {
      if (turn == widget.phone.color) {
        name = 'Joueur IA';
      } else {
        name = 'Moi';
      }
    } else if (widget.mode == Mode.PVPLocal) {
      if (turn == Color.RED) {
        name = 'Joueur 1';
      } else {
        name = 'Joueur 2';
      }
    }
    return Text(
      name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
    );
  }

  @override
  void initState() {
    super.initState();
    scoreRed = 0;
    scoreYellow = 0;
    turn = widget.phone?.otherPlayer ??
        (Random().nextBool() ? Color.RED : Color.YELLOW);
    if (widget.mode == Mode.PVE && turn == widget.phone.color) {
      phoneMove(widget.phone);
    }
  }

  GridView buildGamePiece() {
    return GridView.custom(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      childrenDelegate: SliverChildBuilderDelegate(
            (context, i) {
          final col = i % 7;
          final row = i ~/ 7;

          if (board.getBox(Coordinate(col, row)) == null) {
            return SizedBox();
          }

          return GamePiece(
            color: board.getBox(Coordinate(col, row)),
          );

        },
        childCount: 42,
      ),
    );
  }

  GridView buildBoardGame() {
    return GridView.custom(
      padding: const EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      shrinkWrap: true,
      childrenDelegate: SliverChildBuilderDelegate(
            (context, i) {
          final col = i % 7;

          return GestureDetector(
            onTap: () {
              if (winner == null) {
                playerMove(col);
              }
            },
            child: CustomPaint(
              size: Size(50, 50),
              willChange: false,
              painter: HoleColor(),
            ),
          );
        },
        childCount: 42,
      ),
    );
  }

  void playerMove(int col) {
    putPiece(col);
    if (winner == null && widget.mode == Mode.PVE) {
      phoneMove(widget.phone);
    }
  }

  void phoneMove(Phone phone) async {
    int col = await phone.chooseCol(board);
    putPiece(col);
  }

  void putPiece(int col) {
    final target = board.getColumnTarget(col);
    final player = turn;

    if (target == -1) {
      return;
    }

    if (mounted) {
      setState(() {
        board.setBox(Coordinate(col, target), turn);
        turn = turn == Color.RED ? Color.YELLOW : Color.RED;
      });
    }

    if (board.checkWinner(Coordinate(col, target), player)) {
      showWinnerDialog(context, player);
    }
  }

  void showWinnerDialog(BuildContext context, Color player) {
    setState(() {
      winner = player;
      if(winner == Color.RED){
        scoreRed = scoreRed + 1;
      }else{
        scoreYellow = scoreYellow + 1;
      }
    });
  }

  void resetBoard() {
    setState(() {
      winner = null;
      board.reset();
      turn = widget.phone?.otherPlayer ??
          (Random().nextBool() ? Color.RED : Color.YELLOW);
      if (widget.mode == Mode.PVE && turn == widget.phone.color) {
        phoneMove(widget.phone);
      }
    });
  }
}