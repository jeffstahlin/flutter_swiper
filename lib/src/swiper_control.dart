import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperControl extends SwiperPlugin {
  /// IconData for previous
  final IconData iconPrevious;

  /// IconData for next
  final IconData iconNext;

  /// Icon size
  final double size;

  /// Icon normal color, The theme's [ThemeData.primaryColor] by default.
  final Color color;

  /// If set loop=false on Swiper, this color will be used when swiper goto the last slide.
  /// The theme's [ThemeData.disabledColor] by default.
  final Color disableColor;

  final EdgeInsetsGeometry padding;

  final Key key;

  final Alignment alignment;

  final String controlButtonStyle;

  final bool isVisible;

  final Function transitionTo;

  const SwiperControl(
      {this.iconPrevious: Icons.arrow_back_ios,
      this.iconNext: Icons.arrow_forward_ios,
      this.color,
      this.disableColor,
      this.key,
      this.size: 30.0,
      this.padding: const EdgeInsets.all(15.0),
      this.alignment: Alignment.center,
      this.controlButtonStyle,
      this.isVisible,
      this.transitionTo});

  Widget buildButton(SwiperPluginConfig config, Color color, IconData iconData,
      int quarterTurns, bool previous) {
    return RaisedButton.icon(
      onPressed: () {
        if (previous) {
          config.controller.previous(animation: true);
        } else {
          transitionTo(true);
          config.controller.next(animation: true);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      padding: EdgeInsets.fromLTRB(25.0, 15.0, 15.0, 15.0),
      color: Colors.lightBlueAccent,
      textColor: Colors.white,
      icon: Text(
        previous ? "Previous" : "Next",
        style: TextStyle(fontSize: 25.0),
      ),
      label: Icon(
        iconData,
        semanticLabel: previous ? "Previous" : "Next",
        size: size,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);

    Color color = this.color ?? themeData.primaryColor;
    Color disableColor = this.disableColor ?? themeData.disabledColor;
    Color prevColor;
    Color nextColor;

    if (config.loop) {
      prevColor = nextColor = color;
    } else {
      bool next = config.activeIndex < config.itemCount - 1;
      bool prev = config.activeIndex > 0;
      prevColor = prev ? color : disableColor;
      nextColor = next ? color : disableColor;
    }

    Widget child;
    if (isVisible) {
      if (config.scrollDirection == Axis.horizontal) {
        child = Row(
          key: key,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (this.iconPrevious != null)
              buildButton(config, prevColor, iconPrevious, 0, true),
            if (this.iconNext != null)
              buildButton(config, nextColor, iconNext, 0, false)
          ],
        );
      } else {
        child = Column(
          key: key,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (this.iconPrevious != null)
              buildButton(config, prevColor, iconPrevious, -3, true),
            if (this.iconNext != null)
              buildButton(config, nextColor, iconNext, -3, false)
          ],
        );
      }
    }

    return new Container(
      height: double.infinity,
      child: child,
      width: double.infinity,
      alignment: alignment,
      padding: const EdgeInsets.all(20.0),
    );
  }
}
