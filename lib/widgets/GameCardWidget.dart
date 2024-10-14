import 'dart:async';
import 'dart:math';

import 'package:app/constants/assets.dart';
import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

class GameCardWidget extends StatefulWidget {
  const GameCardWidget({super.key, required this.imgAssetName, required this.index, required this.allCardsCount, required this.onGameFinish});

  final String imgAssetName;
  final int index;
  final int allCardsCount;
  final Function() onGameFinish;

  @override
  State createState() => GameCardWidgetState();
}

class GameCardWidgetState extends State<GameCardWidget> {
  bool _isVisible = true;
  bool _displayFront = false;
  bool _isFirstCreation = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (details) {
          Constants.tappedCards.add(widget.index);
        },
        onTapCancel: () {
          Constants.tappedCards.remove(widget.index);
        },
        onTap: () {
          if (Constants.tappedCards.length <= 1 && Constants.canClick && Constants.openedCardsStates.length < 2) {
            setState(() => _displayFront = !_displayFront);
          }

          Constants.tappedCards.remove(widget.index);
        },
        child: AnimatedSwitcher(
          transitionBuilder: __transitionBuilder,
          layoutBuilder: (widget, list) => Stack(
            children: [
              if (widget != null) widget,
              ...list,
            ],
          ),
          duration: Duration(milliseconds: 350),
          child: _displayFront ? _buildFront(imgAssetName: widget.imgAssetName) : _buildRear(imgAssetName: Assets.imgClose),
        ),
      ),
    );
  }

  void closeCard() {
    setState(() {
      _displayFront = false;
    });
  }

  void hideCard() {
    setState(() {
      _isVisible = false;
    });
    Constants.hiddenCards++;
  }

  Widget _buildFront({required String imgAssetName}) {
    return __buildCard(key: ValueKey(true), imgAssetName: imgAssetName, isRear: false);
  }

  Widget _buildRear({required String imgAssetName}) {
    return __buildCard(key: ValueKey(false), imgAssetName: imgAssetName, isRear: true);
  }

  Widget __buildCard({Key? key, required String imgAssetName, required bool isRear}) {
    return SizedBox(
      key: key,
      height: double.infinity,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: isRear ? Border.all(width: 1.5) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(imgAssetName),
        ),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);

    rotateAnim.addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.forward:
          Constants.canClick = false;
        case AnimationStatus.completed:
          {
            Constants.canClick = true;

            if (_isFirstCreation) {
              _isFirstCreation = false;
            } else {
              Constants.tappedCards.remove(this.widget.index);

              if (_displayFront) {
                Constants.openedCardsStates.add(this);
              } else {
                Constants.openedCardsStates.remove(this);
              }
            }

            if (Constants.openedCardsStates.length >= 2) {
              _checkOpenedImages();
            }
          }
        default:
      }
    });

    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_displayFront) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  void _checkOpenedImages() {
    Timer(Duration(milliseconds: 350), () {
      if (Constants.openedCardsStates[0].widget.imgAssetName == Constants.openedCardsStates[1].widget.imgAssetName) {
        for (var item in Constants.openedCardsStates) {
          item.hideCard();
        }
        Constants.openedCardsStates.clear();

        if (Constants.hiddenCards >= widget.allCardsCount) {
          widget.onGameFinish();
        }
      } else {
        for (var item in Constants.openedCardsStates) {
          item.closeCard();
        }
      }
    });
  }
}
