import 'package:food_app/data/cars_data.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:food_app/utilities/fucntions.dart';
import 'package:food_app/widgets/car_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    showBottomNavRail(false);
  }

  int activeIndex = 0;

  bool fromBack = false;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                color: Colors.pink.shade600,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.pink.shade900,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Hottest",
                          // style: TextStyle(color: Colors.red, fontSize: 24),
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 450,
                        width: double.maxFinite,
                        child: Swiper(
                          onIndexChanged: (value) {
                            if (value > activeIndex) {
                              _pageController.nextPage(
                                  duration: 400.milliseconds, curve: Curves.decelerate);
                              fromBack = false;
                            }
                            if (value < activeIndex) {
                              _pageController.previousPage(
                                  duration: 400.ms, curve: Curves.decelerate);
                              fromBack = true;
                            }
                            activeIndex = value;
                            // setState(() {});
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return SwipeCard(
                              price: listOfData[index]['price'],
                              isActive: activeIndex == index,
                              fromBack: fromBack,
                              title: listOfData[index]['name'],
                              image: listOfData[index]['image'],
                            );
                          },
                          itemCount: listOfData.length,
                          loop: false,
                          index: 0,
                          itemWidth: 324.0,
                          itemHeight: 420,
                          layout: SwiperLayout.STACK,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                      SizedBox(
                        height: 148,
                        child: PageView.builder(
                          itemCount: listOfData.length,
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CardInfoWidget(
                              carName: listOfData[index]['name'],
                              year: listOfData[index]['year'],
                              hp: listOfData[index]['hp'],
                              speed: listOfData[index]['speed'],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.blue.shade100,
              )
            ],
          ),
        ],
      ),
    );
  }
}


class SwipeCard extends StatefulWidget {
  const SwipeCard({
  super.key,
  required this.title,
  required this.price,
  required this.image,
  required this.isActive,
  required this.fromBack,
  });
  final String title;
  final String image;
  final String price;

  final bool isActive;
  final bool fromBack;

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  bool isSwiped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        // color: const Color(0xFFDEDEDE),
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            width: 350,
            height: 220,
            child: Image.network(
              widget.image,
              fit: BoxFit.fitHeight,
            ),
          ).animate(target: widget.isActive ? 1 : 0)
          // car will come form left or right
              .moveX(
            // begin: widget.fromBack ? -300 : 300,
            // begin: 300,
              delay: 110.ms,
              duration: 250.ms,
              curve: Curves.easeOutCirc)
              .then(delay: 600.ms)
          // then move car forward
              .moveX(end: 100)
              .then()
          // then zoom in 2x
              .scaleXY(end: 2, delay: 200.ms, duration: 1000.ms)
              .then()
          // then move while zoomed in 2x
              .moveX(end: -400, duration: 2000.ms)
              .then()
          // then zoomed view end zoom out back to original size
              .scaleXY(end: 0.5, delay: 300.ms, duration: 500.ms)
              .then()
              .moveX(end: 100, duration: 1000.ms),
          Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.amber.shade100,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "From \$${widget.price}",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
