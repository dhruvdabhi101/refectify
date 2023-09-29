import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:refectify/pages/auth/login.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late int index;
  late Material materialButton;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Refectify',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'A simple note taking app with great features for taking notes',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign up now',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Get more from the app after signing up',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];

  static const width = 100.0;
  @override
  void initState() {
    super.initState();
    index = 0;
  }

  SizedBox _skipButton({void Function(int)? setIndex}) {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: Colors.white70,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index++;
                setIndex(index);
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Text('Next',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox get _signupButton {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: Colors.lightBlueAccent,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              //redirect to /home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
              child: Text('Sign up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Onboarding(
            pages: onboardingPagesList,
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(
                    width: 0.0,
                    color: background,
                  ),
                ),
                child: ColoredBox(
                  color: background,
                  child: Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        index != pagesLength - 1
                            ? _skipButton(setIndex: setIndex)
                            : _signupButton,
                        Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: CustomIndicator(
                            netDragPercent: dragDistance,
                            pagesLength: pagesLength,
                            indicator: Indicator(
                              indicatorDesign: IndicatorDesign.polygon(
                                polygonDesign: PolygonDesign(
                                  polygon: DesignType.polygon_arrow,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
