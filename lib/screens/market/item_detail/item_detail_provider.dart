import 'package:flutter/cupertino.dart';

import '../../../models/item.dart';
import '../../../models/profile.dart';

class ItemDetailProvider with ChangeNotifier {
  Item _item;
  Profile _seller;
  bool _isLike;
  bool _isMine;

  Item get item => _item;
  Profile get seller => _seller;
  bool get isLike => _isLike;
  bool get isMine => _isMine;

  void fetchProduct(Item item) {
    _item = item;
    // if(item.sellerId == ){

    // }
  }

  Future<void> fetchSeller() async {
    // seller정보가져오기
  }

  Future<void> fetchIsLike() async {
    // Like여부 업데이트
  }

  void onSellerProfileTap() {
    // 판매자 화면으로 가기
  }

  Future<void> onLikeButtonPressed() async {
    // 관심목록에 추가
  }

  void onChatButtonPressed() {
    // 채팅목록 바텀탭 나옴.
  }
}
