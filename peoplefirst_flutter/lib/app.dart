import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/persona_provider.dart';
import 'shared/widgets/pf_bottom_nav.dart';
import 'shared/widgets/toast_overlay.dart';
import 'shared/screens/more_screen.dart';
import 'features/leader/home/leader_home_screen.dart';
import 'features/leader/approvals/approvals_screen.dart';
import 'features/leader/team/team_screen.dart';
import 'features/leader/reports/reports_screen.dart';
import 'features/employee/home/employee_home_screen.dart';
import 'features/employee/tasks/tasks_screen.dart';
import 'features/employee/attendance/attendance_screen.dart';
import 'features/employee/leave/leave_screen.dart';
import 'features/employee/pay/pay_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class _HomeScreen extends ConsumerWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLeader = ref.watch(isLeaderProvider);
    if (isLeader) {
      return const LeaderHomeScreen();
    } else {
      return const EmployeeHomeScreen();
    }
  }
}

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return _AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _HomeScreen(),
        ),
        GoRoute(
          path: '/leader/approvals',
          builder: (context, state) => const ApprovalsScreen(),
        ),
        GoRoute(
          path: '/leader/team',
          builder: (context, state) => const TeamScreen(),
        ),
        GoRoute(
          path: '/leader/reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/employee/tasks',
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: '/employee/attendance',
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          path: '/employee/leave',
          builder: (context, state) => const LeaveScreen(),
        ),
        GoRoute(
          path: '/employee/pay',
          builder: (context, state) => const PayScreen(),
        ),
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
      ],
    ),
  ],
);

class _AppShell extends ConsumerWidget {
  final Widget child;

  const _AppShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastOverlay(
      child: Scaffold(
        body: child,
        bottomNavigationBar: const PfBottomNav(),
      ),
    );
  }
}

class PeopleFirstApp extends StatelessWidget {
  const PeopleFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PeopleFirst',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
