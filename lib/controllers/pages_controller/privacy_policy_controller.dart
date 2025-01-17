import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import '../../config.dart';

class PrivacyPolicyController extends GetxController {
  TextEditingController txtPrivacy = TextEditingController();
  String id = "";
  bool isLoading = false;
  bool isAlert = false;

  final QuillEditorController controller = QuillEditorController();

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
  ];

  final backgroundColor = Colors.white70;

  final editorTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black54, fontWeight: FontWeight.normal);
  final hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.teal, fontWeight: FontWeight.normal);

  @override
  void onReady() {
    // TODO: implement onReady
    getData();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });

    update();
    super.onReady();
  }

  //get data from firebase
  getData() async {
    await FirebaseFirestore.instance
        .collection(collectionName.static)
        .get()
        .then((value) {
      id = value.docs[0].id;
      txtPrivacy.text = value.docs[0].data()["privacyPolicy"];
      controller.setText(txtPrivacy.text);
      update();
      log("About : ${controller.getText()}");
    });
    update();
  }

  //update data
  updateData() async {
    bool isLoginTest = appCtrl.storage.read(session.isLoginTest);
    if (isLoginTest) {
      isAlert =true;
      update();
      await Future.delayed(Durationss.s2);
      isAlert = false;
      update();
    } else {
      var selectedText = await controller.getText();
      await controller.setText(selectedText);
      isLoading = true;
      update();
      await FirebaseFirestore.instance
          .collection(collectionName.static)
          .doc(id)
          .update({
        "privacyPolicy": selectedText,
      }).then((value) {
        isLoading = false;
        update();
      });
      update();
      getData();
    }
  }
}
