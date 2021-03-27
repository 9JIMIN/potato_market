import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/helpers/text_helper.dart';
import '../../../../models/item.dart';
import '../market_provider.dart';

class ProductItem extends StatelessWidget {
  final Item item;
  ProductItem(this.item);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MarketProvider>(context, listen: false);

    final title = item.title;
    final imageUrl = item.imageUrls[0];
    final pointName = item.spot['name'];
    final time = TextHelper.date(item.createdAt.toDate());
    final price = TextHelper.price(item.price);
    return Row(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Image.network(
              '$imageUrl',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title'),
            Text('$pointName - $time'),
            Text('$price'),
          ],
        )
      ],
    );
  }
}
