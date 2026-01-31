import 'package:flutter_riverpod/legacy.dart';

/// Enum representing navigation destinations
enum NavigationDestination {
  dashboard,
  employees,
  attendance,
  leaveRequests,
  approvals,
  settings,
  profile,
}

/// Extension for route names
extension NavigationDestinationX on NavigationDestination {
  String get routeName {
    switch (this) {
      case NavigationDestination.dashboard:
        return 'dashboard';
      case NavigationDestination.employees:
        return 'employees';
      case NavigationDestination.attendance:
        return 'attendance';
      case NavigationDestination.leaveRequests:
        return 'leave-requests';
      case NavigationDestination.approvals:
        return 'approvals';
      case NavigationDestination.settings:
        return 'settings';
      case NavigationDestination.profile:
        return 'profile';
    }
  }

  String get path => '/$routeName';

  /// Display title for AppBar
  String get displayTitle {
    switch (this) {
      case NavigationDestination.dashboard:
        return 'Connect';
      case NavigationDestination.employees:
        return 'Employees';
      case NavigationDestination.attendance:
        return 'Attendance';
      case NavigationDestination.leaveRequests:
        return 'Leave Requests';
      case NavigationDestination.approvals:
        return 'Approvals';
      case NavigationDestination.settings:
        return 'Settings';
      case NavigationDestination.profile:
        return 'My Profile';
    }
  }
}

/// Provider for current navigation destination
final navigationProvider = StateProvider<NavigationDestination>(
  (ref) => NavigationDestination.dashboard,
);
