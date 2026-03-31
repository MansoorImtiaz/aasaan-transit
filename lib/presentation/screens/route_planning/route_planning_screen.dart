import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../config/theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../presentation/blocs/route_planning/route_planning_bloc.dart';
import '../../../presentation/blocs/route_planning/route_planning_event.dart';
import '../../../presentation/blocs/route_planning/route_planning_state.dart';

class RoutePlanningScreen extends StatefulWidget {
  const RoutePlanningScreen({super.key});

  @override
  State<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends State<RoutePlanningScreen> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  // Sample coordinates for demo
  final Map<String, List<double>> _sampleLocations = {
    'Islamabad City Center': [33.7294, 73.0931],
    'Rawalpindi Station': [33.5988, 73.0432],
    'F-10 Markaz': [33.6938, 73.0197],
    'Blue Area': [33.7215, 73.0638],
    'Centaurus Mall': [33.7070, 73.0480],
  };

  String? _selectedStart;
  String? _selectedEnd;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _searchRoute() {
    if (_selectedStart == null || _selectedEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end locations')),
      );
      return;
    }

    final start = _sampleLocations[_selectedStart!]!;
    final end = _sampleLocations[_selectedEnd!]!;

    context.read<RoutePlanningBloc>().add(
      SearchRoute(
        startLat: start[0],
        startLng: start[1],
        endLat: end[0],
        endLng: end[1],
        startAddress: _selectedStart!,
        endAddress: _selectedEnd!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Route'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _selectedStart = null;
                _selectedEnd = null;
              });
              context.read<RoutePlanningBloc>().add(const ClearRoute());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Start dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'From',
                    prefixIcon: Icon(Icons.trip_origin, color: AppTheme.accentColor),
                  ),
                  value: _selectedStart,
                  items: _sampleLocations.keys
                      .map((loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedStart = value),
                ),

                const SizedBox(height: 12),

                // End dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'To',
                    prefixIcon: Icon(Icons.location_on, color: AppTheme.errorColor),
                  ),
                  value: _selectedEnd,
                  items: _sampleLocations.keys
                      .map((loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedEnd = value),
                ),

                const SizedBox(height: 12),

                // Search button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _searchRoute,
                    icon: const Icon(Icons.search),
                    label: const Text('Find Route'),
                  ),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: BlocBuilder<RoutePlanningBloc, RoutePlanningState>(
              builder: (context, state) {
                if (state is RoutePlanningLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RoutePlanningError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppTheme.errorColor),
                        const SizedBox(height: 16),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _searchRoute,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RoutePlanningLoaded) {
                  final route = state.route;
                  return Column(
                    children: [
                      // Map with route
                      SizedBox(
                        height: 220,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              route.startLat,
                              route.startLng,
                            ),
                            initialZoom: 12.0,
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
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: route.polylinePoints
                                      .map((p) => LatLng(p[0], p[1]))
                                      .toList(),
                                  color: AppTheme.primaryColor,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(route.startLat, route.startLng),
                                  child: const Icon(Icons.trip_origin,
                                      color: AppTheme.accentColor, size: 28),
                                ),
                                Marker(
                                  point: LatLng(route.endLat, route.endLng),
                                  child: const Icon(Icons.location_on,
                                      color: AppTheme.errorColor, size: 28),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Route summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AppTheme.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(
                              icon: Icons.straighten,
                              label: 'Distance',
                              value:
                              '${route.distanceKm.toStringAsFixed(1)} km',
                            ),
                            _SummaryItem(
                              icon: Icons.timer,
                              label: 'Duration',
                              value: '${route.durationMinutes} min',
                            ),
                            _SummaryItem(
                              icon: Icons.format_list_numbered,
                              label: 'Steps',
                              value: '${route.steps.length}',
                            ),
                          ],
                        ),
                      ),

                      // Step by step instructions
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: route.steps.length,
                          itemBuilder: (context, index) {
                            final step = route.steps[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primaryColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(step.instruction),
                              subtitle: Text(
                                AppHelpers.formatDistance(step.distanceMeters),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // Initial state
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.route, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Select locations to plan your route',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}