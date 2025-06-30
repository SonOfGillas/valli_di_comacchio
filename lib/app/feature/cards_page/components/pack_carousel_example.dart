import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/pack_courosel.dart';

class PackCarouselExample extends StatefulWidget {
  const PackCarouselExample({Key? key}) : super(key: key);

  @override
  State<PackCarouselExample> createState() => _PackCarouselExampleState();
}

class _PackCarouselExampleState extends State<PackCarouselExample> {
  int _selectedPackIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text('Card Pack Carousel'),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Selected Pack Info
          Center(
            child: Text(
              'Selected Pack: ${_selectedPackIndex + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3D Pack Carousel
          Expanded(
            child: PackCarousel(
              packCount: 8,
              onPackSelected: (index) {
                setState(() {
                  _selectedPackIndex = index;
                });
                // You can trigger pack opening animation here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pack ${index + 1} selected!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Open Pack Button
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Implement pack opening logic
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Opening Pack ${_selectedPackIndex + 1}'),
                    content: const Text(
                        'This would show an animation of cards being revealed!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('OPEN PACK'),
            ),
          ),
        ],
      ),
    );
  }
}
