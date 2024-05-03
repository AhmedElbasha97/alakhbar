import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NetworkErrorItem extends StatelessWidget {
  const NetworkErrorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height, //Get.height = MediaQuery.of(context).size.height
        width: Get.width, //Get.width = MediaQuery.of(context).size.width
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Here I am using an svg icon
            SvgPicture.asset(
              'assets/icons/network.svg',
              width: 200,
              height: 200,

            ),
            const SizedBox(height: 30),
            const Text(
              'Internet connection lost!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              'Check your connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
