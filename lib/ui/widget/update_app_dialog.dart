import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_button.dart';

class UpdateAppDialog extends StatelessWidget {
  final double? height;
  final String? buttonText;
  final VoidCallback? onClickButton;
  final VoidCallback? onClose;
  final Widget? button;
  final bool isShowCloseButton;
  final int? maxLength;
  final bool isForceUpdate;

  const UpdateAppDialog({
    Key? key,
    this.height,
    this.buttonText,
    this.onClickButton,
    this.onClose,
    this.button,
    this.isShowCloseButton = true,
    this.maxLength,
    this.isForceUpdate = false,
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
                'Update',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
              ),
            ),
            buildDescriptionText(isForceUpdate),
            SizedBox(height: 8.h),
            button ??
                Visibility(
                  visible: buttonText != null,
                  child: CommonButton(
                    onTap: onClickButton ?? () {},
                    text: buttonText ?? '',
                    textColor: Colors.white,
                  ),
                )
          ],
        ),
      ),
    );
  }

  Widget buildDescriptionText(bool isForceUpdate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        isForceUpdate
            ? 'The latest version has been released.\nPlease update the app.'
            : 'The latest version has been released.\nClick here to update the app.',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        maxLines: maxLength ?? 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Future<void> showMyDialog({
    bool isForceUpdate = false,
    required VoidCallback onSkip,
    required BuildContext context,
  }) async {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return UpdateAppDialog(
          button: isForceUpdate
              ? null
              : Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        onTap: onSkip,
                        backgroundColor: Colors.white,
                        text: 'Skip',
                        textColor: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Expanded(
                      child: CommonButton(
                        onTap: onUpdate,
                        text: 'Update',
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
          buttonText: isForceUpdate ? 'Update' : null,
          onClickButton: isForceUpdate ? onUpdate : null,
          isShowCloseButton: !isForceUpdate,
          onClose: !isForceUpdate ? onSkip : null,
        );
      },
    );
  }

  static Future<void> onUpdate() async {
    String url = Platform.isIOS
        ? 'https://apps.apple.com/app/id6475397851'
        : 'https://play.google.com/store/apps/details?id=wathunagi.enishi.app';
    Uri uri = Uri.parse(url);
    bool isLaunch = await canLaunchUrl(uri);
    if (isLaunch) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (kDebugMode) {
        print('Error link');
      }
    }
  }
}
