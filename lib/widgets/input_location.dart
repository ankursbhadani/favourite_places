import 'dart:convert';

import 'package:favourite_places/model/places.dart';
import 'package:favourite_places/screens/map_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class InputLocation extends StatefulWidget {
  const InputLocation({super.key, required this.onSelectLocation});

  final Function(PlaceLocation placeLocation) onSelectLocation;

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  PlaceLocation? _pickedLocation;
  var _isgettingLocation = false;

  String get imageLocation {
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=14&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyARUn_Hp50P6uJ6A7CySh8M8Z_oTSp7XHw";
  }

  void _savePlace(double latitude, double longitude) {}

  Future<void> _saveLocation(double latitude, double longitude) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyARUn_Hp50P6uJ6A7CySh8M8Z_oTSp7XHw");
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];
    setState(() {
      _isgettingLocation = false;
      _pickedLocation = PlaceLocation(
          longitude: longitude, latitude: latitude, address: address);
      widget.onSelectLocation(_pickedLocation!);
      print("This is Adress $address");
    });
  }

  _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isgettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _saveLocation(lat, lng);
  }

  Future<void> _selecteOnMap() async {
    final pickedLocation = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: (context) => const MapScreen()));
    if(pickedLocation == null){
      return;
    }
    _saveLocation(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget priviewContent = Text("No location selected",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ));
    if (_pickedLocation != null) {
      priviewContent = Image.network(
        imageLocation,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isgettingLocation) {
      priviewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: Colors.white.withOpacity(0.3))),
          height: 250,
          width: double.infinity,
          child: priviewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text("Get Location")),
            TextButton.icon(
                onPressed: _selecteOnMap,
                icon: const Icon(Icons.map),
                label: const Text("Choose Location")),
          ],
        ),
      ],
    );
  }
}
