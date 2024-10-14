import 'dart:async';
import 'dart:math';

import 'package:app/constants/assets.dart';
import 'package:app/constants/constants.dart';
import 'package:app/constants/fonts.dart';
import 'package:app/models/CardM.dart';
import 'package:app/utils/extensions.dart';
import 'package:app/widgets/GameCardWidget.dart';
import 'package:flutter/material.dart';

part 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: context.mediaQuery.size.height * 0.14,
        title: Text(
          "<${widget.title}>",
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 48,
            fontFamily: Fonts.tribal,
            color: context.colorScheme.onPrimary
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28.0),
            bottomRight: Radius.circular(28.0),
          ),
        ),
        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: Center(
        key: _key,
        child: GridView.count(
          crossAxisCount: horizontalCount,
          childAspectRatio: 1.0 / 1.3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          shrinkWrap: true,
          children: List.generate(cardList.length, (index) {
            return GameCardWidget(
              imgAssetName: cardList[index].imgAssetName,
              index: index,
              allCardsCount: allCardsCount,
              onGameFinish: () {
                Timer(Duration(milliseconds: 600), () {
                  restartGame();
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
