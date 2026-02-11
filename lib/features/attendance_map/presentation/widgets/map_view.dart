import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendanceMapView extends StatelessWidget {
  final MapController mapController;
  final LatLng? currentLocation;
  final bool isWithinRadius;
  final VoidCallback? onMapReady;

  const AttendanceMapView({
    super.key,
    required this.mapController,
    this.currentLocation,
    required this.isWithinRadius,
    this.onMapReady,
  });

  static final LatLng _officeLocation = LatLng(
    CheckIn.officeLat,
    CheckIn.officeLong,
  );

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _officeLocation,
        initialZoom: 16,
        maxZoom: 19,
        onMapReady: onMapReady,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.hrconnect.app',
          maxNativeZoom: 19,
          retinaMode: RetinaMode.isHighDensity(context),
        ),
        // Office radius circle
        CircleLayer(
          circles: [
            CircleMarker(
              point: _officeLocation,
              radius: CheckIn.maxDistanceInMeters,
              useRadiusInMeter: true,
              color: AppColors.primary.withValues(alpha: 0.06),
              borderColor: AppColors.primary.withValues(alpha: 0.25),
              borderStrokeWidth: 2,
            ),
          ],
        ),
        // Markers with labels
        MarkerLayer(
          markers: [
            // Office marker: icon pinned to coordinate center, label below
            Marker(
              point: _officeLocation,
              width: 120,
              height: 56,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.business,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.xsRadius,
                      boxShadow: AppShadows.small,
                    ),
                    child: Text(
                      'HQ Office',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // User location marker: dot pinned to coordinate center, label above
            if (currentLocation != null)
              Marker(
                point: currentLocation!,
                width: 120,
                height: 70,
                alignment: Alignment.center,
                child: _UserLocationMarkerWithLabel(
                  isWithinRadius: isWithinRadius,
                ),
              ),
          ],
        ),
        // OSM attribution
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}

class _UserLocationMarkerWithLabel extends StatelessWidget {
  final bool isWithinRadius;

  const _UserLocationMarkerWithLabel({required this.isWithinRadius});

  @override
  Widget build(BuildContext context) {
    final color = isWithinRadius ? AppColors.primary : AppColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.xsRadius,
            boxShadow: AppShadows.small,
          ),
          child: Text(
            'You are here',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
