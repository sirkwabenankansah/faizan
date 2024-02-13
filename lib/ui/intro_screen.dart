import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../tweaks/app_localization.dart';


class Intro_Screen extends StatefulWidget {
  const Intro_Screen({Key? key}) : super(key: key);

  @override
  _Intro_ScreenState createState() => _Intro_ScreenState();
}

class _Intro_ScreenState extends State<Intro_Screen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: [
            Expanded(
              child:PageView(
                controller: pageController,
                onPageChanged: (index){
                  setState(() {
                    pageChanged = index;
                  });
                  // print(pageChanged);
                },
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Online Shopping")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Online Shopping")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Color(0xff0478ED)),)),
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_1.svg",height: 250,width: double.maxFinite,)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_bar_1.svg",height: 55,width: double.maxFinite)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Cook Instantly")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Without Any Worries")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Color(0xff0478ED)),)),
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_2.svg",height: 250,width: double.maxFinite,)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_bar_2.svg",height: 55,width: double.maxFinite)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Ship at your home")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("In no time")!,
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Color(0xff0478ED)),)),
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_3.svg",height: 250,width: double.maxFinite,)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset("assets/images/intro_bar_3.svg",height: 55,width: double.maxFinite)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: double.maxFinite,
                height: 100,
                child: Column(
                  children: [
                    SizedBox(
                      width: 220,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),

                                  )
                              )
                          ),
                          onPressed: () {
                            if(pageChanged <= 2){
                              pageController.animateToPage(++pageChanged, duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
                            }
                            print(pageChanged);
                          },
                          child: pageChanged == 2 ? Text(
                              AppLocalizations.of(context)!.translate("Sign In")!
                          ) : Text(
                              AppLocalizations.of(context)!.translate("Next")!
                          )

                      ),
                    ),
                    pageChanged == 2 ? Text(
                        AppLocalizations.of(context)!.translate("Home")!
                    ) : Text(
                        AppLocalizations.of(context)!.translate( "Skip")!
                    )
                  ],
                )
            ),
          ],
        )
    );
  }
}
