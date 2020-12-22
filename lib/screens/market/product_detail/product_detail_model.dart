import 'package:flutter/cupertino.dart';

import '../../models/product.dart';
import '../../models/profile.dart';

class ProductDetailModel with ChangeNotifier {
  Product _product;
  Profile _seller;
  bool _isLike;
  bool _isMine;

  Product get product => _product;
  Profile get seller => _seller;
  bool get isLike => _isLike;
  bool get isMine => _isMine;

  void fetchProduct(Product product) {
    _product = product;
    // if(product.sellerId == ){

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
