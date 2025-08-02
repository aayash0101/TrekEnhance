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
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<UserProfileViewModel, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return _buildLoadingState();
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return _buildProfileView(context, user);
            } else if (state is UserProfilePictureUploading) {
              return _buildUploadingState();
            } else if (state is UserProfileError) {
              return _buildErrorState(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[600]!),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading profile...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[600]!),
            ),
            const SizedBox(height: 16),
            Text(
              'Uploading picture...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<UserProfileViewModel>().add(LoadUserProfile(userId));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
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

    return CustomScrollView(
      slivers: [
        // Custom App Bar with Profile Header
        SliverAppBar(
          expandedHeight: 300,
          floating: false,
          pinned: true,
          backgroundColor: Colors.teal[600],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.teal[400]!,
                    Colors.teal[600]!,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Space for app bar
                    // Profile Picture with Upload Overlay
                    Stack(
                      children: [
                        Hero(
                          tag: 'profile_picture_$userId',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: fullImageUrl != null 
                                  ? NetworkImage(fullImageUrl) 
                                  : null,
                              child: fullImageUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.teal[600],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Builder(
                            builder: (innerContext) {
                              return GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserProfileViewModel>(innerContext)
                                      .pickAndUploadProfilePicture();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.teal[600],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Profile Content
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Information Section
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Bio Card
                  _buildInfoCard(
                    icon: Icons.info_outline,
                    title: 'Bio',
                    content: user.bio ?? 'No bio available',
                    isEmpty: user.bio == null || user.bio!.isEmpty,
                  ),
                  const SizedBox(height: 16),
                  
                  // Location Card
                  _buildInfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    content: user.location ?? 'No location set',
                    isEmpty: user.location == null || user.location!.isEmpty,
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Edit Profile Button
                  Builder(
                    builder: (innerContext) {
                      return Container(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
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
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: Colors.teal.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Upload Picture Button
                  Builder(
                    builder: (innerContext) {
                      return Container(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            BlocProvider.of<UserProfileViewModel>(innerContext)
                                .pickAndUploadProfilePicture();
                          },
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: const Text(
                            'Change Profile Picture',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal[600],
                            side: BorderSide(color: Colors.teal[600]!, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    bool isEmpty = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEmpty ? Colors.grey[200]! : Colors.teal[100]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEmpty ? Colors.grey[100] : Colors.teal[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isEmpty ? Colors.grey[400] : Colors.teal[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isEmpty ? Colors.grey[500] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: isEmpty ? Colors.grey[400] : Colors.black87,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}