import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/jobs_notifier.dart';
import '../providers/jobs_state.dart';
import '../widgets/job_offer_card.dart';
import '../widgets/new_job_banner.dart';
import '../../data/models/delivery_history_dto.dart';
import 'package:intl/intl.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobsInboxNotifierProvider.notifier).getInbox();
      ref.read(activeJobNotifierProvider.notifier).getActiveJob();
      ref.read(deliveryHistoryNotifierProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inboxState = ref.watch(jobsInboxNotifierProvider);
    final activeJobState = ref.watch(activeJobNotifierProvider);
    final historyState = ref.watch(deliveryHistoryNotifierProvider);
    final acceptJobState = ref.watch(acceptJobNotifierProvider);

    // Handle accept job success
    ref.listen<AcceptJobState>(acceptJobNotifierProvider, (previous, next) {
      if (next is AcceptJobSuccess) {
        // Navigate to active delivery
        context.go(RouteNames.activeDelivery);
        // Refresh active job
        ref.read(activeJobNotifierProvider.notifier).getActiveJob();
        // Refresh inbox
        ref.read(jobsInboxNotifierProvider.notifier).getInbox();
      } else if (next is AcceptJobError) {
        AppSnackbar.showError(context, next.message);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Jobs', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(jobsInboxNotifierProvider.notifier).getInbox();
          ref.read(activeJobNotifierProvider.notifier).getActiveJob();
          await ref.read(deliveryHistoryNotifierProvider.notifier).loadHistory();
        },
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Active Job Banner
              if (activeJobState is ActiveJobLoaded)
                NewJobBanner(
                  job: activeJobState.job,
                  onTap: () => context.go(RouteNames.activeDelivery),
                ),

              // Earnings & My deliveries
              _buildEarningsAndHistory(historyState),

              // New job offers
              Padding(
                padding: const EdgeInsets.fromLTRB(Insets.md, Insets.lg, Insets.md, Insets.sm),
                child: Text(
                  'New job offers',
                  style: TextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildInboxContent(inboxState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsAndHistory(DeliveryHistoryState state) {
    return switch (state) {
      DeliveryHistoryInitial() => const SizedBox.shrink(),
      DeliveryHistoryLoading() => const Padding(
          padding: EdgeInsets.all(Insets.md),
          child: Center(child: SizedBox(height: 40, child: CircularProgressIndicator())),
        ),
      DeliveryHistoryError(:final message) => Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: Text(
            message,
            style: TextStyles.bodySmall.copyWith(color: SemanticColors.error),
          ),
        ),
      DeliveryHistoryLoaded(:final data) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total earnings card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
                child: Padding(
                  padding: const EdgeInsets.all(Insets.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total earnings',
                        style: TextStyles.titleMedium,
                      ),
                      Text(
                        '${data.totalEarnings.toStringAsFixed(2)} SAR',
                        style: TextStyles.titleLarge.copyWith(
                          color: SemanticColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.mdV,
              // My deliveries
              Text(
                'My deliveries',
                style: TextStyles.titleSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.smV,
              if (data.deliveries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                  child: Text(
                    'No deliveries yet',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                ...data.deliveries.take(20).map((d) => _deliveryTile(d)),
              Gaps.lgV,
            ],
          ),
        ),
    };
  }

  Widget _deliveryTile(DeliveryHistoryItemDto d) {
    final statusText = d.isDelivered
        ? 'Delivered'
        : d.isCancelled
            ? 'Cancelled'
            : d.orderStatus;
    final statusColor = d.isDelivered
        ? SemanticColors.success
        : d.isCancelled
            ? SemanticColors.error
            : AppColors.textSecondary;
    final date = d.deliveredAt ?? d.acceptedAt;
    return Card(
      margin: const EdgeInsets.only(bottom: Insets.sm),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.orderNumber,
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gaps.xsV,
                  Text(
                    d.vendorName,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (date != null)
                    Text(
                      DateFormat('MMM d, y • HH:mm').format(date),
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  statusText,
                  style: TextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (d.isDelivered)
                  Text(
                    '${d.driverEarnings.toStringAsFixed(2)} SAR',
                    style: TextStyles.bodyMedium.copyWith(
                      color: SemanticColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInboxContent(JobsInboxState state) {
    return switch (state) {
      JobsInboxInitial() => const Padding(
          padding: EdgeInsets.all(Insets.lg),
          child: Center(child: LoadingView()),
        ),
      JobsInboxLoading() => const Padding(
          padding: EdgeInsets.all(Insets.lg),
          child: Center(child: LoadingView()),
        ),
      JobsInboxLoaded(:final jobs) => Padding(
          padding: const EdgeInsets.fromLTRB(Insets.md, 0, Insets.md, Insets.xlV),
          child: jobs.isEmpty
              ? EmptyState(
                  icon: Icons.work_outline,
                  title: 'No jobs available',
                  message: 'New job offers will appear here',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: jobs
                      .map(
                        (job) => Padding(
                          padding: const EdgeInsets.only(bottom: Insets.md),
                          child: JobOfferCard(
                            job: job,
                            onAccept: () => _handleAcceptJob(job.id),
                            onReject: () => _handleRejectJob(job.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      JobsInboxError(:final message) => Padding(
          padding: const EdgeInsets.all(Insets.md),
          child: ErrorState(
            message: message,
            onRetry: () {
              ref.read(jobsInboxNotifierProvider.notifier).getInbox();
            },
          ),
        ),
    };
  }

  void _handleAcceptJob(String jobOfferId) {
    ref.read(acceptJobNotifierProvider.notifier).acceptJob(jobOfferId);
  }

  void _handleRejectJob(String jobOfferId) {
    ref.read(acceptJobNotifierProvider.notifier).rejectJob(jobOfferId);
    ref.read(jobsInboxNotifierProvider.notifier).getInbox();
  }
}
