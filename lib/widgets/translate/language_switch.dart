import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language/language_enum.dart';
import '../../providers/language/language_provider.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({Key? key}) : super(key: key);

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  bool positive = false;
  @override
  Widget build(BuildContext context) {
    // return AnimatedToggleSwitch<bool>.dual(
    //   current: positive,
    //   first: false,
    //   second: true,
    //   dif: 0.0,
    //   borderColor: Colors.transparent,
    //   borderWidth: 5.0,
    //   // height: 30,
    //   boxShadow: const [
    //     BoxShadow(
    //       color: Colors.black26,
    //       spreadRadius: 1,
    //       blurRadius: 2,
    //       offset: Offset(0, 1.5),
    //     ),
    //   ],
    //   onChanged: (b) => setState(() => positive = b),
    //   iconBuilder: (value) =>
    //       value ? Flag.fromCode(FlagsCode.GB) : Flag.fromCode(FlagsCode.UA),
    // );

    return CustomAnimatedToggleSwitch<bool>(
      current: positive,
      values: const [false, true],
      dif: 0.0,
      indicatorSize: const Size.square(30.0),
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.linear,
      iconBuilder: (context, local, global) {
        return const SizedBox();
      },
      defaultCursor: SystemMouseCursors.click,
      onTap: () {
        setState(() => positive = !positive);
        Provider.of<Language>(context, listen: false)
            .setLang(positive ? LanguageType.uk : LanguageType.en);
      },
      iconsTappable: false,
      wrapperBuilder: (context, global, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 10.0,
                right: 10.0,
                height: 20.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        Colors.black26, Colors.black54, global.position),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  ),
                )),
            child,
          ],
        );
      },
      foregroundIndicatorBuilder: (context, global) {
        // return SizedBox.fromSize(
        //   size: global.indicatorSize,
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       color: Color.lerp(Colors.white, Colors.pink, global.position),
        //       borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        //       boxShadow: const [
        //         BoxShadow(
        //             color: Colors.black38,
        //             spreadRadius: 0.05,
        //             blurRadius: 1.1,
        //             offset: Offset(0.0, 0.8))
        //       ],
        //     ),
        //   ),
        // );
        return Flag.fromCode(
          global.current ? FlagsCode.UA : FlagsCode.GB,
          borderRadius: 32,
          fit: BoxFit.fill,
        );
      },
    );
  }
}
