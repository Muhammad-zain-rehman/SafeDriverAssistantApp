import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'CounterListing.dart';



void main() => runApp(MaterialApp(home: ReverseCountdownPage()));


class ReverseCountdownPage extends StatefulWidget {
  final int? initialSeconds;

  ReverseCountdownPage({this.initialSeconds});

  @override
  _ReverseCountdownPageState createState() => _ReverseCountdownPageState();
}

class _ReverseCountdownPageState extends State<ReverseCountdownPage> {
  late int _initialDurationInSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;

  late AudioPlayer _audioPlayer;
  Timer? _alarmStopTimer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    setInitialDuration(widget.initialSeconds ?? 2 * 60 * 60);
  }

  void _startTimer() {
    if (_isRunning) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _stopTimer();
        _playAlarm();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });

    setState(() {
      _isRunning = true;
    });
  }


  Future<void> _playAlarm() async {
    await _audioPlayer.setVolume(0.8); // Set volume to 80%
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop mode
    await _audioPlayer.play(AssetSource('sounds/alarm_2.mp3'));

    _alarmStopTimer = Timer(Duration(seconds: 15), () async {
      await _audioPlayer.stop();
    });
  }


  void setInitialDuration(int seconds) {
    _initialDurationInSeconds = seconds;
    _remainingSeconds = seconds;
    _stopTimer(); // reset any running timer
    setState(() {}); // rebuild UI
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {});
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer?.cancel();
    _alarmStopTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // title: Text("Reverse Countdown Timer"),
        title: Row(
          children: [
            Text(" Safe Driver Assistant"),
            Spacer(),
            InkWell(
              onTap:() async {
                final selectedSeconds = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TimeSelectorPage(),
                  ),
                );

                if (selectedSeconds != null && selectedSeconds is int) {
                  setInitialDuration(selectedSeconds);
                }
              },
              child: Icon(
                Icons.access_alarm,
                size: 35,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_remainingSeconds),
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text("Start"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text("Stop"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}



// class ReverseCountdownPage extends StatefulWidget {
//   @override
//   _ReverseCountdownPageState createState() => _ReverseCountdownPageState();
// }
//
// class _ReverseCountdownPageState extends State<ReverseCountdownPage> {
//   late int _initialDurationInSeconds;
//   late int _remainingSeconds;
//   Timer? _timer;
//   bool _isRunning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     setInitialDuration(2 * 60 * 60); // default: 2 hours
//   }
//
//   void setInitialDuration(int seconds) {
//     _initialDurationInSeconds = seconds;
//     _remainingSeconds = seconds;
//     _stopTimer();
//     setState(() {});
//   }
//
//   void _startTimer() {
//     if (_isRunning) return;
//
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_remainingSeconds == 0) {
//         _stopTimer();
//       } else {
//         setState(() {
//           _remainingSeconds--;
//         });
//       }
//     });
//
//     setState(() {
//       _isRunning = true;
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     _isRunning = false;
//     setState(() {});
//   }
//
//   Future<void> _navigateAndSetNewTime() async {
//     final selectedSeconds = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => TimeSelectorPage()),
//     );
//
//     if (selectedSeconds != null && selectedSeconds is int) {
//       setInitialDuration(selectedSeconds);
//     }
//   }
//
//   String _formatDuration(int totalSeconds) {
//     final hours = totalSeconds ~/ 3600;
//     final minutes = (totalSeconds % 3600) ~/ 60;
//     final seconds = totalSeconds % 60;
//     return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
//   }
//
//   String _twoDigits(int n) => n.toString().padLeft(2, '0');
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text("Reverse Countdown Timer"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.access_time),
//             tooltip: "Change Timer",
//             onPressed: _navigateAndSetNewTime,
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _formatDuration(_remainingSeconds),
//               style: TextStyle(
//                 fontSize: 60,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: _startTimer,
//                   child: Text("Start"),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     backgroundColor: Colors.green,
//                     textStyle: TextStyle(fontSize: 20),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: _stopTimer,
//                   child: Text("Stop"),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     backgroundColor: Colors.red,
//                     textStyle: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
