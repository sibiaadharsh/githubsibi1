// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class MapTaskScreen extends StatefulWidget {
//   const MapTaskScreen({super.key});

//   @override
//   _MapTaskScreenState createState() => _MapTaskScreenState();
// }

// class _MapTaskScreenState extends State<MapTaskScreen> {
//   GoogleMapController? _mapController;
//   final LatLng _initialCenter = LatLng(12.9716, 77.5946); // Default: Bangalore
//   final Set<Marker> _markers = {};
//   LatLng? _currentPosition;
//   final Set<Polyline> _polylines = {};
//   double _zoom = 14.0;

//   // Future<void> _getCurrentLocation() async {
//   //   LocationPermission  permission = await Geolocator.checkPermission();

//   //   Position position = await Geolocator.getCurrentPosition(
//   //       desiredAccuracy: LocationAccuracy.high);
//   //   LatLng userLatLng = LatLng(position.latitude, position.longitude);

//   //   // Update map camera
//   //   _mapController?.animateCamera(CameraUpdate.newLatLng(userLatLng));

//   //   // Add marker at current location
//   //   setState(() {
//   //     _currentPosition = LatLng(12.9716, 77.5946);
//   //     _markers.add(
//   //       Marker(
//   //         markerId: MarkerId("user_location"),
//   //         position: _currentPosition!,//null-safety
//   //         infoWindow: InfoWindow(title: "You are here"),
//   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
//   //       ),
//   //     );

//   //     // Example Polyline between user and hardcoded point
//   //     LatLng destination = LatLng(12.9352, 77.6146); // Example point
//   //     _polylines.add(
//   //       Polyline(
//   //         polylineId: PolylineId("route"),
//   //         points: [userLatLng, destination],
//   //         color: Colors.blue,
//   //         width: 5,
//   //       ),
//   //     );

//   //     // Add destination marker
//   //     _markers.add(
//   //       Marker(
//   //         markerId: MarkerId("destination"),
//   //         position: destination,
//   //         infoWindow: InfoWindow(title: "Destination"),
//   //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//   //       ),
//   //     );
//   //   });

//   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //     content: Text("Lat: ${position.latitude}, Lng: ${position.longitude}"),
//   //   ));
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Google Map Task")),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _initialCenter,
//               zoom: _zoom,
//             ),
//             onMapCreated: (controller) => _mapController = controller,
//             markers: _markers,
//             polylines: _polylines,
//             myLocationEnabled: true,
//           ),
//           Positioned(
//             bottom: 20,
//             left: 10,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   heroTag: "zoom_in",
//                   mini: true,
//                   child: Icon(Icons.zoom_in),
//                   onPressed: () {
//                     _zoom += 1;
//                     _mapController?.moveCamera(CameraUpdate.zoomTo(_zoom));
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: "zoom_out",
//                   mini: true,
//                   child: Icon(Icons.zoom_out),
//                   onPressed: () {
//                     _zoom -= 1;
//                     _mapController?.moveCamera(CameraUpdate.zoomTo(_zoom));
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: "locate",
//                   // onPressed: _getCurrentLocation,
//                   child: Icon(Icons.my_location),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
/*
//program to display maps with markers and Polylines
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  
  // Desired location (Bangalore)
  final LatLng _desiredLocation = const LatLng(12.9716, 77.5946);
  
  // Current location (Delhi)
  final LatLng _currentLocation = const LatLng(28.613939, 77.209023);
  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    
    setState(() {
      // Add desired location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('desired_location'),
          position: _desiredLocation,
          infoWindow: const InfoWindow(title: 'Bangalore'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      
      // Add current location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation,
          infoWindow: const InfoWindow(title: 'Delhi'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      
      // Add polyline between the two points
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_currentLocation, _desiredLocation],
          color: Colors.green,
          width: 4,
        ),
      );
    });
    
    // Adjust camera to show both markers
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _currentLocation.latitude < _desiredLocation.latitude 
              ? _currentLocation.latitude 
              : _desiredLocation.latitude,
            _currentLocation.longitude < _desiredLocation.longitude 
              ? _currentLocation.longitude 
              : _desiredLocation.longitude,
          ),
          northeast: LatLng(
            _currentLocation.latitude > _desiredLocation.latitude 
              ? _currentLocation.latitude 
              : _desiredLocation.latitude,
            _currentLocation.longitude > _desiredLocation.longitude 
              ? _currentLocation.longitude 
              : _desiredLocation.longitude,
          ),
        ),
        100.0, // padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map with Markers and Route')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _desiredLocation,
          zoom: 5.0, // Lower zoom to show both locations initially
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
*/
//use gps_geolocator
/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  LatLng? _currentLocation;
  String? _currentAddress;
  bool _isLoading = false;
  final Set<Marker> _markers = {};
  // final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Check if location services are enabled
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _currentAddress = "${place.street}, ${place.locality}, ${place.country}";
        });
      }

      // Update map with current location
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentLocation!,
            infoWindow: InfoWindow(title: _currentAddress ?? "Current Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      // Move camera to current location
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live GPS Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6139, 77.2090), // Default: Delhi
              zoom: 12,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
