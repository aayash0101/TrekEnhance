import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../view_model/user_profile_event.dart';
import '../view_model/user_profile_state.dart';
import '../view_model/user_profile_view_model.dart';

class EditUserProfileView extends StatefulWidget {
  final UserEntity user;

  const EditUserProfileView({super.key, required this.user});

  @override
  State<EditUserProfileView> createState() => _EditUserProfileViewState();
}

class _EditUserProfileViewState extends State<EditUserProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  File? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _locationController = TextEditingController(text: widget.user.location ?? '');
    _uploadedImageUrl = widget.user.profileImageUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProfileVM = context.read<UserProfileViewModel>();

      if (_selectedImage != null) {
        // 1. Upload image first
        userProfileVM.add(UploadProfilePicture(_selectedImage!.path));

        // Listen once for upload completion to get URL and then update profile
        await userProfileVM.stream.firstWhere((state) =>
            state is UserProfileLoaded || state is UserProfileError);

        final currentState = userProfileVM.state;
        if (currentState is UserProfileLoaded) {
          _uploadedImageUrl = currentState.user.profileImageUrl;
        } else if (currentState is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(currentState.message)),
          );
          return; // Stop if upload failed
        }
      }

      // 2. Update profile with username, bio, location, and uploadedImageUrl
      userProfileVM.add(
        UpdateUserProfile(
          username: _usernameController.text.trim(),
          bio: _bioController.text.trim(),
          location: _locationController.text.trim(),
          profileImageUrl: _uploadedImageUrl,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileViewModel, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLoading || state is UserProfilePictureUploading) {
          // Show loading overlay
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          // Close loading overlay if open
          if (Navigator.canPop(context)) Navigator.pop(context);
        }

        if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserProfileLoaded) {
          // After successful save, close and return true
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal[100],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty)
                                ? NetworkImage(_uploadedImageUrl!) as ImageProvider
                                : null,
                        child: (_selectedImage == null &&
                                (_uploadedImageUrl == null || _uploadedImageUrl!.isEmpty))
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.teal,
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  validator: (v) => v == null || v.isEmpty ? 'Username is required' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.teal,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }
}
