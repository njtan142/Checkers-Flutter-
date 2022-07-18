import 'package:flutter/material.dart';

/*
This is a casual game app made in flutter

Code Breakdown:
  > initializing enums for the game to be used as states
    > There are 3 enums
      > PieceState: the state of the piece
      > GameState: the state of the game
      > TurnState: the state of the turn

  > initializing the game board
    > There are 2 arrays that will be used for gamestate and move validation
      > widgetPiecesArray: the array that will hold the widget pieces, to change the state of the piece
      > piecesArray: the array that will hold the pieces, to check if the move is valid and which piece to change the state of
        > the function initializeGame() will put the initial pieces in the piecesArray


 */

//global variables
// two dimensional aray with 8 rows and 8 columns

enum PieceState {
  player1,
  player2,
  empty,
  outOfBounds
} //represents the state of a cell(tells what kind of cell it is)

enum TurnState { player1, player2 } //represents the turn of the player

enum GameState { currentTurn, nextTurn } //represents the state of the game

TurnState turn = TurnState.player1; //initial turn

GameState gameState = GameState.nextTurn; //initial state of the game

var widgetPiecesArray = <CheckerPiece>[]; //array of checker pieces by widget

var piecesArray = [
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
]; //array of checker pieces by int(to represent what type of piece is in the cell)

void putPiece(int row, int col, PieceState player) {
  if (player == PieceState.player1) {
    piecesArray[row][col] = 1;
  } else if (player == PieceState.player2) {
    piecesArray[row][col] = 2;
  } else if (player == PieceState.empty) {
    piecesArray[row][col] = 0;
  } else {
    piecesArray[row][col] = -1;
  }
}

void initializeGame() {
  // put pieces on the board, row 1 to 3 are player 1, row 6 to 8 are player 2
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if ((i + j) % 2 == 1) {
        if (i < 3) {
          putPiece(i, j, PieceState.player1);
        } else if (i > 4) {
          putPiece(i, j, PieceState.player2);
        } else {
          putPiece(i, j, PieceState.empty);
        }
      } else {
        putPiece(i, j, PieceState.outOfBounds);
      }
    }
  }
}

void putPieces() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (piecesArray[i][j] == -1) {
        widgetPiecesArray.add(CheckerPiece(
            hue: Colors.white,
            row: i,
            column: j,
            player: PieceState.outOfBounds));
      } else if (piecesArray[i][j] == 0) {
        widgetPiecesArray.add(CheckerPiece(
            hue: Colors.black, row: i, column: j, player: PieceState.empty));
      } else if (piecesArray[i][j] == 1) {
        widgetPiecesArray.add(CheckerPiece(
            hue: Colors.black, row: i, column: j, player: PieceState.player1));
      } else if (piecesArray[i][j] == 2) {
        widgetPiecesArray.add(CheckerPiece(
            hue: Colors.black, row: i, column: j, player: PieceState.player2));
      }
    }
  }
}

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
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.70,
              height: MediaQuery.of(context).size.height * 0.70,
              child: const CheckerBoard(),
            )
          ],
        ),
      ),
    );
  }
}

class CheckerBoard extends StatelessWidget {
  const CheckerBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeGame();
    putPieces();
    return GridView.count(
      crossAxisCount: 8,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: widgetPiecesArray,
    );
  }
}

class CheckerPiece extends StatefulWidget {
  Color hue;

  final int row;
  final int column;

  PieceState player;

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
    if (widget.player == PieceState.player1 && widget.hue == Colors.black) {
      return Text("⬤",
          style: TextStyle(color: Colors.red, fontSize: size * 0.0625));
    } else if (widget.player == PieceState.player2 &&
        widget.hue == Colors.black) {
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

  void setPlayerState(PieceState player) {
    setState(() {
      widget.player = player;
    });
  }

  void checkTurn(PieceState currentPlayer, TurnState nextTurn) {
    if (widget.player == currentPlayer) {
      putPiece(widget.row, widget.column, PieceState.player1);
      if (gameState == GameState.nextTurn) {
        gameState = GameState.currentTurn;
        setPlayerState(PieceState.empty);
        _setPiece();
      }
    } else {
      if (widget.player == PieceState.outOfBounds) {
        setPlayerState(PieceState.empty);
        _setPiece();
      } else if (gameState == GameState.currentTurn) {
        if (widget.player == PieceState.empty) {
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
        if (turn == TurnState.player1) {
          checkTurn(PieceState.player1, TurnState.player2);
        } else {
          checkTurn(PieceState.player2, TurnState.player1);
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
