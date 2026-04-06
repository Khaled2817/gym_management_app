import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeaderActionItem {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badgeCount;

  const HeaderActionItem({required this.icon, this.onTap, this.badgeCount});
}

class HeaderTabItem {
  final Widget child;

  const HeaderTabItem({required this.child});

  factory HeaderTabItem.icon(IconData icon) {
    return HeaderTabItem(child: Tab(icon: Icon(icon)));
  }

  factory HeaderTabItem.widget(Widget widget) {
    return HeaderTabItem(child: widget);
  }
}

class CustomHeaderTabsScaffold extends StatefulWidget {
  final int length;
  final int homeTabIndex;
  final List<Widget> pages;

  final String title;
  final TextStyle? titleStyle;

  final List<HeaderActionItem> actions;
  final List<HeaderTabItem> tabs;

  final Color backgroundColor;
  final Color headerColor;
  final Color iconBackgroundColor;

  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final double indicatorWeight;

  final double headerHeight;
  final double tabsHeight;

  final Duration animationDuration;
  final Curve animationCurve;

  final ScrollController? homeScrollController;

  const CustomHeaderTabsScaffold({
    super.key,
    required this.length,
    required this.homeTabIndex,
    required this.pages,
    required this.title,
    required this.actions,
    required this.tabs,
    this.titleStyle,
    this.backgroundColor = const Color(0xFF18191A),
    this.headerColor = const Color(0xFF242526),
    this.iconBackgroundColor = const Color(0xFF3A3B3C),
    this.indicatorColor = Colors.white,
    this.labelColor = Colors.white,
    this.unselectedLabelColor = Colors.grey,
    this.indicatorWeight = 3,
    this.headerHeight = 60,
    this.tabsHeight = 50,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeInOut,
    this.homeScrollController,
  }) : assert(length == pages.length),
       assert(length == tabs.length);

  @override
  State<CustomHeaderTabsScaffold> createState() =>
      _CustomHeaderTabsScaffoldState();
}

