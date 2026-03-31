import 'package:dio/dio.dart';
import '../models/route_model.dart';
import '../../config/constants.dart';

class RouteRepository {
  final Dio _dio;

  RouteRepository()
      : _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.orsBaseUrl,
      headers: {
        'Authorization': AppConstants.orsApiKey,
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<RouteModel> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required String startAddress,
    required String endAddress,
  }) async {
    try {
      final response = await _dio.post(
        '/v2/directions/driving-car/geojson',
        data: {
          'coordinates': [
            [startLng, startLat], // ORS uses [lng, lat] order
            [endLng, endLat],
          ],
          // 'language': 'en',
        },
      );

      final feature = response.data['features'][0];
      final properties = feature['properties'];

      // Combine geometry with other data for fromJson
      final routeData = <String, dynamic>{
        ...Map<String, dynamic>.from(properties),
        'geometry': feature['geometry'],
        'startAddress': startAddress,
        'endAddress': endAddress,
        'startLat': startLat,
        'startLng': startLng,
        'endLat': endLat,
        'endLng': endLng,
      };

      return RouteModel.fromJson(routeData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error']?['message'] ?? 'Failed to get route',
      );
    }
  }
}
