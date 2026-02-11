import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_in.dart';
import 'package:hr_connect/features/attendance_map/presentation/providers/attendance_map_providers.dart';
import 'package:hr_connect/features/attendance_map/presentation/providers/attendance_map_states.dart';
import 'package:hr_connect/features/attendance_map/presentation/widgets/location_info_card.dart';
import 'package:hr_connect/features/attendance_map/presentation/widgets/map_view.dart';
import 'package:latlong2/latlong.dart';

enum AttendanceMapMode { checkIn, checkOut }

class AttendanceMapScreen extends ConsumerStatefulWidget {
  final AttendanceMapMode mode;
  final String? attendanceId;

  const AttendanceMapScreen({
    super.key,
    this.mode = AttendanceMapMode.checkIn,
    this.attendanceId,
  });

  @override
  ConsumerState<AttendanceMapScreen> createState() =>
      _AttendanceMapScreenState();
}

class _AttendanceMapScreenState extends ConsumerState<AttendanceMapScreen> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  bool get _isCheckIn => widget.mode == AttendanceMapMode.checkIn;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(attendanceMapProvider);

    // Listen for success -> pop back
    ref.listen(attendanceMapProvider, (prev, next) {
      if (next is AttendanceMapSuccess) {
        context.pop(true);
      }
      if (next is AttendanceMapError && next.source == 'confirm') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
      // Fit map to show both office and user when location is fetched
      if (next is AttendanceMapLocated && _mapReady) {
        try {
          final officeLocation = LatLng(CheckIn.officeLat, CheckIn.officeLong);
          final bounds = LatLngBounds.fromPoints([
            officeLocation,
            next.currentLocation,
          ]);
          _mapController.fitCamera(
            CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(60),
            ),
          );
        } catch (_) {}
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(mapState),
            Expanded(
              child: switch (mapState) {
                AttendanceMapLoading() ||
                AttendanceMapInitial() => _buildLoadingState(),
                AttendanceMapLocated() => _buildMapContent(mapState),
                AttendanceMapError(:final message) => _buildErrorState(message),
                AttendanceMapSuccess() => _buildLoadingState(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AttendanceMapState mapState) {
    final isLoading = mapState is AttendanceMapLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            borderRadius: AppRadius.fullRadius,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.fullRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.my_location,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Location Check',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: isLoading
                ? null
                : () => ref
                      .read(attendanceMapProvider.notifier)
                      .refreshLocation(),
            borderRadius: AppRadius.fullRadius,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.refresh,
                color: isLoading ? AppColors.textLight : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent(AttendanceMapLocated state) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: AttendanceMapView(
            mapController: _mapController,
            currentLocation: state.currentLocation,
            isWithinRadius: state.isWithinRadius,
            onMapReady: () => _mapReady = true,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: LocationInfoCard(
            isWithinRadius: state.isWithinRadius,
            distanceToOffice: state.distanceToOffice,
            onNavigate: () {
              try {
                final officeLocation =
                    LatLng(CheckIn.officeLat, CheckIn.officeLong);
                final bounds = LatLngBounds.fromPoints([
                  officeLocation,
                  state.currentLocation,
                ]);
                _mapController.fitCamera(
                  CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(60),
                  ),
                );
              } catch (_) {}
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: _buildConfirmButton(state),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            _isCheckIn
                ? 'Please ensure you are within the office premises.'
                : 'Please confirm your location to check out.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildConfirmButton(AttendanceMapLocated state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isProcessing
            ? null
            : () {
                final notifier = ref.read(attendanceMapProvider.notifier);
                if (_isCheckIn) {
                  notifier.confirmCheckIn();
                } else {
                  notifier.confirmCheckOut(widget.attendanceId!);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
          elevation: 0,
        ),
        child: state.isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                _isCheckIn ? 'Confirm & Check-In' : 'Confirm & Check-Out',
                style: AppTypography.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Getting your location...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Unable to Get Location',
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(attendanceMapProvider.notifier).refreshLocation(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
