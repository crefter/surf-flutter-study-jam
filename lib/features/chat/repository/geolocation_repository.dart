import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surf_practice_chat_flutter/features/chat/exceptions/geolocation_exception.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_geolocation_geolocation_dto.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class IGeolocationRepository {
  Future<ChatGeolocationDto> getDevicePosition();

  Future<bool> checkPermission();

  Future<void> openMap(ChatGeolocationDto chatGeolocationDto);
}

class GeolocationRepository implements IGeolocationRepository {
  static const url = 'https://www.google.com/maps/search/?api=1&query=';

  @override
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw GeolocationException('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
    }

    if (permission == LocationPermission.denied) {
      await Permission.location.request();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        throw GeolocationException('Location permissions are denied');
      }
    }
    return true;
  }

  @override
  Future<ChatGeolocationDto> getDevicePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return ChatGeolocationDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<void> openMap(ChatGeolocationDto chatGeolocationDto) async {
    final uri = Uri.parse(
        "$url${chatGeolocationDto.latitude},${chatGeolocationDto.longitude}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw GeolocationException('Cannot open map');
    }
  }
}
