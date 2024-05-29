import 'package:flutter/material.dart';

class NumpadWidget extends StatelessWidget {
  const NumpadWidget({
    super.key,
    required this.typeNumber,
    required this.answer,
    required this.clearAnswer,
  });

  final void Function(int) typeNumber;
  final VoidCallback clearAnswer;
  final VoidCallback answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => typeNumber(1),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(2),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(3),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => typeNumber(4),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '4',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(5),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '5',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(6),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '6',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => typeNumber(7),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '7',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(8),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '8',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: () => typeNumber(9),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text(
                  '9',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 32),
                )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => typeNumber(0),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('0',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 32))),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: clearAnswer,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('C',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 32))),
            const SizedBox(width: 36),
            ElevatedButton(
                onPressed: answer,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0x00d7542b).withOpacity(1),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('GO',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 32))),
          ],
        )
      ],
    );
  }
}
