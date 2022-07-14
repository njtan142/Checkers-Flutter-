import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Checkers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.width * 0.90,
              child: CheckerBoard(),
            )
          ],
        ),
      ),
    );
  }
}

// two dimensional aray with 8 rows and 8 columns
var cell = [
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
];

// a enum whether it is player 1 or player 2
enum Player { player1, player2, empty }

enum Turn { player1, player2 }

late Turn turn;

void putPiece(int row, int col, Player player) {
  if (player == Player.player1) {
    cell[row][col] = 1;
  } else {
    cell[row][col] = 2;
  }
}

void initializeGame() {
  // put pieces on the board, row 1 to 3 are player 1, row 6 to 8 are player 2
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 8; j++) {
      putPiece(i, j, Player.player1);
    }
  }
  for (int i = 5; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      putPiece(i, j, Player.player2);
    }
  }
}

//make a gameboard with 8 rows and 8 columns and alternative colors

class CheckerPiece extends StatelessWidget {
  CheckerPiece(
      {Key? key,
      required this.hue,
      required this.row,
      required this.column,
      required this.player})
      : super(key: key);

  final Color hue;

  final row;
  final column;

  Player player;

  var size;

  Text _checkplayer() {
    if (player == Player.player1 && hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.red, fontSize: size * 0.0625));
    } else if (player == Player.player2 && hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.blue, fontSize: size * 0.0625));
    } else {
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width;
    return Container(
      color: hue,
      child: Center(
        child: _checkplayer(),
      ),
    );
  }
}

// a widget array with 8 rows and 8 columns
class CheckerBoard extends StatelessWidget {
  const CheckerBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 8,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        for (int i = 0; i < 8; i++)
          for (int j = 0; j < 8; j++)
            // row 1 to 3 are player 1, row 6 to 8 are player 2, the rest are empty
            if (i < 3)
              CheckerPiece(
                hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
                row: i,
                column: j,
                player: Player.player1,
              )
            else if (i > 4)
              CheckerPiece(
                hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
                row: i,
                column: j,
                player: Player.player2,
              )
            else
              CheckerPiece(
                hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
                row: i,
                column: j,
                player: Player.empty,
              )
      ],
    );
  }
}
