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
    // Optional: build full profile image URL if you have profileImageUrl field
    // final fullImageUrl = user.profileImageUrl != null
    //     ? "http://10.0.2.2:5000${user.profileImageUrl}"
    //     : null;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            // If you have profileImageUrl, replace child with backgroundImage
            // backgroundImage: fullImageUrl != null ? NetworkImage(fullImageUrl) : null,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
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
