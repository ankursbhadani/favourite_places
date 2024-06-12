import 'package:favourite_places/model/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;

  const MapScreen({Key? key,this.location = const PlaceLocation(longitude: 32.422, latitude: -122.084, address: ''),this.isSelecting=true}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting?'Pick Your Location':'Your Location'),
        actions: [
          if(widget.isSelecting)
            IconButton(onPressed: (){
              Navigator.of(context).pop(_pickedLocation);
            }, icon: const Icon(Icons.save)),
        ],
      ),
      body: GoogleMap(
        onTap: widget.isSelecting == false? null: (position){
          setState(() {
            _pickedLocation=position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 15,
        ),
        markers:(_pickedLocation==null && widget.isSelecting)?{}: {
          Marker(
            markerId: const MarkerId('selected-location'),
            position:_pickedLocation !=null? _pickedLocation!: LatLng(widget.location.latitude, widget.location.longitude),
          ),
        },
      ),
    );
  }
}
