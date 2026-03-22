import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';

/// Vibrant gradient colors for avatars
class AvatarGradients {
  static const List<List<Color>> gradients = [
    [Color(0xFF6C63FF), Color(0xFF4A44CC)], // Purple
    [Color(0xFF00BFA6), Color(0xFF008C7A)], // Teal
    [Color(0xFFFF6584), Color(0xFFE91E63)], // Pink
    [Color(0xFFFFA726), Color(0xFFFF6F00)], // Orange
    [Color(0xFF42A5F5), Color(0xFF1976D2)], // Blue
    [Color(0xFFAB47BC), Color(0xFF7B1FA2)], // Purple Dark
    [Color(0xFF26A69A), Color(0xFF00796B)], // Teal Dark
    [Color(0xFFFF7043), Color(0xFFE64A19)], // Deep Orange
    [Color(0xFF5C6BC0), Color(0xFF303F9F)], // Indigo
    [Color(0xFFEC407A), Color(0xFFC2185B)], // Pink Dark
  ];

  static List<Color> getGradient(int index) {
    return gradients[index % gradients.length];
  }
}

/// Widget for displaying a user in the list with colorful decoration
class UserListItem extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;

  const UserListItem({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradientColors = AvatarGradients.getGradient(user.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: gradientColors[0].withOpacity(0.1),
          highlightColor: gradientColors[0].withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: gradientColors[0].withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Animated Avatar
                _buildAnimatedAvatar(gradientColors),
                const SizedBox(width: 16),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with gradient effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: gradientColors,
                        ).createShader(bounds),
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Username with colored badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '@${user.username}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email with icon
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: gradientColors[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.email_outlined,
                              size: 12,
                              color: gradientColors[0],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      if (user.phoneNumber != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: gradientColors[1].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.phone_outlined,
                                size: 12,
                                color: gradientColors[1],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                user.phoneNumber!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow with gradient
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientColors[0].withOpacity(0.1),
                        gradientColors[1].withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: gradientColors[0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAvatar(List<Color> gradientColors) {
    final initials = user.name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
