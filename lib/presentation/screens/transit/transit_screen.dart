import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme.dart';
import '../../../presentation/blocs/transit/transit_bloc.dart';
import '../../../presentation/blocs/transit/transit_event.dart';
import '../../../presentation/blocs/transit/transit_state.dart';

class TransitScreen extends StatefulWidget {
  const TransitScreen({super.key});

  @override
  State<TransitScreen> createState() => _TransitScreenState();
}

class _TransitScreenState extends State<TransitScreen> {
  final List<Map<String, String>> _sampleStops = [
    {'id': 's1', 'name': 'City Center Bus Stop'},
    {'id': 's2', 'name': 'Metro Station'},
    {'id': 's3', 'name': 'Railway Station'},
    {'id': 's4', 'name': 'Airport Bus Terminal'},
    {'id': 's5', 'name': 'University Stop'},
  ];

  String? _selectedStopId;
  String? _selectedStopName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Schedule'),
        actions: [
          if (_selectedStopId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context
                  .read<TransitBloc>()
                  .add(RefreshTransitSchedule(_selectedStopId!)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Stop selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Stop',
                prefixIcon: Icon(Icons.location_on),
              ),
              value: _selectedStopId,
              items: _sampleStops
                  .map((stop) => DropdownMenuItem(
                value: stop['id'],
                child: Text(stop['name']!),
              ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedStopId = value;
                  _selectedStopName = _sampleStops
                      .firstWhere((s) => s['id'] == value)['name'];
                });
                context
                    .read<TransitBloc>()
                    .add(LoadTransitSchedule(value));
              },
            ),
          ),

          // Schedule results
          Expanded(
            child: BlocBuilder<TransitBloc, TransitState>(
              builder: (context, state) {
                if (state is TransitLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransitError) {
                  return Center(child: Text(state.message));
                }

                if (state is TransitLoaded) {
                  return Column(
                    children: [
                      // Stop header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: AppTheme.primaryColor.withOpacity(0.05),
                        child: Text(
                          _selectedStopName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),

                      // Arrivals list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.arrivals.length,
                          itemBuilder: (context, index) {
                            final arrival = state.arrivals[index];
                            final isDelayed = arrival['status'] == 'delayed';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Line badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        arrival['line'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Arrival info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'In ${arrival['arrivalMinutes'].toString()} minutes',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (isDelayed)
                                            Text(
                                              'Delayed by ${arrival['delayMinutes']} min',
                                              style: const TextStyle(
                                                color: AppTheme.errorColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Status badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDelayed
                                            ? AppTheme.errorColor.withValues(alpha: 0.1)
                                            : AppTheme.accentColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isDelayed ? 'Delayed' : 'On Time',
                                        style: TextStyle(
                                          color: isDelayed
                                              ? AppTheme.errorColor
                                              : AppTheme.accentColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Select a stop to see live arrivals',
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