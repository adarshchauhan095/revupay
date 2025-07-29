// lib/screens/admin/campaign_oversight_screen.dart
import 'package:flutter/material.dart';

class CampaignOversightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Campaign Oversight')),
      body: Center(child: Text('Campaign oversight details')),
    );
  }
}

// lib/screens/admin/dispute_resolution_screen.dart
class DisputeResolutionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dispute Resolution')),
      body: Center(child: Text('Dispute resolution panel')),
    );
  }
}

// lib/screens/admin/analytics_dashboard.dart
class AnalyticsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: Center(child: Text('Analytics and reports')),
    );
  }
}
