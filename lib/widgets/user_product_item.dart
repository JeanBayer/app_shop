import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialogDelete(BuildContext context, ScaffoldMessengerState scaffoldMessenger) async {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Removing items!'),
            content: const Text('Do you realy want to remove this item?'),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    Navigator.of(ctx).pop(true);
                  } catch (error) {
                    Navigator.of(ctx).pop(true);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('$error'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await showDialogDelete(context, scaffoldMessenger);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
