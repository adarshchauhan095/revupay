// lib/controllers/campaign_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campaign_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class CampaignController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();

  final RxList<CampaignModel> _campaigns = <CampaignModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final Rx<ReviewPlatform?> _selectedPlatform = Rx<ReviewPlatform?>(null);
  final RxDouble _minPrice = 0.0.obs;
  final RxDouble _maxPrice = 1000.0.obs;

  List<CampaignModel> get campaigns => _campaigns;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  ReviewPlatform? get selectedPlatform => _selectedPlatform.value;
  double get minPrice => _minPrice.value;
  double get maxPrice => _maxPrice.value;

  List<CampaignModel> get filteredCampaigns {
    List<CampaignModel> filtered = List.from(_campaigns);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((campaign) =>
      campaign.title.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          campaign.description.toLowerCase().contains(_searchQuery.value.toLowerCase())
      ).toList();
    }

    // Apply platform filter
    if (_selectedPlatform.value != null) {
      filtered = filtered.where((campaign) =>
      campaign.platform == _selectedPlatform.value).toList();
    }

    // Apply price filter
    filtered = filtered.where((campaign) =>
    campaign.pricePerReview >= _minPrice.value &&
        campaign.pricePerReview <= _maxPrice.value
    ).toList();

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadCampaigns();
  }

  Future<void> loadCampaigns() async {
    try {
      _isLoading.value = true;

      _databaseService.getActiveCampaigns(limit: 50).listen((campaigns) {
        _campaigns.value = campaigns;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load campaigns: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshCampaigns() async {
    await loadCampaigns();
  }

  void searchCampaigns(String query) {
    _searchQuery.value = query;
  }

  void setPlatformFilter(ReviewPlatform? platform) {
    _selectedPlatform.value = platform;
  }

  void setPriceFilter(double min, double max) {
    _minPrice.value = min;
    _maxPrice.value = max;
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedPlatform.value = null;
    _minPrice.value = 0.0;
    _maxPrice.value = 1000.0;
  }

  Future<void> viewCampaignDetails(CampaignModel campaign) async {
    Get.toNamed('/campaign-detail', arguments: campaign);
  }

  Future<bool> checkUserEligibility(String campaignId) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return false;

      // Check if user has already submitted for this campaign
      final submissions = await FirebaseFirestore.instance
          .collection('reviewSubmissions')
          .where('userId', isEqualTo: user.uid)
          .where('campaignId', isEqualTo: campaignId)
          .get();

      return submissions.docs.isEmpty;
    } catch (e) {
      print('Error checking eligibility: $e');
      return false;
    }
  }

  List<CampaignModel> getCampaignsByPlatform(ReviewPlatform platform) {
    return _campaigns.where((campaign) => campaign.platform == platform).toList();
  }

  List<CampaignModel> getHighPayingCampaigns({double minAmount = 50.0}) {
    return _campaigns
        .where((campaign) => campaign.pricePerReview >= minAmount)
        .toList()
      ..sort((a, b) => b.pricePerReview.compareTo(a.pricePerReview));
  }

  List<CampaignModel> getEndingSoonCampaigns({int daysThreshold = 3}) {
    final threshold = DateTime.now().add(Duration(days: daysThreshold));
    return _campaigns
        .where((campaign) => campaign.deadline.isBefore(threshold))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  Future<List<CampaignModel>> searchCampaignsWithFilters({
    String? searchTerm,
    ReviewPlatform? platform,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      _isLoading.value = true;

      final campaigns = await _databaseService.searchCampaigns(
        searchTerm: searchTerm,
        platform: platform,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ).first;

      return campaigns;
    } catch (e) {
      Get.snackbar('Error', 'Search failed: ${e.toString()}');
      return [];
    } finally {
      _isLoading.value = false;
    }
  }
}