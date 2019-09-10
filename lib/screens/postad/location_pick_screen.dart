import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

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
    markers.add(marker);
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pickLocation),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCameraMoving
            ? null
            : () {
                Navigator.pop(context, marker.position);
              },
        label: Text(AppLocalizations.of(context).selectCurrentLocation),
        icon: Icon(Icons.check),
      ),
      body: SafeArea(
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
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
                  infoWindow: InfoWindow(
                      title: AppLocalizations.of(context).yourLocation));
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

  Future _requestPermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (status != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
        setState(() {});
      }
    }
  }
}
