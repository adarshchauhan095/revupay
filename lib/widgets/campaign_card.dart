// lib/widgets/campaign_card.dart
import 'package:flutter/material.dart';
import '../models/campaign_model.dart';
import '../utils/helpers.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback? onTap;

  const CampaignCard({
    Key? key,
    required this.campaign,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPlatformColor(campaign.platform),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getPlatformName(campaign.platform),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '₹${campaign.pricePerReview.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Text(
                campaign.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8),

              Text(
                campaign.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    campaign.companyName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    'Ends ${Helpers.formatDate(campaign.deadline)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              SizedBox(height: 8),

              LinearProgressIndicator(
                value: campaign.completedReviews / campaign.totalReviewsNeeded,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),

              SizedBox(height: 4),

              Text(
                '${campaign.completedReviews}/${campaign.totalReviewsNeeded} reviews completed',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPlatformColor(ReviewPlatform platform) {
    switch (platform) {
      case ReviewPlatform.google:
        return Colors.red;
      case ReviewPlatform.instagram:
        return Colors.purple;
      case ReviewPlatform.youtube:
        return Colors.red[700]!;
      case ReviewPlatform.facebook:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getPlatformName(ReviewPlatform platform) {
    switch (platform) {
      case ReviewPlatform.google:
        return 'Google';
      case ReviewPlatform.instagram:
        return 'Instagram';
      case ReviewPlatform.youtube:
        return 'YouTube';
      case ReviewPlatform.facebook:
        return 'Facebook';
      default:
        return 'Other';
    }
  }
}