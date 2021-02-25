import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyCoolPageRoute<T> extends PageRoute<T> {
  MyCoolPageRoute({
    @required this.builder,
    RouteSettings settings,
    bool fullscreenDialog: true,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return MyCoolPageTransition(routeAnimation: animation, child: child);
  }
}

class MyCoolPageTransition extends StatelessWidget {
  MyCoolPageTransition(
      {Key key, @required this.routeAnimation, @required this.child})
      : super(key: key);

  final Animation<double> routeAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(routeAnimation.value),
      child: SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0.0, 0.25), end: Offset.zero)
              .animate(routeAnimation),
          child: child),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  CircleRevealClipper(this.revealPercent);

  final double revealPercent;
  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width / 0.9, size.height / 0.9);

    double theta = math.atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / math.sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
