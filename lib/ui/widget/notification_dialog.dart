import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_button.dart';

class NotificationDialog extends StatelessWidget {
  final double? height;
  final String title;
  final String? descriptionText;
  final String? buttonText;
  final VoidCallback? onClickButton;
  final VoidCallback? onClose;
  final TextAlign? descriptionTextAlign;
  final Widget? button;
  final bool isShowCloseButton;
  final int? maxLength;

  const NotificationDialog({
    Key? key,
    this.height,
    required this.title,
    this.buttonText,
    this.onClickButton,
    this.descriptionText,
    this.onClose,
    this.descriptionTextAlign,
    this.button,
    this.isShowCloseButton = true,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isShowCloseButton,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onClose ??
                      () {
                        Navigator.pop(context);
                      },
                  customBorder: const CircleBorder(),
                  child: const Icon(Icons.close),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
              ),
            ),
            Visibility(
              visible: descriptionText != null,
              child: buildDescriptionText(),
            ),
            SizedBox(height: 4.w),
            button ??
                Visibility(
                  visible: buttonText != null,
                  child: CommonButton(
                    text: buttonText ?? '',
                    onTap: onClickButton ?? () {},
                  ),
                )
          ],
        ),
      ),
    );
  }

  Padding buildDescriptionText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        descriptionText ?? '',
        textAlign: descriptionTextAlign,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
        maxLines: maxLength ?? 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
