import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../controllers/users_controller.dart';

/// User detail page
class UserDetailPage extends GetView<UsersController> {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
    final user = controller.getUserById(userId);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Not Found')),
        body: const Center(child: Text('User not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User Details'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeader(user),
            const SizedBox(height: 24),

            // Contact Information
            _buildSection(
              title: 'Contact Information',
              children: [
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email,
                ),
                if (user.phoneNumber != null)
                  _buildInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phoneNumber!,
                  ),
                if (user.website != null)
                  _buildInfoRow(
                    icon: Icons.language_outlined,
                    label: 'Website',
                    value: user.website!,
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Address Information
            if (user.address != null) ...[
              _buildSection(
                title: 'Address',
                children: [
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Full Address',
                    value: user.formattedAddress,
                  ),
                  if (user.address!.geo != null)
                    _buildInfoRow(
                      icon: Icons.map_outlined,
                      label: 'Coordinates',
                      value:
                          'Lat: ${user.address!.geo!.lat}, Lng: ${user.address!.geo!.lng}',
                    ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // Company Information
            if (user.company != null) ...[
              _buildSection(
                title: 'Company',
                children: [
                  _buildInfoRow(
                    icon: Icons.business_outlined,
                    label: 'Name',
                    value: user.companyInfo,
                  ),
                  if (user.company!.catchPhrase != null)
                    _buildInfoRow(
                      icon: Icons.format_quote_outlined,
                      label: 'Catch Phrase',
                      value: user.company!.catchPhrase!,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserEntity user) {
    final initials = user.name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '@${user.username}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
