abstract class GoogleMapStates {
  const GoogleMapStates();
}

class GoogleMapInitialState extends GoogleMapStates {
  const GoogleMapInitialState();
}

class GetCurrentLocationLoadingState extends GoogleMapStates {
  const GetCurrentLocationLoadingState();
}

class GetCurrentLocationSuccessState extends GoogleMapStates {
  const GetCurrentLocationSuccessState();
}
class PlaceCurrentLocationMarkerState extends GoogleMapStates{

}class PlaceDestinationLocationMarker extends GoogleMapStates{

}
class DrawPolyLineState extends GoogleMapStates{

}class GetPolyLineState extends GoogleMapStates{

}