import 'package:acadly/utils/variable.dart';
import 'package:flutter/material.dart';
import '../../common/theme/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
        elevation: 3,
        shadowColor: Colors.black26,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar( radius: 80,
                backgroundImage: AssetImage( (person[0]['photoURL'] != null && (person[0]['photoURL'] as String).isNotEmpty) ?
                person[0]['photoURL'] as String : 'assets/img.png',
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoCard(person[0]['Username'] as String, context),
              const SizedBox(height: 20),
              _buildInfoCard(person[0]['Regno'] as String, context),
              const SizedBox(height: 20),
              _buildInfoCard(person[0]['branch'] as String, context),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.accent,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Text(
                      'Change Password',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

              ),
              const SizedBox(height: 30),
              const Text('Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              const Text('Contact',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent, width: 1.2),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
