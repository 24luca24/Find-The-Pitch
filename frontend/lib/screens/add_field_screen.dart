import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/services/field_service.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/area_type.dart';
import '../constants/pitch_type.dart';
import '../constants/surface_type.dart';
import '../design/add_field_design.dart';

class AddFieldScreen extends StatefulWidget {
  const AddFieldScreen({super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {

  final _formKey = GlobalKey<FormState>();

  //Holds ID of created field from backend. Useful to store than images because they need a field reference
  String? _createdFieldId;

  //Mandatory Fields (_ means private)
  final _nameController = TextEditingController();
  late final TextEditingController _autocompleteCityController;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController(); //mail maybe?
  final _mailController = TextEditingController();
  bool _isFree = true;
  PitchType? _pitchType;

  //Optional Fields
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _canShower = false;
  bool _hasParking = false;
  bool _hasLighting = false;
  TimeOfDay? _openingTime;
  TimeOfDay? _lunchBrakeStart;
  TimeOfDay? _lunchBrakeEnd;
  TimeOfDay? _closingTime;
  final _priceController = TextEditingController();
  SurfaceType? _surfaceType;
  AreaType? _areaType;
  List<File> _images = [];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKeyMandatory = GlobalKey<FormState>();
  final _formKeyOptional = GlobalKey<FormState>();

  //Method to change page
  void _nextPage() {
   if(_currentPage == 0) {
     _continueFromMandatoryFields();
   } else if (_currentPage == 1) {
     _submitOptional();
   }
  }

  void _previousPage() {
    if(_currentPage > 0) {
      _pageController.animateToPage(_currentPage - 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _handlePitchTypeChanged(PitchType? newValue) {
    setState(() {
      _pitchType = newValue;
    });
  }

  void _handleIsFreeChanged(bool? value) {
    if (value != null) {
      setState(() {
        _isFree = value;
      });
    }
  }

  void _handleCanShowerChanged(bool? value) {
    if(value != null) {
      setState(() {
        _canShower = value;
      });
    }
  }

  void _handleHasParkingChanged(bool? value) {
    if (value != null) {
      setState(() {
        _hasParking = value;
      });
    }
  }

  void _handleHasLightiningChanged(bool? value) {
    if (value != null) {
      setState(() {
        _hasLighting = value;
      });
    }
  }

  void _handleOpeningTimeChanged(TimeOfDay? newTime) {
    if (newTime != null) {
      setState(() {
        _openingTime = newTime;
      });
    }
  }

  void _handleLunchBrakeStartChanged(TimeOfDay? newTime) {
    if (newTime != null) {
      setState(() {
        _lunchBrakeStart = newTime;
      });
    }
  }

  void _handleLunchBrakeEndChanged(TimeOfDay? newTime) {
    if (newTime != null) {
      setState(() {
        _lunchBrakeEnd = newTime;
      });
    }
  }

  void _handleClosingTimeChanged(TimeOfDay? newTime) {
    if (newTime != null) {
      setState(() {
        _closingTime = newTime;
      });
    }
  }

  void _handleSurfaceTypeChanged(SurfaceType? value) {
    if(value != null) {
      setState(() {
        _surfaceType = value;
      });
    }
  }

  void _handleAreaChanged(AreaType? value) {
    if(value != null) {
      setState(() {
        _areaType = value;
      });
    }
  }

  void _handleAddImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  //Function to validate the first part of the form and create a field
  Future<void> _continueFromMandatoryFields() async {
    if (_formKeyMandatory.currentState?.validate() ?? false) {
      try {
        final createdField = await FieldService.createField(
          name: _nameController.text.trim(),
          city: _autocompleteCityController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          mail: _mailController.text.trim(),
          isFree: _isFree,
          pitchType: _pitchType,
        );

        setState(() {
          _createdFieldId = createdField.id;
          _currentPage = 1;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating field: $e')));
      }
    }
  }

  //Function to update the instance field created (adding optional fields)
  Future<void> _submitOptional() async {
    if (_formKeyOptional.currentState?.validate() ?? false) {
      if (_createdFieldId == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No field ID available')));
        return;
      }

      try {
        await FieldService.updateField(
          id: _createdFieldId!,
          description: _descriptionController.text.trim(),
          website: _websiteController.text.trim(),
          canShower: _canShower,
          hasParking: _hasParking,
          hasLighting: _hasLighting,
          openingTime: _openingTime,
          lunchBrakeStart: _lunchBrakeStart,
          lunchBrakeEnd: _lunchBrakeEnd,
          closingTime: _closingTime,
          price: _priceController.text.trim(),
          surfaceType: _surfaceType,
          areaType: _areaType,
          images: _images,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Field updated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating field: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _autocompleteCityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _autocompleteCityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _mailController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _priceController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: _currentPage == 0
        ? MandatoryFieldsForm(
          formKey: _formKeyMandatory,
          nameController: _nameController,
          autocompleteCityController: _autocompleteCityController,
          addressController: _addressController,
          phoneController: _phoneController,
          mailController: _mailController,
          isFree: _isFree,
          pitchType: _pitchType,
          onIsFreeChanged: _handleIsFreeChanged,
          onPitchTypeChanged: _handlePitchTypeChanged,
        )
        : OptionalFieldsForm(
          formKey: _formKeyOptional,
          descriptionController: _descriptionController,
          websiteController: _websiteController,
          canShower: _canShower,
          hasParking: _hasParking,
          hasLighting: _hasLighting,
          openingTime: _openingTime,
          lunchBrakeStart: _lunchBrakeStart,
          lunchBrakeEnd: _lunchBrakeEnd,
          closingTime: _closingTime,
          priceController: _priceController,
          surfaceType: _surfaceType,
          areaType: _areaType,
          images: _images,
          onCanShowerChanged: _handleCanShowerChanged,
          onHasParkingChanged: _handleHasParkingChanged,
          onHasLightingChanged: _handleHasLightiningChanged,
          onOpeningTimeChanged:_handleOpeningTimeChanged,
          onLunchBrakeStartChanged: _handleLunchBrakeStartChanged,
          onLunchBrakeEndChanged: _handleLunchBrakeEndChanged,
          onClosingTimeChanged: _handleClosingTimeChanged,
          onSurfaceTypeChanged: _handleSurfaceTypeChanged,
          onAreaTypeChanged: _handleAreaChanged,
          onAddImage: _handleAddImage,
      ),
      bottomNavigationBar: Row(
        children: [
          if(_currentPage == 1)
            TextButton(onPressed: _previousPage, child: Text('Back')),
          Spacer(),
          TextButton(onPressed: _nextPage, child: Text(_currentPage == 0 ? 'Continue' : 'Submit')),
        ],
      ),
    );
  }
}

