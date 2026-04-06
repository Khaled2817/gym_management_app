import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselItemModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color startColor;
  final Color endColor;
  final VoidCallback? onTap;

  const CarouselItemModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.startColor,
    required this.endColor,
    this.onTap,
  });
}

class CustomCarouselSlider extends StatefulWidget {
  final List<CarouselItemModel> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;
  final Duration animationDuration;
  final EdgeInsetsGeometry? margin;
  final double viewportFraction;
  final bool enlargeCenterPage;
  final bool showIndicator;
  final ValueChanged<int>? onPageChanged;

  const CustomCarouselSlider({
    super.key,
    required this.items,
    this.height = 220,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 350),
    this.margin,
    this.viewportFraction = 0.88,
    this.enlargeCenterPage = true,
    this.showIndicator = true,
    this.onPageChanged,
  });

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  bool get _canAutoPlay => widget.autoPlay && widget.items.length > 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    if (_canAutoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted || !_pageController.hasClients || widget.items.isEmpty) return;

      int nextPage = _currentIndex + 1;
      if (nextPage >= widget.items.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height.h,
          child: Listener(
            onPointerDown: (_) => _stopAutoPlay(),
            onPointerUp: (_) {
              if (_canAutoPlay) _startAutoPlay();
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double scale = 1.0;

                    if (_pageController.position.haveDimensions) {
                      final page = _pageController.page ?? _currentIndex.toDouble();
                      final diff = (page - index).abs();
                      scale = widget.enlargeCenterPage
                          ? (1 - (diff * 0.10)).clamp(0.90, 1.0)
                          : 1.0;
                    } else {
                      scale = index == _currentIndex ? 1.0 : 0.95;
                    }

                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: _CarouselCard(item: widget.items[index]),
                );
              },
            ),
          ),
        ),
        if (widget.showIndicator) ...[
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentIndex == index ? 22.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? Colors.blue
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final CarouselItemModel item;

  const _CarouselCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: item.onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.startColor,
                  item.endColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: item.endColor.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20.w,
                  top: -10.h,
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -30.w,
                  bottom: -30.h,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              item.subtitle,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.92),
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                ),
                              ),
                              child: Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          item.imagePath,
                          width: 110.w,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}