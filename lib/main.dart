import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/business_logic/google_map/google_map_cubit.dart';
import 'package:tracking_app/views/tracking/live_location_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GoogleMapCubit>(
          create: (_) => GoogleMapCubit(),
        ),
      ],
      child: const MaterialApp(
        home: LiveLocationTracker(),
      ),
    );
  }
}
