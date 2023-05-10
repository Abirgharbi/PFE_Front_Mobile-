import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Help Center',
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Q: How do I use the AR feature?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'A: To use the AR feature, follow these steps:\n'
              '1. Find a product you want to visualize using AR.\n'
              '2. Tap the AR button on the product page.\n'
              '3. Grant the necessary permissions to access your device camera.\n'
              '4. Move your device around to scan the environment.\n'
              '5. Place the virtual product in your desired location.\n'
              '6. You can resize or rotate the product for a better fit.\n'
              '7. Enjoy visualizing the product in augmented reality!',
            ),
            SizedBox(height: 16.0),
            Text(
              'Q: How can I contact customer support?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'A: If you have any questions or need assistance, please contact our customer support team at arkea.contact@gmail.com.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Q: Can I return or exchange products?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'A: Yes, we have a hassle-free return and exchange policy. If you are not satisfied with your purchase, you can initiate a return or exchange within 30 days of the purchase date.',
            ),
            // Add more frequently asked questions and answers as needed
          ],
        ),
      ),
    );
  }
}
