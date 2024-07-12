import 'package:flutter/material.dart';
import 'data_base.dart';
import 'edit_profile.dart';
import 'json_profile.dart';

class ProfilePage extends StatelessWidget {
  final int profileId;

  ProfilePage({required this.profileId});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Profile?>(
        future: dbHelper.getProfile(profileId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Profile not found'));
          } else {
            Profile profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${profile.name}', style: TextStyle(fontSize: 18)),
                  Text('Email: ${profile.email}', style: TextStyle(fontSize: 18)),
                  Text('Phone: ${profile.phone}', style: TextStyle(fontSize: 18)),
                  Text('Address: ${profile.address}', style: TextStyle(fontSize: 18)),
                  Text('Blood Group: ${profile.bloodGroup}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(profile: profile),
                          ),
                        ).then((_) {
                          (context as Element).reassemble();
                        });
                      },
                      child: Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
