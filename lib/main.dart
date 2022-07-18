import 'package:flutter/material.dart';

//global variables
// two dimensional aray with 8 rows and 8 columns

// enums to represent states of the board
enum Player { player1, player2, empty, outOfBounds }

enum Turn { player1, player2 }

enum GameState {
  currentTurn,
  nextTurn,
}

Turn turn = Turn.player1;

GameState gameState = GameState.nextTurn;

var pieces = <CheckerPiece>[];
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
      if ((i + j) % 2 == 1) {
        putPiece(i, j, Player.player1);
      }
    }
  }
  for (int i = 5; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if ((i + j) % 2 == 1) {
        putPiece(i, j, Player.player2);
      }
    }
  }
}

void main() {
  runApp(const MyApp());
  initializeGame();
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

class CheckerBoard extends StatelessWidget {
  const CheckerBoard({Key? key}) : super(key: key);

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
  late double size;

  Text _checkplayer() {
    if (widget.player == Player.player1 && widget.hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.red, fontSize: size * 0.0625));
    } else if (widget.player == Player.player2 && widget.hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.blue, fontSize: size * 0.0625));
    } else {
      return const Text("");
    }
  }

  Text piece = const Text("");

  void _setPiece() {
    setState(() {
      piece = _checkplayer();
    });
  }

  void initializeSize() {
    if (MediaQuery.of(context).size.height >
        MediaQuery.of(context).size.width) {
      size = MediaQuery.of(context).size.width;
    } else {
      size = MediaQuery.of(context).size.height;
    }
  }

  void setPlayerState(Player player) {
    setState(() {
      widget.player = player;
    });
  }

  void checkTurn(Player currentPlayer, Turn nextTurn) {
    if (widget.player == currentPlayer) {
      putPiece(widget.row, widget.column, Player.player1);
      if (gameState == GameState.nextTurn) {
        gameState = GameState.currentTurn;
        setPlayerState(Player.empty);
        _setPiece();
      }
    } else {
      if (widget.player == Player.outOfBounds) {
        setPlayerState(Player.empty);
        _setPiece();
      } else if (gameState == GameState.currentTurn) {
        if (widget.player == Player.empty) {
          gameState = GameState.nextTurn;
          setPlayerState(currentPlayer);
          _setPiece();
          turn = nextTurn;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeSize();
    _setPiece();
    return GestureDetector(
      onTap: () {
        if (turn == Turn.player1) {
          checkTurn(Player.player1, Turn.player2);
        } else {
          checkTurn(Player.player2, Turn.player1);
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
