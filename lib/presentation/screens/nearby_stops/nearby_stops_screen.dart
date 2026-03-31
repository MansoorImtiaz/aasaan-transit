import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../config/theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/stop_model.dart';
import '../../../presentation/blocs/nearby_stops/nearby_stops_bloc.dart';
import '../../../presentation/blocs/nearby_stops/nearby_stops_event.dart';
import '../../../presentation/blocs/nearby_stops/nearby_stops_state.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen> {
  @override
  void initState() {
    super.initState();
    // Load stops when screen opens
    context.read<NearbyStopsBloc>().add(const LoadNearbyStops());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<NearbyStopsBloc>()
                .add(const RefreshNearbyStops()),
          ),
        ],
      ),
      body: BlocBuilder<NearbyStopsBloc, NearbyStopsState>(
        builder: (context, state) {
          if (state is NearbyStopsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NearbyStopsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<NearbyStopsBloc>()
                        .add(const LoadNearbyStops()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is NearbyStopsLoaded) {
            return Column(
              children: [
                // Map Section
                SizedBox(
                  height: 300,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(state.userLat, state.userLng),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                        userAgentPackageName: 'com.example.aasaan_transit',
                        additionalOptions: const {
                          'User-Agent': 'AasaanTransit/1.0 (com.example.aasaan_transit)',
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          // User location marker
                          Marker(
                            point: LatLng(state.userLat, state.userLng),
                            child: const Icon(
                              Icons.my_location,
                              color: AppTheme.accentColor,
                              size: 32,
                            ),
                          ),
                          // Stop markers
                          ...state.stops.map(
                                (stop) => Marker(
                              point: LatLng(stop.latitude, stop.longitude),
                              child: Icon(
                                Icons.location_on,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Stops List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.stops.length,
                    itemBuilder: (context, index) {
                      final stop = state.stops[index];
                      return _StopCard(stop: stop);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StopCard extends StatelessWidget {
  final StopModel stop;

  const _StopCard({required this.stop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Stop type icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  AppHelpers.getStopTypeIcon(stop.stopType),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Stop info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: stop.transitLines
                        .map(
                          (line) => Chip(
                        label: Text(
                          line,
                          style: const TextStyle(fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor:
                        AppTheme.accentColor.withValues(alpha: 0.1),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}