// lib/widgets/campaign_card.dart
import 'package:flutter/material.dart';
import '../models/campaign_model.dart';
import '../utils/constants.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback? onTap;
  final bool showActions;

  const CampaignCard({
    Key? key,
    required this.campaign,
    this.onTap,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.cardElevation,
      margin: EdgeInsets.symmetric(vertical: AppSizes.marginS),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with platform and status
              Row(
                children: [
                  _buildPlatformChip(),
                  Spacer(),
                  _buildStatusChip(),
                ],
              ),

              SizedBox(height: AppSizes.marginS),

              // Title
              Text(
                campaign.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: AppSizes.marginS),

              // Description
              Text(
                campaign.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: AppSizes.marginM),

              // Price and deadline info
              Row(
                children: [
                  // Price
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                      vertical: AppSizes.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Text(
                      '₹${campaign.pricePerReview.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  SizedBox(width: AppSizes.marginS),

                  // Reviews needed
                  Icon(
                    Icons.rate_review,
                    size: AppSizes.iconS,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${campaign.completedReviews}/${campaign.totalReviewsNeeded}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),

                  Spacer(),

                  // Deadline
                  Icon(
                    Icons.schedule,
                    size: AppSizes.iconS,
                    color: _getDeadlineColor(),
                  ),
                  SizedBox(width: 4),
                  Text(
                    _getDeadlineText(),
                    style: TextStyle(
                      color: _getDeadlineColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.marginS),

              // Progress bar
              _buildProgressBar(),

              if (showActions) ...[
                SizedBox(height: AppSizes.marginS),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformChip() {
    final platformName = AppConstants.platformNames[campaign.platform.toString().split('.').last] ?? 'Other';
    final platformColor = AppConstants.platformColors[campaign.platform.toString().split('.').last] ?? Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: platformColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        border: Border.all(color: platformColor.withOpacity(0.3)),
      ),
      child: Text(
        platformName,
        style: TextStyle(
          color: platformColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    String statusText;

    switch (campaign.status.toString().split('.').last) {
      case 'active':
        statusColor = AppColors.success;
        statusText = 'Active';
        break;
      case 'completed':
        statusColor = AppColors.info;
        statusText = 'Completed';
        break;
      case 'paused':
        statusColor = AppColors.warning;
        statusText = 'Paused';
        break;
      case 'expired':
        statusColor = AppColors.error;
        statusText = 'Expired';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = campaign.totalReviewsNeeded > 0
        ? campaign.completedReviews / campaign.totalReviewsNeeded
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? AppColors.success : AppColors.primary,
          ),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onTap,
            child: Text('View Details'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.marginS),
        Expanded(
          child: ElevatedButton(
            onPressed: campaign.status == CampaignStatus.active ? () {
              // Navigate to submit review
            } : null,
            child: Text('Submit Review'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getDeadlineColor() {
    final now = DateTime.now();
    final deadline = campaign.deadline;
    final daysLeft = deadline.difference(now).inDays;

    if (daysLeft < 0) {
      return AppColors.error; // Expired
    } else if (daysLeft <= 1) {
      return AppColors.error; // Critical
    } else if (daysLeft <= 3) {
      return AppColors.warning; // Warning
    } else {
      return AppColors.textSecondary; // Normal
    }
  }

  String _getDeadlineText() {
    final now = DateTime.now();
    final deadline = campaign.deadline;
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    if (days > 0) {
      return '${days}d left';
    } else if (hours > 0) {
      return '${hours}h left';
    } else {
      final minutes = difference.inMinutes;
      return '${minutes}m left';
    }
  }
}