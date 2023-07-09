import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app/business_logic/google_map/google_map_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:tracking_app/models/direction_model.dart';

class GoogleMapCubit extends Cubit<GoogleMapStates> {
  GoogleMapCubit() : super(const GoogleMapInitialState());

  static GoogleMapCubit get(context, {bool listen = false}) => BlocProvider.of(
        context,
        listen: listen,
      );
  final loc.Location location = loc.Location();

  final CameraPosition initialLocation = const CameraPosition(
    target: LatLng(
      30.033333,
      31.233334,
    ),
  );
  late GoogleMapController mapController;
  late Placemark currentLocation;
  late Placemark destLocation;
  late LatLng currentLatLng;
  late LatLng destinationLatLng;
  late Placemark untranslatedPlace;

  final startAddressFocusNode = FocusNode();
  Set<Marker> markers = {};

  Future<void> getCurrentLocation() async {
    emit(const GetCurrentLocationLoadingState());
    await requestLocationPermission();
    final loc.LocationData locationResult = await location.getLocation();
    currentLatLng = LatLng(
      locationResult.latitude ?? 0.0,
      locationResult.longitude ?? 0.0,
    );
    placeCurrentLocationMarker();
    emit(const GetCurrentLocationSuccessState());
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
      requestLocationPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> placeCurrentLocationMarker() async {
    try {
      List<Placemark> translatedPlaceMarks = await placemarkFromCoordinates(
        currentLatLng.latitude,
        currentLatLng.longitude,
        localeIdentifier: 'en_EG',
      );
      currentLocation = translatedPlaceMarks[0];
      List<Placemark> p = await placemarkFromCoordinates(
        currentLatLng.latitude,
        currentLatLng.longitude,
      );
      untranslatedPlace = p[0];
      Marker yourMarker = Marker(
        markerId: const MarkerId('you'),
        position: currentLatLng,
        infoWindow: const InfoWindow(title: 'You', snippet: 'You'),
        icon: BitmapDescriptor.defaultMarker,
      );
      // Adding the markers to the list
      markers.add(yourMarker);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLatLng,
            zoom: 1.0,
          ),
        ),
      );
      emit(PlaceCurrentLocationMarkerState());
    } catch (error) {
      debugPrint(
        error.toString(),
      );
    }
  }

  Future<void> placeDestinationLocationMarker({
    required LatLng latLng,
  }) async {
    List<Placemark> translatedPlaceMarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
      localeIdentifier: 'en_EG',
    );
    destLocation = translatedPlaceMarks[0];
    Marker yourMarker = Marker(
      markerId: const MarkerId('Destination'),
      position: latLng,
      infoWindow: const InfoWindow(
        title: 'Destination',
        snippet: 'Destination',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );
    markers.add(yourMarker);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 18.0,
        ),
      ),
    );
    await getPolyline(
      destination: latLng,
    );
    emit(
      PlaceDestinationLocationMarker(),
    );
  }

  final String key = 'AIzaSyCMToNrGNSEcCt2Pm41xaJ7wLVbc58JhkA';
  late DirectionModel? directionModel;
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polyLines[id] = polyline;
    emit(DrawPolyLineState());
  }

  Future<void> getPolyline({required LatLng destination}) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      key,
      PointLatLng(destination.latitude, destination.longitude),
      PointLatLng(currentLatLng.latitude, currentLatLng.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
    }
    addPolyLine(polylineCoordinates);
    emit(GetPolyLineState());
  }
}
