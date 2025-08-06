import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/constants/area_type.dart';
import 'package:frontend/constants/pitch_type.dart';
import 'package:frontend/constants/surface_type.dart';

import '../constants/image_path.dart';
import '../widgets/primary_button.dart';

class MandatoryFieldsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  //Mandatory Fields
  final VoidCallback onContinuePressed;
  final TextEditingController nameController;
  final Widget Function() autocompleteCityFieldBuilder;
  final TextEditingController autocompleteCityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController mailController;
  final bool isFree;
  final ValueChanged<bool?> onIsFreeChanged;
  final PitchType? pitchType;
  final ValueChanged<PitchType?> onPitchTypeChanged;
  final Widget? customCityField;

  const MandatoryFieldsForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.autocompleteCityController,
    required this.autocompleteCityFieldBuilder,
    required this.addressController,
    required this.phoneController,
    required this.mailController,
    required this.isFree,
    required this.pitchType,
    required this.onIsFreeChanged,
    required this.onPitchTypeChanged,
    required this.onContinuePressed,
    required this.customCityField,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Opacity(
          opacity: 0.9,
          child: Image.asset(
            ImagePath.backgroundAddField,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Back button
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),

        // Form content
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLabeledField("Name", nameController, validator: validatorName),
                    customCityField ?? _buildLabeledField("City", autocompleteCityController, validator: validatorAutocompletionCity),
                    _buildLabeledField("Address", addressController, validator: validatorAddress),
                    _buildLabeledField("Phone", phoneController, validator: validatorPhone),
                    _buildLabeledField("Email", mailController, validator: validatorMail),
                    const SizedBox(height: 12),

                    _buildDropdown(),

                    const SizedBox(height: 12),
                    _buildRadioGroup(),

                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: "Continue",
                      onPressed: () {
                        FocusScope.of(context).unfocus(); // Hide keyboard
                        if (formKey.currentState!.validate()) {
                          onContinuePressed();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField(
      String label,
      TextEditingController controller, {
        bool obscure = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<PitchType>(
      value: pitchType,
      dropdownColor: Colors.black,
      decoration: InputDecoration(
        labelText: "Pitch Type",
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: PitchType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.name, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onPitchTypeChanged,
      validator: (value) => value == null ? 'Select pitch type' : null,
    );
  }

  Widget _buildRadioGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Is Free?', style: TextStyle(color: Colors.white)),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isFree,
              onChanged: onIsFreeChanged,
            ),
            const Text('Yes', style: TextStyle(color: Colors.white)),
            Radio<bool>(
              value: false,
              groupValue: isFree,
              onChanged: onIsFreeChanged,
            ),
            const Text('No', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

  //VALIDATORS

    //Name
    String? validatorName(String? name) {
      if (name == null || name
          .trim()
          .isEmpty) {
        return 'Name is required';
      }
      return null;
    }

    //City
    String? validatorAutocompletionCity(String? city) {
      if (city == null || city
          .trim()
          .isEmpty) {
        return 'City is required';
      }
      return null;
    }

    //Address
    String? validatorAddress(String? address) {
      if (address == null || address
          .trim()
          .isEmpty) {
        return 'Address is required';
      }
      final hasNumber = RegExp(r'\d').hasMatch(address);
      if (!hasNumber) {
        return 'Address must contain a number (street number)';
      }
      return null;
    }

    //Phone
    String? validatorPhone(String? phone) {
      if (phone == null || phone
          .trim()
          .isEmpty) {
        return 'Phone is required';
      }

      //Check that it contains only digits (optional + at start)
      final isValid = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone);
      if (!isValid) {
        return 'Phone must contain only numbers and an optional +';
      }
      return null;
    }

    //Mail
    String? validatorMail(String? mail) {
      if (mail == null || mail
          .trim()
          .isEmpty) {
        return 'Email is required';
      }

      final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(mail);
      if (!isValid) {
        return 'Enter a valid email address';
      }
      return null;
    }

class OptionalFieldsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  //Optional Fields
  final VoidCallback onBackPressed;
  final TextEditingController descriptionController;
  final TextEditingController websiteController;
  final bool canShower;
  final bool hasParking;
  final bool hasLighting;
  final TimeOfDay? openingTime;
  final TimeOfDay? lunchBrakeStart;
  final TimeOfDay? lunchBrakeEnd;
  final TimeOfDay? closingTime;
  final TextEditingController priceController;
  final SurfaceType? surfaceType;
  final AreaType? areaType;
  final List<File> images;

  //Callbacks for time pickers and toggles (to update parent state)
  final ValueChanged<bool> onCanShowerChanged;
  final ValueChanged<bool> onHasParkingChanged;
  final ValueChanged<bool> onHasLightingChanged;
  final ValueChanged<TimeOfDay?> onOpeningTimeChanged;
  final ValueChanged<TimeOfDay?> onLunchBrakeStartChanged;
  final ValueChanged<TimeOfDay?> onLunchBrakeEndChanged;
  final ValueChanged<TimeOfDay?> onClosingTimeChanged;
  final ValueChanged<SurfaceType?> onSurfaceTypeChanged;
  final ValueChanged<AreaType?> onAreaTypeChanged;
  final VoidCallback onAddImage; //for image picker button
  final Future<void> Function() onSave;

  const OptionalFieldsForm({
    super.key,
    required this.formKey,
    required this.descriptionController,
    required this.websiteController,
    required this.canShower,
    required this.hasParking,
    required this.hasLighting,
    required this.openingTime,
    required this.lunchBrakeStart,
    required this.lunchBrakeEnd,
    required this.closingTime,
    required this.priceController,
    required this.surfaceType,
    required this.areaType,
    required this.images,
    required this.onCanShowerChanged,
    required this.onHasParkingChanged,
    required this.onHasLightingChanged,
    required this.onOpeningTimeChanged,
    required this.onLunchBrakeStartChanged,
    required this.onLunchBrakeEndChanged,
    required this.onClosingTimeChanged,
    required this.onSurfaceTypeChanged,
    required this.onAreaTypeChanged,
    required this.onAddImage,
    required this.onBackPressed,
    required this.onSave,
  });

  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime, ValueChanged<TimeOfDay?> onTimeChanged) async {
    final picked = await showTimePicker(context: context, initialTime: initialTime ?? TimeOfDay.now());
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: Text('Can Shower'),
              value: canShower,
              onChanged: onCanShowerChanged,
            ),

            SwitchListTile(
              title: Text('Has Parking'),
              value: hasParking,
              onChanged: onHasParkingChanged,
            ),

            SwitchListTile(
              title: Text('Has Lighting'),
              value: hasLighting,
              onChanged: onHasLightingChanged,
            ),

            const SizedBox(height: 16),
            Text('Opening Time'),
            ListTile(
              title: Text(openingTime?.format(context) ?? 'Select Opening Time'),
              trailing: Icon(Icons.access_time),
              onTap: () => _pickTime(context, openingTime, onOpeningTimeChanged),
            ),

            Text('Lunch Break Start'),
            ListTile(
              title: Text(lunchBrakeStart?.format(context) ?? 'Select Lunch Break Start'),
              trailing: Icon(Icons.access_time),
              onTap: () => _pickTime(context, lunchBrakeStart, onLunchBrakeStartChanged),
            ),

            Text('Lunch Break End'),
            ListTile(
              title: Text(lunchBrakeEnd?.format(context)?? 'Select Lunch Break End'),
              trailing: Icon(Icons.access_time),
              onTap: () => _pickTime(context, lunchBrakeEnd, onLunchBrakeEndChanged),
            ),

            Text('Closing Time'),
            ListTile(
              title: Text(closingTime?.format(context) ?? 'Select Closing Time'),
              trailing: Icon(Icons.access_time),
              onTap: () => _pickTime(context, closingTime, onClosingTimeChanged),
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<SurfaceType>(
              value: surfaceType,
              decoration: InputDecoration(labelText: 'Surface Type'),
              items: SurfaceType.values.map((surface) {
                return DropdownMenuItem(
                  value: surface,
                  child: Text(surface.name),
                );
              }).toList(),
              onChanged: onSurfaceTypeChanged,
              validator: (value) => value == null ? 'Select surface type' : null,
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<AreaType>(
              value: areaType,
              decoration: InputDecoration(labelText: 'Area Type'),
              items: AreaType.values.map((area) {
                return DropdownMenuItem(
                  value: area,
                  child: Text(area.name),
                );
              }).toList(),
              onChanged: onAreaTypeChanged,
              validator: (value) => value == null ? 'Select area type' : null,
            ),

            const SizedBox(height: 16),
            Text('Images'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ...images.map((file) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                    // Optional: add a delete button
                  ],
                )),
                GestureDetector(
                  onTap: onAddImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey[700]),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            // Buttons Row: Back and Save
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                ),
                ElevatedButton(
                  onPressed: () async {
                    await onSave();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}