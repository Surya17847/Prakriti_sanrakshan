import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prakriti_svanrakshan/screens/auth/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _name = "ABC";
  String? _email = "abc123@google.com";
  final ImagePicker _picker = ImagePicker();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadProfileImageFromPrefs();
  }

  Future<void> _loadProfileData() async {
    if (user != null) {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      if (doc.exists) {
        setState(() {
          _name = doc['name'] ?? user!.displayName ?? "No Name";
          _email = doc['email'] ?? user!.email ?? "No Email";
        });
      } else {
        // Save basic data if new user
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'name': user!.displayName ?? '',
          'email': user!.email ?? '',
          'photoUrl': user!.photoURL ?? '',
        });

        setState(() {
          _name = user!.displayName ?? "No Name";
          _email = user!.email ?? "No Email";
        });
      }
    }
  }

  Future<void> _loadProfileImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');

    if (path != null && File(path).existsSync()) {
      setState(() {
        _profileImage = File(path);
      });
    }
  }

  Future<void> _saveProfileImageToPrefs(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _profileImage = imageFile;
      });
      await _saveProfileImageToPrefs(imageFile.path);

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles/${user?.uid}/profile_picture.png');
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'photoUrl': downloadUrl});
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose a photo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Take a photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700),
          SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Gradient Header
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Profile Content
            Column(
              children: [
                SizedBox(height: 60),

                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: () => _showImageSourceDialog(context),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/images/profile_image.jpg'))
                      as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Name
                Text(
                  _name ?? "User",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),

                // Email
                Text(
                  _email ?? "email@example.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 30),

                // Profile Details Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.cake, "Age", "21"),
                      Divider(),
                      _buildDetailRow(Icons.location_on, "Location", "Mumbai, India"),
                      Divider(),
                      _buildDetailRow(Icons.nature, "Trees Planted", "10"),
                      Divider(),
                      _buildDetailRow(Icons.eco, "CO₂ Saved", "18 kg"),
                      Divider(),
                      _buildDetailRow(Icons.health_and_safety, "Health", "Healthy"),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: Icon(Icons.logout),
                  label: Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
