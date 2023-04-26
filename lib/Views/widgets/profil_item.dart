import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login_page.dart';
import 'sp_icon.dart';

class ProfilItem extends StatelessWidget {
  const ProfilItem(
      {super.key,
      required this.title,
      this.subtitle,
      required this.assetName,
      required this.isLast,
      this.onTap});
  final String title;
  final String? subtitle;
  final String assetName;
  final bool isLast;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 68,
            child: ListTile(
              leading: SPIcon(assetName: assetName),
              title: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : null,
              trailing: InkWell(
                onTap: () {
                  Get.bottomSheet(const LoginPage());
                },
                child: const Icon(
                  CupertinoIcons.chevron_forward,
                  size: 16,
                ),
              ),
            ),
          ),
          isLast ? Container() : const Divider(),
        ],
      ),
    );
  }
}
