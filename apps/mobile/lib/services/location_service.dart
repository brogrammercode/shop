import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile/utils/error.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final String? street;
  final String? locality;
  final String? city;
  final String? state;
  final String? country;
  final String? pinCode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.street,
    this.locality,
    this.city,
    this.state,
    this.country,
    this.pinCode,
  });
}

class LocationService {
  Future<Either<Failure, LocationModel>> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the 
        // App to enable the location services.
        // Opening location settings might be needed.
        await Geolocator.openLocationSettings();
        // Check again after opening
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return const Left(ValidationFailure('Location services are disabled. Please enable them to continue.'));
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(ValidationFailure('Location permissions are denied.'));
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return const Left(ValidationFailure('Location permissions are permanently denied, we cannot request permissions.'));
      } 

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = [];
      try {
        placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      } catch (e) {
        // Ignore reverse geocoding errors, we at least have lat/lng
      }

      String? street;
      String? locality;
      String? city;
      String? state;
      String? country;
      String? pinCode;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String originalStreet = place.street ?? '';
        String originalCity = place.locality ?? '';
        
        if (originalStreet.isNotEmpty && originalCity.isNotEmpty) {
          street = '$originalStreet, $originalCity';
        } else if (originalStreet.isNotEmpty) {
          street = originalStreet;
        } else if (originalCity.isNotEmpty) {
          street = originalCity;
        }

        locality = place.subLocality;
        
        String rawCity = (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) 
            ? place.subAdministrativeArea! 
            : (place.locality ?? '');
        city = rawCity.replaceAll(RegExp(r'\bdivision\b', caseSensitive: false), '').trim();
        if (city.isEmpty) city = null;

        state = place.administrativeArea;
        country = place.country;
        pinCode = place.postalCode;
      }

      return Right(LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        street: street,
        locality: locality,
        city: city,
        state: state,
        country: country,
        pinCode: pinCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
