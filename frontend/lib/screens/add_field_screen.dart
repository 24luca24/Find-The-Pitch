import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/services/field_service.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/area_type.dart';
import '../constants/pitch_type.dart';
import '../constants/surface_type.dart';
import '../design/add_field_design.dart';
import '../services/auth_service.dart';

class AddFieldScreen extends StatefulWidget {
  const AddFieldScreen({super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {

  //Holds ID of created field from backend. Useful to store than images because they need a field reference
  String? _createdFieldId;

  //Handle page management (Add field has 2 page, one with mandatory fields, one with optional ones)
  late PageController _pageController = PageController();
  int _currentPage = 0;

  //Validate form input for each step
  final _formKeyMandatory = GlobalKey<FormState>();
  final _formKeyOptional = GlobalKey<FormState>();

  //Mandatory Fields (_ means private)
  final _nameController = TextEditingController();
  late final TextEditingController _autocompleteCityController;
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
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
  final List<File> _images = [];

  //Method to change page: move from step 1 to step 2 if form is valid and submit everything if already on step 2
  Future<void> _nextPage() async {
    if (_currentPage == 0) {
      final success = await _continueFromMandatoryFields();
      if (success) {
        setState(() {
          _currentPage = 1;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  //Function to validate the first part of the form and create a field
  //Stores the created field's ID needed for uploading images in step 2
  Future<bool> _continueFromMandatoryFields() async {
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
        });

        return true; //success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating field: $e')),
        );
        return false; //failure
      }
    }
    return false; //form validation failed
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

  //Method to go from step 2 to step 1
  void _previousPage() {
    if (_currentPage == 1) {
      setState(() {
        _currentPage = 0;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  //STATE UPDATE HANDLERS

    //PitchType
    void _handlePitchTypeChanged(PitchType? newValue) {
      setState(() {
        _pitchType = newValue;
      });
    }

    //Is Free
    void _handleIsFreeChanged(bool? value) {
      if (value != null) {
        setState(() {
          _isFree = value;
        });
      }
    }

    //Can shower
    void _handleCanShowerChanged(bool? value) {
      if(value != null) {
        setState(() {
          _canShower = value;
        });
      }
    }

    //Has parking
    void _handleHasParkingChanged(bool? value) {
      if (value != null) {
        setState(() {
          _hasParking = value;
        });
      }
    }

    //Has lightning
    void _handleHasLightningChanged(bool? value) {
      if (value != null) {
        setState(() {
          _hasLighting = value;
        });
      }
    }

    //Opening time
    void _handleOpeningTimeChanged(TimeOfDay? newTime) {
      if (newTime != null) {
        setState(() {
          _openingTime = newTime;
        });
      }
    }

    //Lunch brake start
    void _handleLunchBrakeStartChanged(TimeOfDay? newTime) {
      if (newTime != null) {
        setState(() {
          _lunchBrakeStart = newTime;
        });
      }
    }

    //Lunch brake end
    void _handleLunchBrakeEndChanged(TimeOfDay? newTime) {
      if (newTime != null) {
        setState(() {
          _lunchBrakeEnd = newTime;
        });
      }
    }

    //Closing time
    void _handleClosingTimeChanged(TimeOfDay? newTime) {
      if (newTime != null) {
        setState(() {
          _closingTime = newTime;
        });
      }
    }

    //Surface type
    void _handleSurfaceTypeChanged(SurfaceType? value) {
      if(value != null) {
        setState(() {
          _surfaceType = value;
        });
      }
    }

    //Area
    void _handleAreaChanged(AreaType? value) {
      if(value != null) {
        setState(() {
          _areaType = value;
        });
      }
    }

    //Image picker to let the user select a photo
    void _handleAddImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    }

  //Function to autocomplete the city form. Gets city suggestion from AuthService.fetchCitySuggestions(query)
  //Syncs the selected value to _cityController
  Widget _buildAutocompleteCityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 90,
            height: 16,
            child: Text(
              "City:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return await AuthService.fetchCitySuggestions(
                    textEditingValue.text);
              },
              onSelected: (String selection) {
                _autocompleteCityController.text = selection;
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                //One-way sync: _cityController updates from user edits
                if (textEditingController.text != _autocompleteCityController.text) {
                  textEditingController.text = _autocompleteCityController.text;
                  textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textEditingController.text.length),
                  );
                }

                textEditingController.addListener(() {
                  if (_autocompleteCityController.text != textEditingController.text) {
                    _autocompleteCityController.text = textEditingController.text;
                  }
                });

                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: _validateCity,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //Method to validate city field
  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) return 'City required';
    return null;
  }

  //Initialize elements
  @override
  void initState() {
    super.initState();
    _autocompleteCityController = TextEditingController();
    _pageController = PageController();
  }

  //Release resources of used elements
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 0: Mandatory Fields Form
          MandatoryFieldsForm(
            formKey: _formKeyMandatory,
            nameController: _nameController,
            autocompleteCityController: _autocompleteCityController,
            autocompleteCityFieldBuilder: _buildAutocompleteCityField,
            addressController: _addressController,
            phoneController: _phoneController,
            mailController: _mailController,
            isFree: _isFree,
            pitchType: _pitchType,
            onIsFreeChanged: _handleIsFreeChanged,
            onPitchTypeChanged: _handlePitchTypeChanged,
            onContinuePressed: _nextPage,
            onBackPressed: _previousPage,
            customCityField: _buildAutocompleteCityField(),
          ),

          // Page 1: Optional Fields Form
          OptionalFieldsForm(
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
            onHasLightingChanged: _handleHasLightningChanged,
            onOpeningTimeChanged: _handleOpeningTimeChanged,
            onLunchBrakeStartChanged: _handleLunchBrakeStartChanged,
            onLunchBrakeEndChanged: _handleLunchBrakeEndChanged,
            onClosingTimeChanged: _handleClosingTimeChanged,
            onSurfaceTypeChanged: _handleSurfaceTypeChanged,
            onAreaTypeChanged: _handleAreaChanged,
            onAddImage: _handleAddImage,
          ),
        ],
      ),
    );
  }
}

