import 'package:flutter/material.dart';

import '../models/campaign_model.dart';

class CompanyCampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onTap;

  CompanyCampaignCard({required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(campaign.title),
        subtitle: Text('₹${campaign.pricePerReview} per review • ${campaign.completedReviews}/${campaign.totalReviewsNeeded} done'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
