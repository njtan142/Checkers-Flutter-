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
              width: MediaQuery.of(context).size.height * 0.70,
              height: MediaQuery.of(context).size.height * 0.70,
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
enum Player { player1, player2, empty, outOfBounds }

enum Turn { player1, player2 }

enum GameState {
  currentTurn,
  nextTurn,
}

Turn turn = Turn.player1;

GameState gameState = GameState.nextTurn;

void putPiece(int row, int col, Player player) {
  if (player == Player.player1) {
    cell[row][col] = 1;
  } else {
    cell[row][col] = 2;
  }
  print(cell);
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
var pieces = <CheckerPiece>[];

// a widget array with 8 rows and 8 columns
class CheckerBoard extends StatelessWidget {
  CheckerBoard({Key? key}) : super(key: key);

  void putPieces() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (i < 3) {
          pieces.add(CheckerPiece(
            hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
            row: i,
            column: j,
            player: (i + j) % 2 == 1 ? Player.player1 : Player.outOfBounds,
          ));
        } else if (i > 4) {
          pieces.add(CheckerPiece(
            hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
            row: i,
            column: j,
            player: (i + j) % 2 == 1 ? Player.player2 : Player.outOfBounds,
          ));
        } else {
          pieces.add(CheckerPiece(
            hue: (i + j) % 2 == 1 ? Colors.black : Colors.white,
            row: i,
            column: j,
            player: (i + j) % 2 == 1 ? Player.empty : Player.outOfBounds,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    putPieces();
    return GridView.count(
      crossAxisCount: 8,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: pieces,
    );
  }
}

class CheckerPiece extends StatefulWidget {
  Color hue;

  final int row;
  final int column;

  Player player;

  CheckerPiece(
      {Key? key,
      required this.hue,
      required this.row,
      required this.column,
      required this.player})
      : super(key: key);

  @override
  State<CheckerPiece> createState() => _CheckerpieceState();
  void setPiece() {
    _CheckerpieceState()._setPiece();
  }
}

class _CheckerpieceState extends State<CheckerPiece> {
  var size;

  Text _checkplayer() {
    if (widget.player == Player.player1 && widget.hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.red, fontSize: size * 0.0625));
    } else if (widget.player == Player.player2 && widget.hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.blue, fontSize: size * 0.0625));
    } else {
      return Text("");
    }
  }

  Text piece = Text("");

  void _setPiece() {
    setState(() {
      piece = _checkplayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      size = MediaQuery.of(context).size.width;
    } else {
      size = MediaQuery.of(context).size.height;
    }
    _setPiece();
    return GestureDetector(
      onTap: () {
        print(widget.player);
        if (turn == Turn.player1) {
          if (widget.player == Player.player1) {
            putPiece(widget.row, widget.column, Player.player1);
            if (gameState == GameState.nextTurn) {
              gameState = GameState.currentTurn;
              widget.player = Player.empty;
              _setPiece();
            }
          } else {
            print(gameState);
            if (gameState == GameState.currentTurn) {
              gameState = GameState.nextTurn;
              widget.player = Player.player1;
              _setPiece();
              turn = Turn.player2;
            }
          }
        } else {
          if (widget.player == Player.player2) {
            putPiece(widget.row, widget.column, Player.player2);
            if (gameState == GameState.nextTurn) {
              gameState = GameState.currentTurn;
              widget.player = Player.empty;
              _setPiece();
            }
          } else {
            print(gameState);
            if (gameState == GameState.currentTurn) {
              gameState = GameState.nextTurn;
              widget.player = Player.player2;
              _setPiece();
              turn = Turn.player1;
            }
          }
        }
      },
      child: Container(
        color: widget.hue,
        child: Center(
          child: piece,
        ),
      ),
    );
  }
}
