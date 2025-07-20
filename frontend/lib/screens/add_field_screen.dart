import 'dart:io';

import 'package:flutter/material.dart';

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
    if(_currentPage < 1) {
      _pageController.animateToPage(_currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _previousPage() {
    if(_currentPage > 0) {
      _pageController.animateToPage(_currentPage - 1, duration: Duration(milliseconds: 300), curve: Curves.ease);
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
    _autocompleteCityController.dispose();
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

