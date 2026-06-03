import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/persona_provider.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/screens/chat_screen.dart';
import 'widgets/emp_brief_widget.dart';
import 'widgets/attendance_widget.dart';
import 'widgets/quick_links_widget.dart';
import 'widgets/tasks_widget.dart';
import 'widgets/bookings_emp_widget.dart';
import 'widgets/emp_news_widget.dart';
import 'widgets/refers_card_widget.dart';

class EmployeeHomeScreen extends ConsumerWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persona = ref.watch(personaProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppHeader(
              name: persona.name,
              initials: persona.initials,
              onSearch: () {},
              onBell: () {},
              onProfile: () => context.go('/more'),
              badgeCount: 2,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const EmpBriefWidget(),
                const SizedBox(height: 20),
                AttendanceWidget(
                  onHistory: () => context.go('/employee/attendance'),
                ),
                const SizedBox(height: 20),
                const QuickLinksWidget(),
                const SizedBox(height: 20),
                const TasksWidget(),
                const SizedBox(height: 20),
                const BookingsEmpWidget(),
                const SizedBox(height: 20),
                const EmpNewsWidget(),
                const SizedBox(height: 20),
                const RefersCardWidget(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ChatScreen(),
          );
        },
        backgroundColor: AppColors.skyBase,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }
}
