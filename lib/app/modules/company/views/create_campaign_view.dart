
// lib/app/modules/company/views/create_campaign_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/company_controller.dart';

class CreateCampaignView extends GetView<CompanyController> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _businessLinkController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxReviewsController = TextEditingController();
  final _expiryController = TextEditingController();
  final _selectedPlatform = 'Google'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Campaign'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Campaign Title *',
                  hintText: 'Enter campaign title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Title is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe what users need to review',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Description is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Platform Target *',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                spacing: 8,
                children: ['Google', 'Instagram', 'Facebook', 'Yelp'].map((platform) {
                  return FilterChip(
                    label: Text(platform),
                    selected: _selectedPlatform.value == platform,
                    onSelected: (selected) {
                      if (selected) _selectedPlatform.value = platform;
                    },
                  );
                }).toList(),
              )),
              const SizedBox(height: 16),
              TextFormField(
                controller: _businessLinkController,
                decoration: const InputDecoration(
                  labelText: 'Business Page Link *',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Business link is required';
                  if (!GetUtils.isURL(value!)) return 'Enter a valid URL';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price per Review *',
                        hintText: '₹',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Price is required';
                        if (double.tryParse(value!) == null) return 'Enter valid amount';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxReviewsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max Reviews *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Max reviews required';
                        if (int.tryParse(value!) == null) return 'Enter valid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date *',
                  hintText: 'Select date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Expiry date is required';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _createCampaign,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Create Campaign'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      _expiryController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _createCampaign() async {
    if (_formKey.currentState?.validate() == true) {
      final expiry = _parseDate(_expiryController.text);
      if (expiry == null) {
        Get.snackbar('Error', 'Invalid expiry date');
        return;
      }

      final campaignData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'platform': _selectedPlatform.value,
        'businessLink': _businessLinkController.text,
        'pricePerReview': double.parse(_priceController.text),
        'maxReviews': int.parse(_maxReviewsController.text),
        'expiry': expiry.toIso8601String(),
      };

      final success = await controller.createCampaign(campaignData);
      if (success) {
        Get.back();
      }
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return null;
    }
  }
}