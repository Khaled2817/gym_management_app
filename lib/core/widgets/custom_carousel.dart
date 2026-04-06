// import 'package:flutter/material.dart';
// import 'custom_carousel.dart';

// class CarouselExamplePage extends StatelessWidget {
//   CarouselExamplePage({super.key});

//   final List<String> images = [
//     'https://picsum.photos/id/1011/800/400',
//     'https://picsum.photos/id/1015/800/400',
//     'https://picsum.photos/id/1018/800/400',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Custom Carousel')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: CustomCarousel<String>(
//           items: images,
//           height: 220,
//           autoPlay: true,
//           viewportFraction: 0.92,
//           borderRadius: BorderRadius.circular(20),
//           itemBuilder: (context, image, index) {
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.network(
//                   image,
//                   fit: BoxFit.cover,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         Colors.black.withValues(alpha: 0.5),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: 16,
//                   bottom: 16,
//                   child: Text(
//                     'Banner ${index + 1}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /*
// CustomCarousel<YourModel>(
//   items: yourList,
//   itemBuilder: (context, item, index) {
//     return YourWidget(item: item);
//   },
// )
// */