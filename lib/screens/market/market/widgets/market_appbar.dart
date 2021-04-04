import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_provider.dart';
import '../../../../utils/services/local/local_storage_service.dart';

class MarketAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    final model = Provider.of<MarketProvider>(context, listen: false);
    final currentArea = LocalStorageService().area;
    return AppBar(
      title: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentArea.name),
            SizedBox(width: 10),
            Icon(Icons.swap_horiz),
          ],
        ),
        onPressed: () {
          model.onAreaTap(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.tune),
          onPressed: () {
            model.onCategoryIconTap(context);
          },
        ),
      ],
    );
  }
}
