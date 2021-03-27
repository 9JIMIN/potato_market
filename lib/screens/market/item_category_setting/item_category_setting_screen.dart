import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_category_setting_provider.dart';

class ItemCategorySettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ItemCategorySettingProvider(),
        builder: (context, _) {
          final model = Provider.of<ItemCategorySettingProvider>(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('카테고리 설정'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Column(
                children: [
                  Text(
                    '홈 화면에서 보고 싶지 않은 카테고리는\n 체크를 해제하세요',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text('최소 1개 이상 선택되어 있어야 합니다.'),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      itemCount: model.categoryList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: IconButton(
                            icon: Icon(model.categoryIsCheck[index]
                                ? Icons.check_circle
                                : Icons.check_circle_outline),
                            onPressed: () {
                              model.onCategoryTap(index);
                            },
                          ),
                          title: Text(
                            model.categoryList[index],
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
