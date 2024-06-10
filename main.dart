import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimerButton extends StatefulWidget {
  const TimerButton({super.key});

  @override
  TimerButtonState createState() => TimerButtonState();
}

class TimerButtonState extends State<TimerButton> {
  late DateTime _now;
  late Duration _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _calculateTimeRemaining();
    _startTimer();
  }

  void _calculateTimeRemaining() {
    _now = DateTime.now();
    final endOfYear = DateTime(_now.year + 1, 1, 1);
    setState(() {
      _timeRemaining = endOfYear.difference(_now);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      _calculateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatCurrentDateTime() {
    final DateFormat formatter = DateFormat('yyyyy.MMMM.dd  hh:mm:ss');
    final String formattedDate = formatter.format(_now);
    return formattedDate;
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "$days : $hours : $minutes : $seconds";
  }

  double _calculateYearCompletionPercentage() {
    final startOfYear = DateTime(_now.year, 1, 1);
    final endOfYear = DateTime(_now.year + 1, 1, 1);
    final yearDuration = endOfYear.difference(startOfYear).inMilliseconds;
    final elapsed = _now.difference(startOfYear).inMilliseconds;
    return elapsed / yearDuration;
  }

  @override
  Widget build(BuildContext context) {
    print("hello");
    final percentageCompleted = _calculateYearCompletionPercentage() * 100;
    final percentageText = "${percentageCompleted.toStringAsFixed(2)}%";

    return Scaffold(
      appBar: AppBar(title: const Text('Year Progress Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatCurrentDateTime(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 30.0,
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: percentageCompleted / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      percentageText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Year in Progress',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              _formatDuration(_timeRemaining),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TimerButton(),
  ));
}
