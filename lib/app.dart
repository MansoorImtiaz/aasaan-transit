import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'data/repositories/transit_repository.dart';
import 'data/repositories/route_repository.dart';
import 'presentation/blocs/nearby_stops/nearby_stops_bloc.dart';
import 'presentation/blocs/route_planning/route_planning_bloc.dart';
import 'presentation/blocs/transit/transit_bloc.dart';
import 'presentation/blocs/notifications/notification_bloc.dart';

class AasaanTransitApp extends StatelessWidget {
  final NotificationService notificationService;

  const AasaanTransitApp({
    super.key,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TransitRepository()),
        RepositoryProvider(create: (_) => RouteRepository()),
        RepositoryProvider(create: (_) => LocationService()),
        RepositoryProvider(create: (_) => notificationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NearbyStopsBloc(
              transitRepository: context.read<TransitRepository>(),
              locationService: context.read<LocationService>(),
            ),
          ),
          BlocProvider(
            create: (context) => RoutePlanningBloc(
              routeRepository: context.read<RouteRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TransitBloc(
              transitRepository: context.read<TransitRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              transitRepository: context.read<TransitRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'AasaanTransit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}