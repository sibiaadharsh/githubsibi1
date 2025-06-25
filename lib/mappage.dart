import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _desiredLocation = const LatLng(12.9716, 77.5946); // Bangalore
  final LatLng _staticLocation = const LatLng(28.6139, 77.2090); // Delhi
  final LatLng _shopLocation = const LatLng(23.0225, 72.5714); // Ahmedabad

  LatLng? _userLocation;
  String? _userAddress;
  String? _userState;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String googleApiKey = 'AIzaSyD6pymvEp2UukkpredtDxBf1YdIfjBgOHI'; // Replace with your actual API key

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
        infoWindow: const InfoWindow(
          title: 'Bangalore',
          snippet: 'Electronic Capital of India',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId('delhi'),
        position: _staticLocation,
        infoWindow: const InfoWindow(
          title: 'Delhi',
          snippet: 'Capital of India',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('inb_ahmedabad'),
        position: _shopLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'INB Ahmedabad',
          snippet: 'Prem Darwaja - Tap for details',
          onTap: () {
            _showShopInfo(); // This will show your custom dialog when the info window is tapped
          },
        ),
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

  Future<void> _getUserLocation() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission permanently denied. Please enable it in settings.")),
      );
      await openAppSettings();
      return;
    }

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable GPS/location services")),
      );
      await Geolocator.openLocationSettings();
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

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
void _showShopInfo() {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color.fromARGB(0, 210, 156, 156),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Add this line
            children: [
              // Top image of shop
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/shop.jpg',
                  width: double.infinity,
                  height: 120,
                  
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space out the children
                children: [
                  const Text(
                    "INB Ahmedabad",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton( // Using IconButton for a cleaner look if no text is needed for the button
                    icon: const Icon(Icons.directions),
                    onPressed: () => Navigator.pop(context), // You might want to change this action
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Prem Darwaja, Ahmedabad",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                "Retail Shop",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_forward),
                label: Text("View Product"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
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
            _staticLocation.latitude < _desiredLocation.latitude
                ? _staticLocation.latitude
                : _desiredLocation.latitude,
            _staticLocation.longitude < _desiredLocation.longitude
                ? _staticLocation.longitude
                : _desiredLocation.longitude,
          ),
          northeast: LatLng(
            _staticLocation.latitude > _desiredLocation.latitude
                ? _staticLocation.latitude
                : _desiredLocation.latitude,
            _staticLocation.longitude > _desiredLocation.longitude
                ? _staticLocation.longitude
                : _desiredLocation.longitude,
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
