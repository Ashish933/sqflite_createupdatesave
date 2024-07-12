// create_profile_page.dart
import 'package:flutter/material.dart';
import 'data_base.dart';
import 'json_profile.dart';
import 'profile page.dart';

const List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedBloodGroup;

  final DatabaseHelper dbHelper = DatabaseHelper();

  void _saveProfile() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String? bloodGroup = _selectedBloodGroup;

    if (name.isNotEmpty && email.isNotEmpty) {
      Profile newProfile = Profile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        bloodGroup: bloodGroup,
      );

      int id = await dbHelper.saveProfile(newProfile);
      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(profileId: id)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter name and email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedBloodGroup,
              decoration: InputDecoration(labelText: 'Blood Group'),
              items: bloodGroups
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodGroup = value!;
                });
              },
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
