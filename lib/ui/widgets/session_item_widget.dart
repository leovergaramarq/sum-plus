import 'package:flutter/material.dart';
import 'package:sum_plus/domain/models/session.dart';

class SessionItemWidget extends StatelessWidget {
  const SessionItemWidget(
      {super.key, required this.session, required this.numSession});

  final Session session;
  final int numSession;

  Widget sessionMainInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.av_timer,
              size: 36,
              color: Colors.grey.shade700,
            ),
            Text(
              Session.formatTime(session.totalSeconds),
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.task_outlined,
              size: 36,
              color: Colors.grey.shade700,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text:
                        '${session.numCorrectAnswers}/${session.numAnswers} (',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${(session.numCorrectAnswers / session.numAnswers * 100).round()}%',
                    style: TextStyle(
                      color:
                          session.numCorrectAnswers / session.numAnswers >= 0.5
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                      fontSize: 18,
                    ),
                  ),
                  const TextSpan(
                    text: ')',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/img/random_art.png', // Reemplaza con la ruta de tu imagen de fondo
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(12, 16, 0, 16),
                  child: sessionMainInfoWidget())
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '#$numSession',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700),
                ),
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Session.formatDate(session.dateStart),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
