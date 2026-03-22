import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/users_controller.dart';
import '../widgets/user_list_item.dart';

/// Colorful user detail page
class UserDetailPage extends GetView<UsersController> {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
    final user = controller.getUserById(userId);

    if (user == null) {
      return _buildNotFoundState();
    }

    final gradientColors = AvatarGradients.getGradient(user.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Colorful App Bar
          _buildSliverAppBar(user, gradientColors),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Contact Information Card
                _buildContactCard(user, gradientColors),
                const SizedBox(height: 20),

                // Address Information Card
                if (user.address != null)
                  _buildAddressCard(user, gradientColors),

                if (user.address != null) const SizedBox(height: 20),

                // Company Information Card
                if (user.company != null)
                  _buildCompanyCard(user, gradientColors),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Not Found'),
        backgroundColor: AppColors.error,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off, size: 80, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'User Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(UserEntity user, List<Color> gradientColors) {
    final initials = user.name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Avatar and name
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: gradientColors,
                          ).createShader(bounds),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '@${user.username}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(UserEntity user, List<Color> gradientColors) {
    return _buildInfoCard(
      title: 'Contact Information',
      icon: Icons.contact_mail,
      gradientColors: [AppColors.primaryLight, AppColors.primary],
      children: [
        _buildInfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: user.email,
          color: AppColors.primary,
        ),
        if (user.phoneNumber != null)
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: user.phoneNumber!,
            color: AppColors.secondary,
          ),
        if (user.website != null)
          _buildInfoRow(
            icon: Icons.language_outlined,
            label: 'Website',
            value: user.website!,
            color: AppColors.accent2,
          ),
      ],
    );
  }

  Widget _buildAddressCard(UserEntity user, List<Color> gradientColors) {
    return _buildInfoCard(
      title: 'Address',
      icon: Icons.location_on,
      gradientColors: [AppColors.secondaryLight, AppColors.secondary],
      children: [
        _buildInfoRow(
          icon: Icons.home_outlined,
          label: 'Street',
          value: user.address?.street ?? 'N/A',
          color: AppColors.secondary,
        ),
        if (user.address?.city != null)
          _buildInfoRow(
            icon: Icons.location_city,
            label: 'City',
            value: '${user.address?.city}, ${user.address?.zipCode ?? ''}',
            color: AppColors.primary,
          ),
        if (user.address?.geo != null)
          _buildInfoRow(
            icon: Icons.map_outlined,
            label: 'Coordinates',
            value: '${user.address?.geo?.lat}, ${user.address?.geo?.lng}',
            color: AppColors.accent3,
          ),
      ],
    );
  }

  Widget _buildCompanyCard(UserEntity user, List<Color> gradientColors) {
    return _buildInfoCard(
      title: 'Company',
      icon: Icons.business,
      gradientColors: [AppColors.accent1, AppColors.accent2],
      children: [
        _buildInfoRow(
          icon: Icons.business_center,
          label: 'Company Name',
          value: user.company?.name ?? 'N/A',
          color: AppColors.accent1,
        ),
        if (user.company?.catchPhrase != null)
          _buildInfoRow(
            icon: Icons.format_quote,
            label: 'Catch Phrase',
            value: user.company!.catchPhrase!,
            color: AppColors.accent2,
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