*/
//use curretn location using geo locator, 2-markers on current and desired location using lat,Long,and 
//info window showing details of state along with the network image  
//caught with error- "location permission denied"
// import 'dart:async';
// // import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/services.dart';

// class GoogleMapTask extends StatefulWidget {
//   const GoogleMapTask({super.key});

//   @override
//   State<GoogleMapTask> createState() => _GoogleMapTaskState();
// }

// class _GoogleMapTaskState extends State<GoogleMapTask> {
//   late GoogleMapController mapController;
//   LatLng? _currentLocation;
//   String? _currentAddress;
//   bool _isLoading = false;
//   double _zoomLevel = 12;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   final LatLng _landmark1 = const LatLng(28.6139, 77.2090); // Delhi
//   final LatLng _landmark2 = const LatLng(12.9716, 77.5946); // Bangalore

//   @override
//   void initState() {
//     super.initState();
//     _setupMarkers();
//     _setupPolyline();
//   }

//   Future<Uint8List> _getBytesFromNetworkImage(String url, {int width = 100}) async {
//     final image = CachedNetworkImageProvider(url);
//     final completer = Completer<ImageInfo>();
//     final stream = image.resolve(ImageConfiguration(size: Size(width.toDouble(), width.toDouble())));
//     final listener = ImageStreamListener((ImageInfo info, bool _) {
//       completer.complete(info);
//     });
//     stream.addListener(listener);
//     final imageInfo = await completer.future;
//     final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }

//   void _setupMarkers() async {
//     final Uint8List markerIcon = await _getBytesFromNetworkImage(
//       'https://cdn-icons-png.flaticon.com/512/684/684908.png',
//     );

//     setState(() {
//       _markers.addAll([
//         Marker(
//           markerId: const MarkerId('landmark1'),
//           position: _landmark1,
//           infoWindow: const InfoWindow(title: 'Delhi (Landmark 1)'),
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ),
//         Marker(
//           markerId: const MarkerId('landmark2'),
//           position: _landmark2,
//           infoWindow: const InfoWindow(title: 'Bangalore (Landmark 2)'),
//           icon: BitmapDescriptor.fromBytes(markerIcon),
//         ),
//       ]);
//     });
//   }

//   void _setupPolyline() {
//     setState(() {
//       _polylines.add(
//         Polyline(
//           polylineId: const PolylineId('route'),
//           points: [_landmark1, _landmark2],
//           color: Colors.blue,
//           width: 4,
//         ),
//       );
//     });
//   }

//   Future<void> _requestLocationPermission() async {
//     if (await Permission.location.request().isGranted) {
//       await _getCurrentLocation();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location permission denied")),
//       );
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() => _isLoading = true);
//     try {
//       bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!isLocationEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Enable GPS in settings")),
//         );
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       final LatLng currentLatLng = LatLng(position.latitude, position.longitude);
//       final String address = placemarks.isNotEmpty
//           ? "${placemarks.first.street}, ${placemarks.first.locality}"
//           : "Unknown Location";

//       setState(() {
//         _currentLocation = currentLatLng;
//         _currentAddress = address;

//         _markers.add(
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: currentLatLng,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//             onTap: () => _showCurrentLocationInfo(),
//           ),
//         );
//       });

//       mapController.animateCamera(
//         CameraUpdate.newLatLngZoom(currentLatLng, _zoomLevel),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _zoomIn() {
//     mapController.animateCamera(CameraUpdate.zoomIn());
//     setState(() => _zoomLevel += 1);
//   }

//   void _zoomOut() {
//     mapController.animateCamera(CameraUpdate.zoomOut());
//     setState(() => _zoomLevel -= 1);
//   }

//   void _showCurrentLocationInfo() {
//     if (_currentLocation == null) return;

