import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/core/utils/date_formatter.dart';
import 'package:hr_connect/core/utils/shimmering.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_states.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/activity_history_list.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/attendance_metrics.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/calendar_strip.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/check_in_card.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance.dart';
import '../../domain/usecases/check_in.dart'; // For constants

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
    final attendanceState = ref.watch(attendanceProvider);
    final authState = ref.watch(authProvider);

    final userName = switch (authState) {
      AuthLoaded(:final employee) => employee.fullName,
      _ => 'Employee',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          _getCurrentLocation();
          ref.read(attendanceProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Good Morning, $userName.',
                style: AppTypography.displaySmall,
              ),
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

              // Check In/Out Card - using switch pattern for sealed class
              _buildCheckInCard(attendanceState),
              const SizedBox(height: 24),

              // Metrics
              const AttendanceMetrics(),
              const SizedBox(height: 24),

              // History
              const ActivityHistoryList(),

              // Error display
              if (attendanceState is AttendanceError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    attendanceState.message,
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

  Widget _buildCheckInCard(AttendanceState state) {
    return switch (state) {
      AttendanceLoading() => const CheckInCardShimmer(),
      AttendanceLoaded(:final todayAttendance) => _buildCheckInCardContent(
        todayAttendance,
      ),
      AttendanceError(:final message) => Center(
        child: Column(
          children: [
            Text('Error: $message', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.read(attendanceProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildCheckInCardContent(Attendance? attendance) {
    final isCheckedIn = attendance != null && attendance.checkOut == null;
    final isLoading = _isLoadingLocation;

    return CheckInCard(
      isLoading: isLoading,
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          : (_isLoadingLocation
                ? const SkeletonShimmer(width: 48, height: 48, borderRadius: 12)
                : null),
      onCheckIn: () {
        if (_currentLocation == null) return;

        if (!isCheckedIn) {
          ref
              .read(attendanceProvider.notifier)
              .checkIn(
                employeeId: Supabase.instance.client.auth.currentUser!.id,
                locationType: LocationType.wfo,
                lat: _currentLocation!.latitude,
                long: _currentLocation!.longitude,
              );
        } else {
          ref.read(attendanceProvider.notifier).checkOut(attendance.id);
        }
      },
    );
  }

  Widget _buildInfoColumn(String label, DateTime time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          DateFormatter.formatTime(time),
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
