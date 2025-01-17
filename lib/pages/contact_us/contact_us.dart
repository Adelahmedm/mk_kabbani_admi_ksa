import 'package:mk_kabbani_admin/controllers/pages_controller/contact_us_controller.dart';

import 'package:mk_kabbani_admin/pages/contact_us/contact_us_desktop_layout.dart';
import 'package:mk_kabbani_admin/pages/contact_us/contact_us_mobile_layout.dart';

import '../../config.dart';

class ContactUs extends StatelessWidget {
  final staticCtrl = Get.put(ContactUsController());

  ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactUsController>(builder: (_) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Card(
                      elevation: 3,
                      shadowColor: appCtrl.appTheme.blackColor,
                      color: appCtrl.appTheme.whiteColor,
                      child: Responsive.isDesktop(context)
                          ? const ContactUsDesktopLayout()
                          : const ContactUsMobileLayout().paddingSymmetric(
                              horizontal: Insets.i15, vertical: Insets.i20)),
                  if (staticCtrl.isLoading)
                    const Center(child: CircularProgressIndicator())
                ],
              ),
              CustomSnackBar(isAlert: staticCtrl.isAlert,text: fonts.modification.tr,)
            ],
          ),
        ],
      );
    });
  }
}
