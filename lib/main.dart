import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker? origin;
  Marker? destination;

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Google Map",
        ),
      ),
      body: Container(
        child: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
          markers: {
            if (origin != null) origin!,
            if (destination != null) destination!,
          },
          onLongPress: _addMarker,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        onPressed: () {
          _googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
        child: Icon(
          Icons.center_focus_strong,
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "Origin"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        destination = null;
      });
    } else {
      setState(() {
        destination = Marker(
          markerId: MarkerId("destination"),
          infoWindow: InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
    }
  }
}
