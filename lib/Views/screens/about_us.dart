import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About Us',
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to Arkea',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Arkea is an AR-commerce application designed to enhance your shopping experience by integrating augmented reality (AR) technology. With Arkea, you can visualize products in your environment in real-time using your smartphone or tablet.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Our Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Augmented Reality (AR) product visualization',
            ),
            Text(
              '- Seamless product browsing and searching',
            ),
            Text(
              '- Amazing user shopping experience',
            ),
            Text(
              '- Secure and convenient online shopping experience',
            ),
            SizedBox(height: 16.0),
            Text(
              'We strive to provide you with the best AR-commerce experience. Thank you for choosing Arkea!',
            ),
          ],
        ),
      ),
    );
  }
}
