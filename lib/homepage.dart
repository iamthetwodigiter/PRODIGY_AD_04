import 'dart:math';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> gridState = List.filled(9, '');
  String winner = '';
  List<int> winningCombination = [];
  String user = 'X';
  String bot = 'O';

  bool isTapped(int index) {
    return gridState[index].isNotEmpty;
  }

  void botResponse() {
    if (winner.isEmpty) {
      List<int> availableIndexes = [];
      for (int i = 0; i < gridState.length; i++) {
        if (gridState[i].isEmpty) {
          availableIndexes.add(i);
        }
      }

      if (availableIndexes.isNotEmpty) {
        int random =
            availableIndexes[Random().nextInt(availableIndexes.length)];
        setState(() {
          gridState[random] = bot;
          checkWinner();
        });
      }
    }
  }

  void checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (gridState[combination[0]] == gridState[combination[1]] &&
          gridState[combination[1]] == gridState[combination[2]] &&
          gridState[combination[0]].isNotEmpty) {
        setState(() {
          winner = '${gridState[combination[0]]} wins!';
          winningCombination = combination;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tic-Tac-Toe',
              style: TextStyle(
                fontSize: 50,
                color: CupertinoColors.activeOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.6,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (gridState[index].isEmpty && winner.isEmpty) {
                        setState(() {
                          gridState[index] = user;
                          checkWinner();
                          if (winner.isEmpty) {
                            botResponse();
                            if (!gridState.contains('')) {
                              setState(() {
                                winner = 'Tie!';
                              });
                            }
                          }
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: double.infinity,
                          width: double.infinity,
                          color: CupertinoColors.darkBackgroundGray,
                          child: Center(
                            child: Text(
                              gridState[index],
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (winner.isNotEmpty &&
                            winningCombination.contains(index))
                          Positioned.fill(
                            child: CustomPaint(
                              painter: StrikethroughPainter(winningCombination),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (winner.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  winner,
                  style: const TextStyle(
                    fontSize: 30,
                    color: CupertinoColors.activeGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            CupertinoButton(
              color: CupertinoColors.activeOrange,
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  gridState = List.filled(9, '');
                  winner = '';
                  winningCombination = [];
                });
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('User\'s choice:', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 15),
                const Text('X'),
                CupertinoSwitch(
                    value: user == 'O',
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          user = 'O';
                          bot = 'X';
                        } else {
                          user = 'X';
                          bot = 'O';
                        }
                      });
                    }),
                const Text('O'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StrikethroughPainter extends CustomPainter {
  final List<int> winningCombination;

  StrikethroughPainter(this.winningCombination);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.activeGreen
      ..strokeWidth = 5;

    if (winningCombination.isEmpty) return;

    if (winningCombination.contains(0) &&
        winningCombination.contains(1) &&
        winningCombination.contains(2)) {
      canvas.drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), paint);
    } else if (winningCombination.contains(3) &&
        winningCombination.contains(4) &&
        winningCombination.contains(5)) {
      canvas.drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), paint);
    } else if (winningCombination.contains(6) &&
        winningCombination.contains(7) &&
        winningCombination.contains(8)) {
      canvas.drawLine(Offset(0, size.height / 2),
          Offset(size.width, size.height / 2), paint);
    } else if (winningCombination.contains(0) &&
        winningCombination.contains(3) &&
        winningCombination.contains(6)) {
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height), paint);
    } else if (winningCombination.contains(1) &&
        winningCombination.contains(4) &&
        winningCombination.contains(7)) {
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height), paint);
    } else if (winningCombination.contains(2) &&
        winningCombination.contains(5) &&
        winningCombination.contains(8)) {
      canvas.drawLine(Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height), paint);
    } else if (winningCombination.contains(0) &&
        winningCombination.contains(4) &&
        winningCombination.contains(8)) {
      canvas.drawLine(
          const Offset(0, 0), Offset(size.width, size.height), paint);
    } else if (winningCombination.contains(2) &&
        winningCombination.contains(4) &&
        winningCombination.contains(6)) {
      canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
