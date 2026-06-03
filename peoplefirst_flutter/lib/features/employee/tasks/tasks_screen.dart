import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/task_item.dart';
import '../../../providers/employee/tasks_provider.dart';
import '../../../providers/toast_provider.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/pf_button.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list_rounded,
              color: AppColors.contentHeavy,
            ),
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tasks) {
          final todayTasks =
              tasks.where((t) => t.due == TaskDue.today).toList();
          final tomorrowTasks =
              tasks.where((t) => t.due == TaskDue.tomorrow).toList();
          final laterTasks = tasks
              .where((t) =>
                  t.due == TaskDue.thisWeek || t.due == TaskDue.later)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (todayTasks.isNotEmpty) ...[
                Text('TODAY', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 8),
                PfCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: List.generate(todayTasks.length, (i) {
                      return Column(
                        children: [
                          _FullTaskRow(task: todayTasks[i]),
                          if (i < todayTasks.length - 1)
                            const Divider(height: 1, indent: 48, endIndent: 16),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (tomorrowTasks.isNotEmpty) ...[
                Text('TOMORROW', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 8),
                PfCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: List.generate(tomorrowTasks.length, (i) {
                      return Column(
                        children: [
                          _FullTaskRow(task: tomorrowTasks[i]),
                          if (i < tomorrowTasks.length - 1)
                            const Divider(height: 1, indent: 48, endIndent: 16),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (laterTasks.isNotEmpty) ...[
                Text('LATER THIS WEEK', style: AppTextStyles.sectionHeader),
                const SizedBox(height: 8),
                PfCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: List.generate(laterTasks.length, (i) {
                      return Column(
                        children: [
                          _FullTaskRow(task: laterTasks[i]),
                          if (i < laterTasks.length - 1)
                            const Divider(height: 1, indent: 48, endIndent: 16),
                        ],
                      );
                    }),
                  ),
                ),
              ],
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(toastProvider.notifier).show('New task created');
        },
        backgroundColor: AppColors.relianceBase,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _FullTaskRow extends ConsumerWidget {
  final TaskItem task;

  const _FullTaskRow({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => ref.read(tasksProvider.notifier).toggleTask(task.id),
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.completed
                      ? AppColors.positive
                      : AppColors.strokeHeavy,
                  width: 2,
                ),
                color:
                    task.completed ? AppColors.positive : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: task.completed
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: task.completed
                        ? AppColors.contentMinimal
                        : AppColors.contentHeavy,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _PriorityTag(task.priority),
                    const SizedBox(width: 6),
                    _SourceTag(task.source),
                    const SizedBox(width: 6),
                    Text(
                      task.dueLabel,
                      style: AppTextStyles.captionMinimal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityTag extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityTag(this.priority);

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    String label;
    switch (priority) {
      case TaskPriority.high:
        color = AppColors.negative;
        bg = AppColors.negativeLight;
        label = 'High';
        break;
      case TaskPriority.medium:
        color = AppColors.warning;
        bg = AppColors.warningLight;
        label = 'Medium';
        break;
      case TaskPriority.low:
        color = AppColors.positive;
        bg = AppColors.positiveLight;
        label = 'Low';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _SourceTag extends StatelessWidget {
  final TaskSource source;

  const _SourceTag(this.source);

  @override
  Widget build(BuildContext context) {
    final isAzure = source == TaskSource.azure;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAzure ? AppColors.skyLight : AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isAzure ? 'Azure DevOps' : 'Self',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAzure ? AppColors.skyInk : AppColors.contentModerate,
        ),
      ),
    );
  }
}
