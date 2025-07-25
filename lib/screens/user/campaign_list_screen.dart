// lib/screens/user/campaign_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/campaign_controller.dart';
import '../../models/campaign_model.dart';
import '../../widgets/campaign_card.dart';
import '../../widgets/platform_selector.dart';
import '../../utils/constants.dart';
import 'campaign_detail_screen.dart';

class CampaignListScreen extends StatefulWidget {
  @override
  _CampaignListScreenState createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final CampaignController _campaignController = Get.find();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _campaignController.refreshCampaigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Campaigns'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search campaigns...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _campaignController.searchCampaigns('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                _campaignController.searchCampaigns(value);
              },
            ),
          ),

          // Active Filters Display
          Obx(() {
            final hasFilters = _campaignController.selectedPlatform != null ||
                _campaignController.minPrice > 0 ||
                _campaignController.maxPrice < 1000;

            if (!hasFilters) return SizedBox.shrink();

            return Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_campaignController.selectedPlatform != null)
                    _buildFilterChip(
                      label: _getPlatformName(_campaignController.selectedPlatform!),
                      onRemove: () => _campaignController.setPlatformFilter(null),
                    ),
                  if (_campaignController.minPrice > 0 || _campaignController.maxPrice < 1000)
                    _buildFilterChip(
                      label: '₹${_campaignController.minPrice.toInt()}-₹${_campaignController.maxPrice.toInt()}',
                      onRemove: () => _campaignController.setPriceFilter(0, 1000),
                    ),
                  if (hasFilters)
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: ActionChip(
                        label: Text('Clear All'),
                        onPressed: _campaignController.clearFilters,
                        backgroundColor: Colors.red[50],
                        labelStyle: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                ],
              ),
            );
          }),

          // Campaign Categories
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryCard(
                  title: 'High Paying',
                  subtitle: '₹50+ per review',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  onTap: () => _showCategoryList('high_paying'),
                ),
                _buildCategoryCard(
                  title: 'Ending Soon',
                  subtitle: 'Less than 3 days',
                  icon: Icons.timer,
                  color: Colors.orange,
                  onTap: () => _showCategoryList('ending_soon'),
                ),
                _buildCategoryCard(
                  title: 'Google Reviews',
                  subtitle: 'Google My Business',
                  icon: Icons.star,
                  color: Colors.blue,
                  onTap: () => _showPlatformList(ReviewPlatform.google),
                ),
                _buildCategoryCard(
                  title: 'Instagram',
                  subtitle: 'Social media posts',
                  icon: Icons.photo_camera,
                  color: Colors.purple,
                  onTap: () => _showPlatformList(ReviewPlatform.instagram),
                ),
              ],
            ),
          ),

          // Campaign List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _campaignController.refreshCampaigns,
              child: Obx(() {
                if (_campaignController.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                final campaigns = _campaignController.filteredCampaigns;

                if (campaigns.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CampaignCard(
                        campaign: campaign,
                        onTap: () => _viewCampaignDetails(campaign),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        onDeleted: onRemove,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        labelStyle: TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No campaigns found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _campaignController.clearFilters();
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    ReviewPlatform? tempPlatform = _campaignController.selectedPlatform;
    double tempMinPrice = _campaignController.minPrice;
    double tempMaxPrice = _campaignController.maxPrice;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Filter Campaigns'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform Filter
                Text(
                  'Platform',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text('All'),
                      selected: tempPlatform == null,
                      onSelected: (selected) {
                        setState(() {
                          tempPlatform = null;
                        });
                      },
                    ),
                    ...ReviewPlatform.values.map((platform) => FilterChip(
                      label: Text(_getPlatformName(platform)),
                      selected: tempPlatform == platform,
                      onSelected: (selected) {
                        setState(() {
                          tempPlatform = selected ? platform : null;
                        });
                      },
                    )),
                  ],
                ),

                SizedBox(height: 24),

                // Price Range Filter
                Text(
                  'Price Range',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Text('₹${tempMinPrice.toInt()} - ₹${tempMaxPrice.toInt()}'),
                RangeSlider(
                  values: RangeValues(tempMinPrice, tempMaxPrice),
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  labels: RangeLabels(
                    '₹${tempMinPrice.toInt()}',
                    '₹${tempMaxPrice.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      tempMinPrice = values.start;
                      tempMaxPrice = values.end;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _campaignController.setPlatformFilter(tempPlatform);
                _campaignController.setPriceFilter(tempMinPrice, tempMaxPrice);
                Get.back();
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryList(String category) {
    List<CampaignModel> campaigns;
    String title;

    switch (category) {
      case 'high_paying':
        campaigns = _campaignController.getHighPayingCampaigns(minAmount: 50.0);
        title = 'High Paying Campaigns';
        break;
      case 'ending_soon':
        campaigns = _campaignController.getEndingSoonCampaigns(daysThreshold: 3);
        title = 'Ending Soon';
        break;
      default:
        return;
    }

    _showCampaignListDialog(title, campaigns);
  }

  void _showPlatformList(ReviewPlatform platform) {
    final campaigns = _campaignController.getCampaignsByPlatform(platform);
    _showCampaignListDialog('${_getPlatformName(platform)} Campaigns', campaigns);
  }

  void _showCampaignListDialog(String title, List<CampaignModel> campaigns) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: campaigns.isEmpty
                    ? Center(
                  child: Text('No campaigns found in this category'),
                )
                    : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CampaignCard(
                        campaign: campaign,
                        onTap: () {
                          Get.back();
                          _viewCampaignDetails(campaign);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewCampaignDetails(CampaignModel campaign) {
    Get.to(() => CampaignDetailScreen(campaign: campaign));
  }

  String _getPlatformName(ReviewPlatform platform) {
    switch (platform) {
      case ReviewPlatform.google:
        return 'Google';
      case ReviewPlatform.instagram:
        return 'Instagram';
      case ReviewPlatform.facebook:
        return 'Facebook';
      case ReviewPlatform.trustpilot:
        return 'Trustpilot';
      case ReviewPlatform.yelp:
        return 'Yelp';
      case ReviewPlatform.other:
        return 'Other';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}