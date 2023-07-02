
// ignore_for_file: avoid_print, sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import '../model/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Position _currentPosition ;//= Position(latitude: 0, longitude: 0, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0, timestamp: null);
  String lat = "6.460329";
  String long = "100.5010041";
  String loc = "";
  String state = "";
  //bool _isMounted = false;
  StreamSubscription<Position>? _positionStreamSubscription; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('MyCheckIn')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Click the button below to check in", style: TextStyle(fontSize: 20),),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _checkin, child: const Text("Check In"),
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(100, 50)), // Set the minimum size
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 20)), // Set the text style
              ),)
            ],
         ),
      )
      
    );
  }

  void _checkin() {
    //if (!_isMounted) return; // Check if the widget is still mounted

    http.post(
      Uri.parse("${Config.server}/mycheckin/php/add_checkin.php"),
      body: {
        "userid": widget.user.id.toString(),
        "lat": lat,
        "long": long,
        "loc": loc,
        "state": state,
      },
    ).then((response) {
      //if (!_isMounted) return; // Check if the widget is still mounted

      var responseBody = response.body;
      responseBody = responseBody.replaceFirst("array(9)", "");
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("line 157");

      if (response.statusCode == 200) {
        print("line 160");
        //if (mounted) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Success")),
          );
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (content) => MainScreen(user: widget.user),
            ),
          );
        });
        //}
      } else {
        print("HTTP request failed with status code: ${response.statusCode}");
        //if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Failed")),
          );
          Navigator.pop(context);
        //}
      }
    }).catchError((error) {
      print("Error: $error");
      //if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Failed")),
        );
        Navigator.pop(context);
      //}
    });
  }

  void _determinePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    
    _currentPosition = await Geolocator.getCurrentPosition();
    /*setState(() {
      _getGPS(_currentPosition);
    });*/
    _getGPS(_currentPosition);
  }

  _getGPS(Position pos) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    //if (_isMounted) {
      //setState(() {
        if (placemarks.isEmpty) {
          lat = "6.443455345";
          long = "100.05488449";
          loc = ""; // Set a default value for location when placemarks are empty
          state = ""; // Set a default value for state when placemarks are empty
        } else {
          lat = pos.latitude.toString();
          long = pos.longitude.toString();
          loc = placemarks[0].locality ?? ""; // Use null-aware operator to handle null value
          state = placemarks[0].administrativeArea ?? ""; // Use null-aware operator to handle null value
        }
        setState(() {});
      //});
    //}
  }


  @override
  void initState() {
    super.initState();
    //_isMounted = true;
    _determinePermission();
  }

  /*@override
  void dispose() {
    //_isMounted = false;
    _positionStreamSubscription?.cancel(); // Cancel the position stream subscription
    super.dispose();
  }*/

}