//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           height: 200,
//           child: Column(
//             children: [
//               Text(_currentAddress ?? "Your Location", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 10),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: CachedNetworkImage(
//                   imageUrl: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
//                   height: 100,
//                   width: 100,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text("You are here!", style: TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Google Map Task")),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (controller) => mapController = controller,
//             initialCameraPosition: CameraPosition(
//               target: _landmark1,
//               zoom: _zoomLevel,
//             ),
//             markers: _markers,
//             polylines: _polylines,
//             myLocationEnabled: false,
//           ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator()),
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'gps',
//                   onPressed: _requestLocationPermission,
//                   backgroundColor: Colors.orange,
//                   child: const Icon(Icons.gps_fixed),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: 'zoomIn',
//                   mini: true,
//                   onPressed: _zoomIn,
//                   child: const Icon(Icons.add),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: 'zoomOut',
//                   mini: true,
//                   onPressed: _zoomOut,
//                   child: const Icon(Icons.remove),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
/* jun12,2025 - polylines showing current location from california , delhi and bangalore 
//program to display using geo locator, reverse geo coding, markers , polylines and image along with state name and address 
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'geocoding.dart'; -not needed since we use http

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _desiredLocation = const LatLng(12.9716, 77.5946); // Bangalore
  final LatLng _staticLocation = const LatLng(28.6139, 77.2090); // Delhi

  LatLng? _userLocation;
  String? _userAddress;
  String? _userState;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _setupInitialMarkers();
    _setupPolyline();
    _getUserLocation();
  }

  void _setupInitialMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('bangalore'),
        position: _desiredLocation,
        infoWindow: const InfoWindow(title: 'Bangalore',

        snippet: 'Electronic Capital of India',

        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('delhi'),
        position: _staticLocation,
        infoWindow: const InfoWindow(title: 'Delhi',
        snippet: 'Capital of India',

        ),

        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    ]);
  }

  void _setupPolyline() {
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_staticLocation, _desiredLocation],
        color: Colors.green,
        width: 4,
      ),
    );
  }
// method to use _getUserLocation()
  // Future<void> _getUserLocation() async {
  //   if (await Permission.location.request().isGranted) {
  //     bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!isLocationEnabled) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please enable GPS")),
  //       );
  //       return;
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     LatLng currentLatLng = LatLng(position.latitude, position.longitude);

  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       currentLatLng.latitude,
  //       currentLatLng.longitude,
  //     );

  //     String address = "Unknown Address";
  //     String state = "Unknown State";

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       address = "${place.street}, ${place.locality}, ${place.postalCode}";
  //       state = place.administrativeArea ?? "Unknown";
  //     }

  //     setState(() {
  //       _userLocation = currentLatLng;
  //       _userAddress = address;
  //       _userState = state;

  //       _markers.add(
  //         Marker(
  //           markerId: const MarkerId('user_location'),
  //           position: currentLatLng,
  //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  //           onTap: () => _showUserInfo(),
  //         ),
  //       );

  //       _polylines.add(
  //         Polyline(
  //           polylineId: const PolylineId('user_route'),
  //           points: [_staticLocation, currentLatLng],
  //           color: Colors.orange,

  //           width: 3,
  //         ),
  //       );

  //       mapController.animateCamera(
  //         CameraUpdate.newLatLngZoom(currentLatLng, 7),
  //       );
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Location permission denied")),
  //     );
  //   }
  // }

// Via HTTP method

 String googleApiKey = 'AIzaSyD6pymvEp2UukkpredtDxBf1YdIfjBgOHI';
 

Future<void> _getUserLocation() async {
  // Check and request permission
  PermissionStatus status = await Permission.location.status;

  if (status.isDenied || status.isRestricted) {
    status = await Permission.location.request();
  }

  if (status.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Permission permanently denied. Please enable it in settings.")),
    );
    await openAppSettings(); // Opens app settings
    return;
  }

  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location permission denied")),
    );
    return;
  }

  // Check if location services (GPS) are enabled
  bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enable GPS/location services")),
    );
    await Geolocator.openLocationSettings(); // Prompt user to turn on GPS
    return;
  }

  // Get current location
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  LatLng currentLatLng = LatLng(position.latitude, position.longitude);

  // Reverse Geocoding with Google API
  try {
    final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      String address = "Unknown Address";
      String state = "Unknown State";

      if (results.isNotEmpty) {
        address = results[0]['formatted_address'];

        // Extract state from components
        for (var component in results[0]['address_components']) {
          if (component['types'].contains('administrative_area_level_1')) {
            state = component['long_name'];
            break;
          }
        }
      }

      setState(() {
        _userLocation = currentLatLng;
        _userAddress = address;
        _userState = state;

        _markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: currentLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onTap: () => _showUserInfo(),
          ),
        );

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('user_route'),
            points: [_staticLocation, currentLatLng],
            color: Colors.orange,
            width: 3,
          ),
        );

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 7),
        );
      });
    } else {
      throw Exception("Google API error: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Reverse geocoding failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to get address from coordinates.")),
    );
  }
}


  void _showUserInfo() {
    if (_userLocation == null) return;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Current Location", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/684/684908.png',
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(height: 10),
              Text("State: $_userState"),
              const SizedBox(height: 5),
              Text("Address: $_userAddress", textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _staticLocation.latitude < _desiredLocation.latitude ? _staticLocation.latitude : _desiredLocation.latitude,
            _staticLocation.longitude < _desiredLocation.longitude ? _staticLocation.longitude : _desiredLocation.longitude,
          ),
          northeast: LatLng(
            _staticLocation.latitude > _desiredLocation.latitude ? _staticLocation.latitude : _desiredLocation.latitude,
            _staticLocation.longitude > _desiredLocation.longitude ? _staticLocation.longitude : _desiredLocation.longitude,
          ),
        ),
        100.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Task')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _desiredLocation,
          zoom: 5.0,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
*/