import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/business_logic/google_map/google_map_cubit.dart';

class ZoomButtons extends StatelessWidget {
  const ZoomButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    GoogleMapCubit.get(context).mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.remove),
                  ),
                  onTap: () {
                    GoogleMapCubit.get(context).mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
