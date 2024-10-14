part of 'home_screen.dart';

mixin HomeController on State<HomePage> {
  Key _key = UniqueKey();

  int horizontalCount = 4;
  int verticalCount = 5;

  late int allCardsCount;

  var cardList = <CardM>[];

  @override
  void initState() {
    allCardsCount = horizontalCount * verticalCount;
    _fillList();
    super.initState();
  }

  @override
  void dispose() {
    cardList.clear();
    super.dispose();
  }

  void restartGame() {
    cardList.clear();
    _fillList();

    Constants.canClick = true;
    Constants.hiddenCards = 0;
    Constants.tappedCards.clear();
    Constants.openedCardsStates.clear();

    setState(() {
      _key = UniqueKey();
    });
  }

  void _fillList() {
    for (int i = 0; i < allCardsCount; i++) {
      cardList.add(CardM(imgId: i, imgAssetName: _pickImage()));
    }
  }

  String _pickImage() {
    String result = "";
    int count = 0;

    switch (Random().nextInt(allCardsCount ~/ 2.toInt())) {
      case 0:
        result = Assets.img1;
      case 1:
        result = Assets.img2;
      case 2:
        result = Assets.img3;
      case 3:
        result = Assets.img4;
      case 4:
        result = Assets.img5;
      case 5:
        result = Assets.img6;
      case 6:
        result = Assets.img7;
      case 7:
        result = Assets.img8;
      case 8:
        result = Assets.img9;
      case 9:
        result = Assets.img10;
    }

    for (var value in cardList) {
      if (value.imgAssetName == result) count++;
    }

    if (count < 2) {
      return result;
    } else {
      return _pickImage();
    }
  }
}
