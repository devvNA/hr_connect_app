import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/activity_history_list.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/attendance_metrics.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/calendar_strip.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/check_in_card.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance.dart';
import '../../domain/usecases/check_in.dart'; // For constants
import '../providers/attendance_controller.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoadingLocation = true;
  String? _locationError;
  bool _isWithinRadius = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      // Calculate distance to office
      final distance = Geolocator.distanceBetween(
        CheckIn.officeLat,
        CheckIn.officeLong,
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLocation = latLng;
        _isLoadingLocation = false;
        _isWithinRadius = distance <= CheckIn.maxDistanceInMeters;
        _locationError = null;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayState = ref.watch(todayAttendanceProvider);
    final historyState = ref.watch(monthlyAttendanceProvider(DateTime.now()));
    final controllerState = ref.watch(attendanceControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          _getCurrentLocation();
          ref.invalidate(todayAttendanceProvider);
          ref.invalidate(monthlyAttendanceProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text('Good Morning, Alex.', style: AppTypography.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Ready for another productive day?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Calendar Strip
              const CalendarStrip(),
              const SizedBox(height: AppSpacing.xxl),

              // Check In/Out Card
              todayState.when(
                data: (attendance) {
                  final isCheckedIn =
                      attendance != null && attendance.checkOut == null;
                  return CheckInCard(
                    isLoading: controllerState.isLoading || _isLoadingLocation,
                    isCheckedIn: isCheckedIn,
                    checkInTime: attendance?.checkIn,
                    mapWidget: (_currentLocation != null && !_isLoadingLocation)
                        ? FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _currentLocation!,
                              initialZoom: 15,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none, // Static map
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.hr_connect',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _currentLocation!,
                                    width: 24,
                                    height: 24,
                                    child: const Icon(
                                      Icons.person_pin_circle,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null,
                    onCheckIn: () {
                      if (_currentLocation == null) return;

                      if (!isCheckedIn) {
                        ref
                            .read(attendanceControllerProvider.notifier)
                            .checkIn(
                              employeeId:
                                  Supabase.instance.client.auth.currentUser!.id,
                              locationType: LocationType.wfo,
                              lat: _currentLocation!.latitude,
                              long: _currentLocation!.longitude,
                            );
                      } else {
                        ref
                            .read(attendanceControllerProvider.notifier)
                            .checkOut(attendance.id);
                      }
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 24),

              // Metrics
              const AttendanceMetrics(),
              const SizedBox(height: 24),

              // History
              const ActivityHistoryList(),

              if (controllerState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    controllerState.error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, DateTime time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          DateFormat('HH:mm').format(time),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus? status) {
    switch (status) {
      case AttendanceStatus.onTime:
        return Colors.green.shade100;
      case AttendanceStatus.late:
        return Colors.red.shade100;
      case AttendanceStatus.earlyLeave:
        return Colors.orange.shade100;
      case AttendanceStatus.absent:
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

class DataLoader extends StatelessWidget {
  const DataLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    );
  }
}
