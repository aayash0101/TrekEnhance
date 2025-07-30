import 'package:flutter/material.dart';
import 'package:flutter_application_trek_e/app/service_locator/service_locator.dart';
import 'package:flutter_application_trek_e/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view/edit_user_profile_view.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_event.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_state.dart';
import 'package:flutter_application_trek_e/features/profile/presentation/view_model/user_profile_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entity/user_entity.dart';

class UserProfileView extends StatelessWidget {
  final String userId;

  const UserProfileView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserProfileViewModel(serviceLocator<IUserRepository>())..add(LoadUserProfile(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<UserProfileViewModel, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return _buildProfileView(context, user);
            } else if (state is UserProfilePictureUploading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, UserEntity user) {
    // Build full image URL if profileImageUrl is set
    final imageUrl = user.profileImageUrl;
    final fullImageUrl = (imageUrl != null && imageUrl.isNotEmpty)
        ? "http://10.0.2.2:5000/uploads/$imageUrl"
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            backgroundImage: fullImageUrl != null ? NetworkImage(fullImageUrl) : null,
            child: fullImageUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            user.username,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(user.email, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          _buildInfoTile('Bio', user.bio ?? 'No bio'),
          _buildInfoTile('Location', user.location ?? 'No location'),
          const SizedBox(height: 20),

          // Edit profile button
          Builder(
            builder: (innerContext) {
              return ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    innerContext,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<UserProfileViewModel>(innerContext),
                        child: EditUserProfileView(user: user),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // Upload profile picture button
          Builder(
            builder: (innerContext) {
              return ElevatedButton.icon(
                onPressed: () {
                  BlocProvider.of<UserProfileViewModel>(innerContext).pickAndUploadProfilePicture();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Upload Picture'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  backgroundColor: Colors.teal,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String content) {
    return ListTile(
      leading: Icon(
        title == 'Bio' ? Icons.info : Icons.location_on,
        color: Colors.teal,
      ),
      title: Text(title),
      subtitle: Text(content),
    );
  }
}
