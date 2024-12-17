import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Map<String, String>? userData;

  ProfileSetupScreen({required this.userData});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthdateController = TextEditingController();

  XFile? profileAvatarImage;
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _birthDay;
  String? _profilePicture;
  String? _gender; // Added gender field

  // Image Picker to select profile picture
  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        profileAvatarImage = image;
        _profilePicture = base64Encode(bytes);
      });
    }
  }

  // Combine user data and send POST request
  Future<void> _saveProfileData() async {
    final data = {
      ...?widget.userData,
      'firstName': _firstName ?? '',
      'lastName': _lastName ?? '',
      'phoneNumber': _phoneNumber ?? '',
      'birthDay': _birthDay ?? '',
      'gender': _gender ?? '',
      'profilePicture': _profilePicture ?? '',
    };

    final url = Uri.parse('https://wassalni-maak.onrender.com/user/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/success');
      } else {
        _showError('Failed to save profile. Try again.');
      }
    } catch (e) {
      _showError('An error occurred. Please check your connection.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: profileAvatarImage != null
                        ? FileImage(File(profileAvatarImage!.path))
                        : null,
                    child: profileAvatarImage == null
                        ? Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  onChanged: (value) => _firstName = value,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  onChanged: (value) => _lastName = value,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _birthdateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _birthDay = DateFormat('yyyy-MM-dd').format(pickedDate);
                        _birthdateController.text = _birthDay!;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select your gender' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _phoneNumber = value,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProfileData();
                    }
                  },
                  child: Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
