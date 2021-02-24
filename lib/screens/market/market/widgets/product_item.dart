import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/product.dart';
import '../../../../services/format_services.dart';
import '../market_model.dart';

class ProductItem extends StatelessWidget {
  final Product item;
  ProductItem(this.item);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MarketModel>(context, listen: false);

    final title = item.title;
    final imageUrl = item.imageUrls[0];
    final pointName = item.tradePoint['name'];
    final time = FormatServices.date(item.createdAt.toDate());
    final price = FormatServices.price(item.price);
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
    // ListTile(
    //     leading: Image.network('$firstImage'),
    //     title: Text(title),
    //     subtitle: Text('$price'),
    //     trailing: Column(
    //       children: [
    //         Text('like: $likeCount'),
    //         Text('chat: $chatCount'),
    //       ],
    //     ),
    //     onTap: () {
    //       model.onItemTap(context, i);
    //     });
  }
}
