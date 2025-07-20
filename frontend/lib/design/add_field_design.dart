import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/constants/area_type.dart';
import 'package:frontend/constants/pitch_type.dart';
import 'package:frontend/constants/surface_type.dart';

class MandatoryFieldsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  //Mandatory Fields
  final TextEditingController nameController;
  final TextEditingController autocompleteCityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController mailController;
  final bool isFree;
  final ValueChanged<bool?> onIsFreeChanged;
  final PitchType? pitchType;
  final ValueChanged<PitchType?> onPitchTypeChanged;

  const MandatoryFieldsForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.autocompleteCityController,
    required this.addressController,
    required this.phoneController,
    required this.mailController,
    required this.isFree,
    required this.pitchType,
    required this.onIsFreeChanged,
    required this.onPitchTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.5,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: validatorName,
                  ),
                  TextFormField(
                    controller: autocompleteCityController,
                    decoration: InputDecoration(labelText: 'City'),
                    validator: validatorAutocompletionCity,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: validatorAddress,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: validatorPhone,
                  ),
                  TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: validatorMail,
                  ),
                  DropdownButtonFormField<PitchType>(
                    value: pitchType,
                    decoration: InputDecoration(labelText: 'Pitch Type'),
                    items: PitchType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: onPitchTypeChanged,
                    validator: (value) =>
                    value == null
                        ? 'Select pitch type'
                        : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Is Free?'),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: isFree,
                            onChanged: onIsFreeChanged,
                          ),
                          const Text('Yes'),
                          Radio<bool>(
                            value: false,
                            groupValue: isFree,
                            onChanged: onIsFreeChanged,
                          ),
                          const Text('No'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // continue
                  }
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  String? validatorName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validatorAutocompletionCity(String? city){
    if (city == null || city.trim().isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? validatorAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return 'Address is required';
    }
    final hasNumber = RegExp(r'\d').hasMatch(address);
    if (!hasNumber) {
      return 'Address must contain a number (street number)';
    }
    return null;
  }

  String? validatorPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone is required';
    }

    //Check that it contains only digits (optional + at start)
    final isValid = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone);
    if (!isValid) {
      return 'Phone must contain only numbers and an optional +';
    }
    return null;
  }


  String? validatorMail(String? mail) {
    if (mail == null || mail.trim().isEmpty) {
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
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Optional fields go here, e.g. description, website, switches, time pickers, etc.
          ],
        ),
      ),
    );
  }
}