class _CustomHeaderTabsScaffoldState extends State<CustomHeaderTabsScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _homeScrollController;

  bool showHomeHeader = true;

  bool get isHomeTab => _tabController.index == widget.homeTabIndex;

  double get fullHeaderHeight => widget.headerHeight + widget.tabsHeight;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.length, vsync: this)
      ..addListener(_handleTabChange);

    _homeScrollController = widget.homeScrollController ?? ScrollController()
      ..addListener(_handleHomeScroll);
  }

  void _handleTabChange() {
    if (!mounted) return;

    setState(() {
      if (_tabController.index == widget.homeTabIndex) {
        showHomeHeader = true;
      }
    });
  }

  void _handleHomeScroll() {
    if (!mounted) return;
    if (!isHomeTab) return;
    if (!_homeScrollController.hasClients) return;

    final position = _homeScrollController.position;
    final direction = position.userScrollDirection;
    final offset = position.pixels;

    if (offset <= 0) {
      if (!showHomeHeader) {
        setState(() => showHomeHeader = true);
      }
      return;
    }

    if (direction == ScrollDirection.reverse) {
      if (showHomeHeader) {
        setState(() => showHomeHeader = false);
      }
    }

    if (direction == ScrollDirection.forward) {
      if (!showHomeHeader) {
        setState(() => showHomeHeader = true);
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();

    if (widget.homeScrollController == null) {
      _homeScrollController
        ..removeListener(_handleHomeScroll)
        ..dispose();
    } else {
      _homeScrollController.removeListener(_handleHomeScroll);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showAnimatedHomeHeader = isHomeTab && showHomeHeader;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (isHomeTab)
              ClipRect(
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  curve: widget.animationCurve,
                  height: showAnimatedHomeHeader ? fullHeaderHeight : 0,
                  child: SizedBox(
                    height: fullHeaderHeight,
                    child: Column(
                      children: [
                        SizedBox(
                          height: widget.headerHeight,
                          child: _CustomTopHeader(
                            title: widget.title,
                            titleStyle: widget.titleStyle,
                            actions: widget.actions,
                            headerColor: widget.headerColor,
                            iconBackgroundColor: widget.iconBackgroundColor,
                          ),
                        ),
                        SizedBox(
                          height: widget.tabsHeight,
                          child: _CustomTopTabs(
                            controller: _tabController,
                            tabs: widget.tabs,
                            headerColor: widget.headerColor,
                            indicatorColor: widget.indicatorColor,
                            labelColor: widget.labelColor,
                            unselectedLabelColor: widget.unselectedLabelColor,
                            indicatorWeight: widget.indicatorWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (!isHomeTab)
              SizedBox(
                height: widget.tabsHeight,
                child: _CustomTopTabs(
                  controller: _tabController,
                  tabs: widget.tabs,
                  headerColor: widget.headerColor,
                  indicatorColor: widget.indicatorColor,
                  labelColor: widget.labelColor,
                  unselectedLabelColor: widget.unselectedLabelColor,
                  indicatorWeight: widget.indicatorWeight,
                ),
              ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(widget.pages.length, (index) {
                  if (index == widget.homeTabIndex) {
                    return PrimaryScrollController(
                      controller: _homeScrollController,
                      child: widget.pages[index],
                    );
                  }
                  return widget.pages[index];
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTopHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final List<HeaderActionItem> actions;
  final Color headerColor;
  final Color iconBackgroundColor;

  const _CustomTopHeader({
    required this.title,
    required this.actions,
    required this.headerColor,
    required this.iconBackgroundColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            title,
            style:
                titleStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
          ),
          const Spacer(),
          ...List.generate(actions.length, (index) {
            final item = actions[index];
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
              child: _HeaderActionButton(
                icon: item.icon,
                badgeCount: item.badgeCount,
                onTap: item.onTap,
                backgroundColor: iconBackgroundColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int? badgeCount;
  final Color backgroundColor;

  const _HeaderActionButton({
    required this.icon,
    required this.backgroundColor,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 21),
          ),
          if (badgeCount != null)
            Positioned(
              right: -2,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomTopTabs extends StatelessWidget {
  final TabController controller;
  final List<HeaderTabItem> tabs;
  final Color headerColor;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final double indicatorWeight;

  const _CustomTopTabs({
    required this.controller,
    required this.tabs,
    required this.headerColor,
    required this.indicatorColor,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.indicatorWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerColor,
      child: TabBar(
        controller: controller,
        indicatorColor: indicatorColor,
        indicatorWeight: indicatorWeight,
        dividerColor: Colors.transparent,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        tabs: tabs.map((e) => e.child).toList(),
      ),
    );
  }
}

class HeaderDemoListPage extends StatelessWidget {
  final String title;
  final ScrollController? controller;

  const HeaderDemoListPage({super.key, required this.title, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller ?? PrimaryScrollController.of(context),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF242526),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$title Item ${index + 1}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      },
    );
  }
}

/*
class FacebookHomePage extends StatelessWidget {
  const FacebookHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomHeaderTabsScaffold(
      length: 6,
      homeTabIndex: 5,
      title: 'facebook',
      actions: const [
        HeaderActionItem(
          icon: Icons.chat_bubble_outline,
          badgeCount: 3,
        ),
        HeaderActionItem(icon: Icons.search),
        HeaderActionItem(icon: Icons.add),
        HeaderActionItem(icon: Icons.menu),
      ],
      tabs: const [
        HeaderTabItem.icon(Icons.account_circle_outlined),
        HeaderTabItem.icon(Icons.notifications_none),
        HeaderTabItem.icon(Icons.storefront_outlined),
        HeaderTabItem.icon(Icons.group_outlined),
        HeaderTabItem.icon(Icons.ondemand_video_outlined),
        HeaderTabItem.icon(Icons.home_filled),
      ],
      pages: const [
        HeaderDemoListPage(title: 'Profile'),
        HeaderDemoListPage(title: 'Notifications'),
        HeaderDemoListPage(title: 'Store'),
        HeaderDemoListPage(title: 'Groups'),
        HeaderDemoListPage(title: 'Videos'),
        HeaderDemoListPage(title: 'Home'),
      ],
    );
  }
}

*/
