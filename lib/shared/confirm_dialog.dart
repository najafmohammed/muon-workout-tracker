import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'OK',
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel!();
            },
            child: Text(cancelText),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
