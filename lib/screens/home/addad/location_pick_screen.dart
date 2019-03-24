import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool _isCameraMoving = false;
  var markers = Set<Marker>();
  var marker = Marker(
      markerId: MarkerId("marker"), position: LatLng(25.276987, 55.296249));

  @override
  void initState() {
    super.initState();
    markers.add(marker);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCameraMoving ? null : () {},
        label: Text('Select Location'),
        icon: Icon(Icons.check),
      ),
      body: SafeArea(
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          markers: markers,
          onMapCreated: (map) {
            _controller.complete(map);
          },
          onCameraIdle: () {
            setState(() {
              _isCameraMoving = false;
            });
          },
          onCameraMove: (position) {
            setState(() {
              markers.remove(marker);
              var newMarker = Marker(
                  markerId: MarkerId("marker"),
                  position: position.target,
                  infoWindow: InfoWindow(title: "Your location"));
              markers.add(newMarker);
              this.marker = newMarker;
              _isCameraMoving = true;
            });
          },
          initialCameraPosition:
              CameraPosition(target: LatLng(25.276987, 55.296249), zoom: 12),
        ),
      ),
    );
  }
}
