import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    {String actionLabel = 'OK', VoidCallback? onActionPressed}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onActionPressed ?? () {},
        textColor: Colors.white,
      ),
    ),
  );
}
