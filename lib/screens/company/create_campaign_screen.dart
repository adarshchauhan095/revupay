// lib/screens/company/create_campaign_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/company_campaign_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../models/campaign_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart' hide IconButton;
import '../../widgets/platform_selector.dart' show PlatformSelector;

class CreateCampaignScreen extends StatefulWidget {
  @override
  _CreateCampaignScreenState createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final CompanyCampaignController _campaignController = Get.find();
  final PaymentController _paymentController = Get.put(PaymentController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _businessLinkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalReviewsController = TextEditingController();

  ReviewPlatform _selectedPlatform = ReviewPlatform.google;
  DateTime _selectedDeadline = DateTime.now().add(Duration(days: 7));
  List<XFile> _selectedImages = [];
  bool _autoApproval = true;
  int _autoApprovalHours = 48;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Campaign'),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => _showHelp(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign Details Section
              _buildSectionHeader('Campaign Details'),
              SizedBox(height: 16),

              CustomTextField(
                controller: _titleController,
                label: 'Campaign Title',
                hint: 'Enter a catchy title for your campaign',
                validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
              ),

              SizedBox(height: 16),

              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe what you want reviewers to do',
                maxLines: 4,
                validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
              ),

              SizedBox(height: 16),

              CustomTextField(
                controller: _requirementsController,
                label: 'Requirements',
                hint: 'Specific requirements for the review (e.g., mention specific features)',
                maxLines: 3,
                validator: (value) => value?.isEmpty == true ? 'Requirements are required' : null,
              ),

              SizedBox(height: 24),

              // Platform & Link Section
              _buildSectionHeader('Platform & Business Link'),
              SizedBox(height: 16),

              Text(
                'Select Platform',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),

              PlatformSelector(
                selectedPlatform: _selectedPlatform,
                onPlatformChanged: (platform) {
                  setState(() {
                    _selectedPlatform = platform;
                  });
                },
              ),

              SizedBox(height: 16),

              CustomTextField(
                controller: _businessLinkController,
                label: 'Business Link',
                hint: 'Link to your business page (Google Maps, Instagram profile, etc.)',
                validator: (value) {
                  if (value?.isEmpty == true) return 'Business link is required';
                  final uri = Uri.tryParse(value!);
                  if (uri == null || !uri.hasAbsolutePath) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Pricing Section
              _buildSectionHeader('Pricing & Quantity'),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Price per Review (₹)',
                      hint: '0.00',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Price is required';
                        final price = double.tryParse(value!);
                        if (price == null || price <= 0) return 'Enter valid price';
                        if (price < 1) return 'Minimum price is ₹1';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _totalReviewsController,
                      label: 'Total Reviews Needed',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Quantity is required';
                        final quantity = int.tryParse(value!);
                        if (quantity == null || quantity <= 0) return 'Enter valid quantity';
                        if (quantity > 1000) return 'Maximum 1000 reviews per campaign';
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Total Cost Display
              Obx(() {
                final price = double.tryParse(_priceController.text) ?? 0;
                final quantity = int.tryParse(_totalReviewsController.text) ?? 0;
                final total = price * quantity;

                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Campaign Cost:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 24),

              // Deadline Section
              _buildSectionHeader('Campaign Settings'),
              SizedBox(height: 16),

              ListTile(
                title: Text('Campaign Deadline'),
                subtitle: Text('${_selectedDeadline.day}/${_selectedDeadline.month}/${_selectedDeadline.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDeadline(),
                contentPadding: EdgeInsets.zero,
              ),

              SizedBox(height: 16),

              SwitchListTile(
                title: Text('Auto-approval'),
                subtitle: Text('Automatically approve reviews after ${_autoApprovalHours} hours'),
                value: _autoApproval,
                onChanged: (value) {
                  setState(() {
                    _autoApproval = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),

              if (_autoApproval) ...[
                SizedBox(height: 8),
                Slider(
                  value: _autoApprovalHours.toDouble(),
                  min: 24,
                  max: 168, // 7 days
                  divisions: 6,
                  label: '${_autoApprovalHours}h',
                  onChanged: (value) {
                    setState(() {
                      _autoApprovalHours = value.round();
                    });
                  },
                ),
                Text(
                  'Auto-approval after: ${_autoApprovalHours} hours',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],

              SizedBox(height: 24),

              // Media Upload Section
              _buildSectionHeader('Campaign Media (Optional)'),
              SizedBox(height: 16),

              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImages.isEmpty
                    ? InkWell(
                  onTap: _selectImages,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Add campaign images'),
                      Text('(Max 3 images)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                )
                    : GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      return InkWell(
                        onTap: _selectedImages.length < 3 ? _selectImages : null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.add, color: Colors.grey),
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index] as File),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 32),

              // Create Campaign Button
              Obx(() => CustomButton(
                text: 'Create Campaign & Pay',
                isLoading: _campaignController.isLoading.value,
                onPressed: _createCampaign,
              )),

              SizedBox(height: 16),

              Text(
                '• You will be charged the full campaign amount upfront\n'
                    '• Funds will be held in escrow until reviews are approved\n'
                    '• Unused funds will be refunded if campaign expires',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.take(3 - _selectedImages.length));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Campaign Creation Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tips for successful campaigns:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Write clear, specific requirements'),
              Text('• Set competitive pricing'),
              Text('• Provide correct business links'),
              Text('• Upload relevant images'),
              Text('• Set realistic deadlines'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _createCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceController.text);
    final totalReviews = int.parse(_totalReviewsController.text);
    final totalCost = price * totalReviews;

    // Show payment confirmation
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campaign: ${_titleController.text}'),
            Text('Total Reviews: $totalReviews'),
            Text('Price per Review: ₹${price.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text(
              'Total Amount: ₹${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('This amount will be charged immediately and held in escrow.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Pay & Create'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Process payment first
    final paymentSuccess = await _paymentController.processPayment(
      amount: totalCost,
      description: 'Campaign: ${_titleController.text}',
    );

    if (!paymentSuccess) {
      Get.snackbar('Payment Failed', 'Unable to process payment. Please try again.');
      return;
    }

    // Upload images if any
    List<String> mediaUrls = [];
    if (_selectedImages.isNotEmpty) {
      mediaUrls = await _campaignController.uploadCampaignImages(_selectedImages);
    }

    // Create campaign
    await _campaignController.createCampaign(
      title: _titleController.text,
      description: _descriptionController.text,
      requirements: _requirementsController.text,
      platform: _selectedPlatform,
      businessLink: _businessLinkController.text,
      pricePerReview: price,
      totalReviewsNeeded: totalReviews,
      deadline: _selectedDeadline,
      mediaUrls: mediaUrls,
      autoApproval: _autoApproval,
      autoApprovalHours: _autoApprovalHours,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _businessLinkController.dispose();
    _priceController.dispose();
    _totalReviewsController.dispose();
    super.dispose();
  }
}