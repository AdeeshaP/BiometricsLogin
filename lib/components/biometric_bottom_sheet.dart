import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BiometricBottomSheet extends StatelessWidget {
  final void Function() action;

  BiometricBottomSheet({Key? key, required this.action}) : super(key: key);

  static Color primaryColor =
      const Color.fromARGB(255, 86, 65, 2).withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.fingerprint_outlined,
                size: 100,
                color: Color.fromARGB(255, 192, 111, 5).withOpacity(0.7),
              ),
              Icon(
                MdiIcons.faceRecognition,
                size: 70,
                color: Color.fromARGB(255, 192, 111, 5).withOpacity(0.7),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  "Fingerprint",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Face ID",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Do you want to enable biometric login?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              action();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor:
                  Color.fromARGB(255, 192, 111, 5).withOpacity(0.7),
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
              child: Text(
                "No, thanks!",
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ))
        ],
      ),
    );
  }
}
