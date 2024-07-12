// edit_profile_page.dart
import 'package:flutter/material.dart';
import 'data_base.dart';
import 'json_profile.dart';
import 'profile page.dart';

const List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  EditProfilePage({required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _selectedBloodGroup;

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _addressController = TextEditingController(text: widget.profile.address);
    _selectedBloodGroup = widget.profile.bloodGroup;
  }

  void _updateProfile() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String? bloodGroup = _selectedBloodGroup;

    if (name.isNotEmpty && email.isNotEmpty) {
      Profile updatedProfile = Profile(
        id: widget.profile.id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        bloodGroup: bloodGroup,
      );

      int result = await dbHelper.updateProfile(updatedProfile);
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(profileId: updatedProfile.id!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
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
        title: Text('Edit Profile'),
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
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
