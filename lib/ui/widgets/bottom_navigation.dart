import 'package:flutter/material.dart';
import 'package:flutter_kundol/constants/app_config.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_svg/svg.dart';

import '../../tweaks/app_localization.dart';

class MyBottomNavigation extends StatelessWidget {
  final Function(int position) selectCurrentItem;
  final int selectedIndex;

  const MyBottomNavigation(this.selectCurrentItem, this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 4.0,
              offset: Offset(5.0, 5.0),
              spreadRadius: 2.0)
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppStyles.CARD_RADIUS),
          topRight: Radius.circular(AppStyles.CARD_RADIUS),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (value) {
            selectCurrentItem(value);
          },
          items: [
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)?.translate('bottom_navigation_home'),
              icon: SvgPicture.asset("assets/icons/ic_home.svg",),
              activeIcon: SvgPicture.asset("assets/icons/ic_home_filled.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColor),
            ),
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)?.translate('bottom_navigation_categories'),
              icon: SvgPicture.asset("assets/icons/ic_category.svg"),
              activeIcon: SvgPicture.asset("assets/icons/ic_category_filled.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColor),
            ),
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)?.translate('bottom_navigation_wishlist'),
              icon: SvgPicture.asset("assets/icons/ic_heart.svg"),
              activeIcon: SvgPicture.asset("assets/icons/ic_heart_filled.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColor),
            ),

            BottomNavigationBarItem(
              label: AppLocalizations.of(context)?.translate('bottom_navigation_myaccount'),
            // icon: Icon(Icons.person_outline,),
               icon: SvgPicture.asset("assets/icons/ic_person.svg",),
             // icon: SvgPicture.asset("assets/icons/ic_person_new.svg",color: Colors.black26,),
              activeIcon: SvgPicture.asset("assets/icons/ic_person_filled.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : Theme.of(context).primaryColor),
            ),

            // BottomNavigationBarItem(
            //   label: AppLocalizations.of(context)?.translate('bottom_navigation_myaccount'),
            //   // icon: selectedIndex==3? SvgPicture.asset("assets/icons/ic_person.svg",color: Theme.of(context).bottomAppBarColor,): SvgPicture.asset("assets/icons/ic_person.svg",color: Theme.of(context).primaryColor,),
            //   icon: SvgPicture.asset("assets/icons/ic_person_new.svg"),
            //   activeIcon: SvgPicture.asset("assets/icons/ic_person_filled.svg",color:Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black),
            // ),
          ],
        ),




        // child: BottomNavigationBar(
        //  // backgroundColor:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
        //   selectedItemColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: selectedIndex,
        //   onTap: (value) {
        //     selectCurrentItem(value);
        //   },
        //   unselectedItemColor: Theme.of(context).brightness == Brightness.dark ?  Colors.grey[700] :  Colors.grey[700] ,
        //   items: [
        //     BottomNavigationBarItem(
        //       label: AppLocalizations.of(context)!.translate('bottom_navigation_home'),
        //       icon: SvgPicture.asset("assets/icons/ic_home_new.svg",color: Colors.grey[700],),
        //       activeIcon: SvgPicture.asset("assets/icons/ic_home_filled_new.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        //     ),
        //     BottomNavigationBarItem(
        //       label: AppLocalizations.of(context)!.translate('bottom_navigation_categories'),
        //       icon: SvgPicture.asset("assets/icons/ic_category_new.svg",color: Colors.grey[700],),
        //       activeIcon: SvgPicture.asset("assets/icons/ic_category_filled_new.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        //     ),
        //     BottomNavigationBarItem(
        //       label: AppLocalizations.of(context)!.translate('bottom_navigation_wishlist'),
        //       icon: SvgPicture.asset("assets/icons/ic_basket_new.svg",color: Colors.grey[700],),
        //       activeIcon: SvgPicture.asset("assets/icons/ic_basket_filed_new.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        //     ),
        //     BottomNavigationBarItem(
        //       label: AppLocalizations.of(context)!.translate('bottom_navigation_myaccount'),
        //       icon: SvgPicture.asset("assets/icons/ic_profile_new.svg",color: Colors.grey[700],),
        //       activeIcon: SvgPicture.asset("assets/icons/ic_profile_filed_new.svg",color:Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
