import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/business_logic/google_map/google_map_cubit.dart';
import 'package:tracking_app/business_logic/google_map/google_map_states.dart';
import 'package:tracking_app/views/routes/zoom_buttons.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  late final GoogleMapCubit _googleMapCubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _googleMapCubit = GoogleMapCubit.get(context);
    _googleMapCubit.markers.clear();
    _googleMapCubit.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Routes',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _googleMapCubit.placeDestinationLocationMarker(
              latLng: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['longitude'],
              ),
            );
            return BlocConsumer<GoogleMapCubit, GoogleMapStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return Stack(
                  children: [
                    GoogleMap(
                      markers: Set<Marker>.from(
                        _googleMapCubit.markers,
                      ),
                      initialCameraPosition: _googleMapCubit.initialLocation,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        _googleMapCubit.mapController = controller;
                        _googleMapCubit.getCurrentLocation();
                      },
                      onTap: (latLng) {

                      },
                      polylines: Set<Polyline>.of(
                        _googleMapCubit.polyLines.values,
                      ),
                      myLocationButtonEnabled: false,
                    ),
                    const ZoomButtons(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
