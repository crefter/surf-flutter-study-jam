import 'package:surf_study_jam/surf_study_jam.dart';

/// Data transfer object representing geolocation point.
class ChatGeolocationDto {
  /// Latitude, in degrees.
  final double latitude;

  /// Longitude, in degrees.
  final double longitude;

  /// Constructor for [ChatGeolocationDto].
  ChatGeolocationDto({
    required this.latitude,
    required this.longitude,
  });

  factory ChatGeolocationDto.empty() => ChatGeolocationDto(latitude: 0, longitude: 0);

  /// Named constructor for converting DTO from [StudyJamClient].
  ChatGeolocationDto.fromGeoPoint(List<double> geopoint)
      : latitude = geopoint[0],
        longitude = geopoint[1];
  @override
  String toString() => 'ChatGeolocationDto(latitude: $latitude, longitude: $longitude)';

  /// Transforms dto to `List`.
  List<double> toGeopoint() => [latitude, longitude];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatGeolocationDto &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
