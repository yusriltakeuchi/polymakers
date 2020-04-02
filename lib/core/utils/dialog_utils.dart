
import 'package:flutter/material.dart';
import 'package:polymaker/ui/widgets/dialog_report.dart';
import 'package:polymaker/ui/widgets/dialog_warning.dart';

class DialogUtils {

  static void showReport(BuildContext context, String title, TextEditingController controller, Function onSend) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: DialogReport(
              title: title,
              context: context,
              reportController: controller,
              onSend: () => onSend(),
            )
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
  }

  static void showDialogWarning(BuildContext context, String title, String message, Function onClick) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: DialogWarning(
              title: title,
              message: message,
              onClick: () => onClick(),
            )
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
  }

}