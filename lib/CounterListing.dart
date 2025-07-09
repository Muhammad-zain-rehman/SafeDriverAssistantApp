import 'package:flutter/material.dart';
import 'main.dart';

import 'package:flutter/material.dart';

class TimeSelectorPage extends StatefulWidget {
  @override
  _TimeSelectorPageState createState() => _TimeSelectorPageState();
}

class _TimeSelectorPageState extends State<TimeSelectorPage> {
  // All values are in seconds
  List<int> _timeOptions = [2 * 3600, 3 * 3600, 4 * 3600];

  void _addNewTime() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New Reminde'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter time for your reminder',
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              final input = int.tryParse(controller.text);
              if (input != null && input > 0) {
                setState(() => _timeOptions.add(input));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    final buffer = <String>[];
    if (h > 0) buffer.add('${h}h');
    if (m > 0) buffer.add('${m}m');
    if (s > 0 || buffer.isEmpty) buffer.add('${s}s');
    return buffer.join(' ');
  }

  void _selectTime(int seconds) {
    Navigator.pop(context, seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Select Reminder"),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _addNewTime),
        ],
      ),
      body: ListView.builder(
        itemCount: _timeOptions.length,
        itemBuilder: (ctx, i) {
          final sec = _timeOptions[i];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              title: Text(_formatDuration(sec)),
              onTap: () => _selectTime(sec),
            ),
          );
        },
      ),
    );
  }
}





// class TimeSelectorPage extends StatefulWidget {
//   @override
//   _TimeSelectorPageState createState() => _TimeSelectorPageState();
// }
//
// class _TimeSelectorPageState extends State<TimeSelectorPage> {
//   List<int> _timeOptions = [2 * 3600, 3 * 3600, 4 * 3600]; // all in seconds
//
//   void _addNewTime() {
//     final controller = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Add New Timer'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             labelText: 'Enter time (seconds or hours)',
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: Text("Cancel"),
//             onPressed: () => Navigator.pop(context),
//           ),
//           ElevatedButton(
//             child: Text("Add"),
//             onPressed: () {
//               final enteredValue = int.tryParse(controller.text);
//               if (enteredValue != null && enteredValue > 0) {
//                 // final seconds = enteredValue >= 60 ? enteredValue * 3600 : enteredValue;
//                 final seconds = enteredValue;
//
//                 setState(() {
//                   _timeOptions.add(seconds);
//                 });
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _selectTime(int hours) {
//     final seconds = hours * 60 * 60;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ReverseCountdownPage(initialSeconds: seconds),
//       ),
//     );
//   }
//
//   String _formatDuration(int totalSeconds) {
//     final h = totalSeconds ~/ 3600;
//     final m = (totalSeconds % 3600) ~/ 60;
//     final s = totalSeconds % 60;
//
//     final buffer = <String>[];
//     if (h > 0) buffer.add('${h}h');
//     if (m > 0) buffer.add('${m}m');
//     if (s > 0 || buffer.isEmpty) buffer.add('${s}s');
//
//     return buffer.join(' ');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Timer Duration"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: _addNewTime,
//           )
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: _timeOptions.length,
//         itemBuilder: (context, index) {
//           final time = _timeOptions[index];
//           return InkWell(
//             onTap: (){
//               final selectedSeconds = time * 3600;
//               Navigator.pop(context, selectedSeconds);
//             },
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 title:Text(
//                   _formatDuration(time),
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 trailing: Icon(Icons.chevron_right),
//                 onTap: () => _selectTime(time),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
