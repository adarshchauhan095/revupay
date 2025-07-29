// lib/screens/user/campaign_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/campaign_model.dart';
import '../../controllers/campaign_controller.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import 'submit_review_screen.dart';

class CampaignDetailScreen extends StatefulWidget {
  final CampaignModel campaign;

  const CampaignDetailScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  _CampaignDetailScreenState createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final CampaignController _campaignController = Get.find();
  bool _isEligible = false;
  bool _checkingEligibility = true;

  @override
  void initState() {
    super.initState();
    _checkUserEligibility();
  }

  Future<void> _checkUserEligibility() async {
    setState(() => _checkingEligibility = true);

    final eligible = await _campaignController.checkUserEligibility(widget.campaign.id);

    setState(() {
      _isEligible = eligible;
      _checkingEligibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: campaign.imageUrl != null
                  ? CachedNetworkImage(
                imageUrl: campaign.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.campaign,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  _buildHeaderInfo(),

                  SizedBox(height: AppSizes.marginL),

                  // Description
                  _buildDescriptionSection(),

                  SizedBox(height: AppSizes.marginL),

                  // Requirements
                  _buildRequirementsSection(),

                  SizedBox(height: AppSizes.marginL),

                  // Platform Info
                  _buildPlatformSection(),

                  SizedBox(height: AppSizes.marginL),

                  // Progress
                  _buildProgressSection(),

                  SizedBox(height: AppSizes.marginL),

                  // Additional Info
                  if (campaign.tags.isNotEmpty) _buildTagsSection(),

                  SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderInfo() {
    final campaign = widget.campaign;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Platform and Status chips
        Row(
          children: [
            _buildPlatformChip(),
            SizedBox(width: AppSizes.marginS),
            _buildStatusChip(),
            Spacer(),
            _buildDeadlineChip(),
          ],
        ),

        SizedBox(height: AppSizes.marginM),

        // Title
        Text(
          campaign.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppSizes.marginS),

        // Price
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monetization_on, color: AppColors.success, size: 20),
              SizedBox(width: 4),
              Text(
                '₹${campaign.pricePerReview.toStringAsFixed(0)} per review',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.marginS),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            widget.campaign.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsSection() {
    if (widget.campaign.requirements.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requirements',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.marginS),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: AppColors.warning.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.campaign.requirements.map((requirement) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          requirement,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSection() {
    final campaign = widget.campaign;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.marginS),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Platform:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    campaign.platformDisplayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (campaign.platformUrl.isNotEmpty) ...[
                SizedBox(height: AppSizes.marginS),
                Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'URL:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        campaign.platformUrl,
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final campaign = widget.campaign;
    final progress = campaign.progressPercentage / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Campaign Progress',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.marginS),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${campaign.completedReviews} / ${campaign.totalReviewsNeeded} reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${campaign.progressPercentage.toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.marginS),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? AppColors.success : AppColors.primary,
                ),
                minHeight: 8,
              ),
              SizedBox(height: AppSizes.marginS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget: ₹${campaign.totalBudget.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Remaining: ${campaign.remainingReviews} reviews',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.marginS),
        Wrap(
          spacing: AppSizes.marginS,
          runSpacing: AppSizes.marginS,
          children: widget.campaign.tags.map((tag) =>
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical: AppSizes.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildPlatformChip() {
    final platformName = widget.campaign.platformDisplayName;
    final platformColor = AppConstants.platformColors[
    widget.campaign.platform.toString().split('.').last
    ] ?? Colors.grey;

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
    final campaign = widget.campaign;
    Color statusColor;
    String statusText;

    switch (campaign.status) {
      case CampaignStatus.active:
        statusColor = AppColors.success;
        statusText = 'Active';
        break;
      case CampaignStatus.completed:
        statusColor = AppColors.info;
        statusText = 'Completed';
        break;
      case CampaignStatus.paused:
        statusColor = AppColors.warning;
        statusText = 'Paused';
        break;
      case CampaignStatus.expired:
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

  Widget _buildDeadlineChip() {
    final campaign = widget.campaign;
    final now = DateTime.now();
    final deadline = campaign.deadline;
    final difference = deadline.difference(now);

    Color deadlineColor;
    String deadlineText;

    if (difference.isNegative) {
      deadlineColor = AppColors.error;
      deadlineText = 'Expired';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours % 24;

      if (days > 3) {
        deadlineColor = AppColors.textSecondary;
        deadlineText = '${days}d left';
      } else if (days > 0) {
        deadlineColor = AppColors.warning;
        deadlineText = '${days}d left';
      } else if (hours > 0) {
        deadlineColor = AppColors.error;
        deadlineText = '${hours}h left';
      } else {
        deadlineColor = AppColors.error;
        deadlineText = 'Ending soon';
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: deadlineColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 12,
            color: deadlineColor,
          ),
          SizedBox(width: 4),
          Text(
            deadlineText,
            style: TextStyle(
              color: deadlineColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (_checkingEligibility) {
      return FloatingActionButton.extended(
        onPressed: null,
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text('Checking...'),
        backgroundColor: Colors.grey[300],
      );
    }

    if (!widget.campaign.isActive) {
      return FloatingActionButton.extended(
        onPressed: null,
        icon: Icon(Icons.info),
        label: Text('Campaign Inactive'),
        backgroundColor: Colors.grey[400],
      );
    }

    if (!_isEligible) {
      return FloatingActionButton.extended(
        onPressed: null,
        icon: Icon(Icons.block),
        label: Text('Already Submitted'),
        backgroundColor: Colors.grey[400],
      );
    }

    return FloatingActionButton.extended(
      onPressed: () {
        // Get.to(() => SubmitReviewScreen(campaign: widget.campaign));
      },
      icon: Icon(Icons.rate_review),
      label: Text('Submit Review'),
      backgroundColor: AppColors.primary,
    );
  }
}