import 'package:flutter/material.dart';

class VResponsiveLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  const VResponsiveLayout({Key? key, this.mobile, this.tablet,  this.desktop})
      : super(key: key);

  static int mobileLimit = 600;
  static int tabletLimit = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
          MediaQuery.of(context).size.width >= mobileLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < mobileLimit) {
            return mobile!;
          }
          if (constraints.maxWidth < tabletLimit) {
            return tablet!;
          } else {
            return desktop!;
          }
        });
  }
}