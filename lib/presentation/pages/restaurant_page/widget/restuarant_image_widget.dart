import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class RestaurantImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Function? onTap;

  const RestaurantImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ImageNetwork(
      image: imageUrl,
      width: width??100,
      height: height??100,
      duration: 1000,
      curve: Curves.easeIn,
      onPointer: true,
      debugPrint: false,
      fullScreen: false,
      // fitAndroidIos: fit,
      fitWeb: BoxFitWeb.cover,
      borderRadius: BorderRadius.zero,
      onLoading: Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      onError: Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 50,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        onTap;
      },
    );
  }
}
