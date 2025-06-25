// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
// class _HomePageState extends State<HomePage> {
//   late GoogleMapController mapController;
//   // :red_circle: Your desired location (replace with any LatLng)
//   final LatLng _desiredLocation = const LatLng(12.9716, 77.5946); // Bangalore
//   final LatLng1 _currentLocation= const LatLng(28.613939, 77.209023);
//   final Set<Marker> _markers = {};
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('desired_location'),
//           position: _desiredLocation,
//           infoWindow: const InfoWindow(title: 'India Gate, Delhi'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
        
//       );
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Map with Marker')),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _desiredLocation,
//           zoom: 20.0,
//         ),
//         markers: _markers,
//         myLocationEnabled: false,
//         zoomControlsEnabled: true,
//       ),
//     );
//   }
// }



