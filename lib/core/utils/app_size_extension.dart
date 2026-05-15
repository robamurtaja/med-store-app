import 'package:flutter/material.dart';

extension AppSizes on BuildContext {
  double get getWidth => MediaQuery.sizeOf(this).width;
  double get getHeight => MediaQuery.sizeOf(this).height;
  double get availableHeight {
    final appBarHeight = kToolbarHeight; 
    final statusBarHeight = MediaQuery.of(this).padding.top;
    return MediaQuery.of(this).size.height - appBarHeight - statusBarHeight;
  }

  bool get isSmallScreen => MediaQuery.sizeOf(this).height < 690;

  SizedBox addHorizontalSpace(double value) {
    return SizedBox(width: MediaQuery.sizeOf(this).width * (value / 360));
  }

  SizedBox addVerticalSpace(double value) {
    return SizedBox(height: MediaQuery.sizeOf(this).height * (value / 800));
  }

  double width(double value) {
    return MediaQuery.sizeOf(this).width * (value / 360);
  }

  double height(double value) {
    return MediaQuery.sizeOf(this).height * (value / 800);
  }

  EdgeInsets spaceAroundAll(double value) {
    return EdgeInsets.all(value);
  }

  EdgeInsets spaceHorizontal(double value) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  EdgeInsets spaceVertical(double value) {
    return EdgeInsets.symmetric(
      vertical: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsets spaceSymmetric({
    required double vertical,
    required double horizontal,
  }) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(this).width * (horizontal / 360),
      vertical: MediaQuery.sizeOf(this).height * (vertical / 800),
    );
  }

  EdgeInsetsDirectional spaceTop(double value) {
    return EdgeInsetsDirectional.only(
      top: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsetsDirectional spaceBottom(double value) {
    return EdgeInsetsDirectional.only(
      bottom: MediaQuery.sizeOf(this).height * (value / 800),
    );
  }

  EdgeInsetsDirectional spaceStart(double value) {
    return EdgeInsetsDirectional.only(
      start: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  EdgeInsetsDirectional spaceEnd(double value) {
    return EdgeInsetsDirectional.only(
      end: MediaQuery.sizeOf(this).width * (value / 360),
    );
  }

  BorderRadius circularRadius(double value) {
    return BorderRadius.circular(value);
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;
}

extension LayoutExtensions on Widget {
  Widget pad([double value = 8.0]) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget padTop([double value = 8.0]) => Padding(
    padding: EdgeInsets.only(top: value),
    child: this,
  );
  Widget padStart([double value = 8.0]) => Padding(
    padding: EdgeInsets.only(left: value),
    child: this,
  );

  Widget padEnd([double value = 20]) => Padding(
    padding: EdgeInsets.only(right: value),
    child: this,
  );
  Widget padBottom([double value = 8.0]) => Padding(
    padding: EdgeInsets.only(bottom: value),
    child: this,
  );
  Widget center() => Center(child: this);
  Widget contains() => Container(color: Colors.red, child: this);
  Widget padSymmetricHoriz(double value) => Padding(
    padding: EdgeInsetsDirectional.symmetric(horizontal: value),
    child: this,
  );
  Widget padSymmetricVert(double value) => Padding(
    padding: EdgeInsetsDirectional.symmetric(vertical: value),
    child: this,
  );
}