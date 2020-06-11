import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storeImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
    );
    // ضفنا الشرط لان عندما نقوم بفتح الكميرا من داخل التطبيق ثم نضغط زر الرجوع
    // فهنا لم ياخذ الصورة وسيكمل الحفظ لصورة غير موجودة اصلا فيكون هناك مشكلة
    if(imageFile == null){
      return;
    }
    setState(() {
      //خرج ال picker في الاصدارات الحديثة يكون pickedFile وبالتالي لا يمكن اسناده ل file
      //فقمنا باخذ المسار وحولنا ل file ثم ثم قمنا بالاسناد
      _storeImage = File(imageFile.path);
    });
    // استخدمنا path provider للحصول على ال dir الخاص بالتطبيق في الهارد
    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    // استخدمنا مكتبة ال path للحصول على اسم من path الصورة
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName'); // نسخ الصورة الى المسار في الهارد
  widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storeImage != null
              ? Image.file(
                  _storeImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              _takePicture();
            },
          ),
        ),
      ],
    );
  }
}
