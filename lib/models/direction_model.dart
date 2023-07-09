import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionModel {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  late String distance;
  late String duration;

  DirectionModel({
    required this.bounds,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    final boundsData = LatLngBounds(
        northeast: LatLng(json['bounds']['northeast']['lat'],
            json['bounds']['northeast']['lng']),
        southwest: LatLng(json['bounds']['southwest']['lat'],
            json['bounds']['southwest']['lng']));

    late String distance;
    late String duration;

    if ((json['legs'] as List).isNotEmpty) {
      distance = json['legs'][0]['distance']['text'];
      duration = json['legs'][0]['duration']['text'];
    }

    return DirectionModel(
      bounds: boundsData,
      polylinePoints:
          PolylinePoints().decodePolyline(json['overview_polyline']['points']),
      distance: distance,
      duration: duration,
    );
  }
}
