import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    // เริ่มต้นที่กลางล่างของเรือ
    path.moveTo(width * 0.5, height); // จุดเริ่มต้น

    // วาดลำเรือ
    path.lineTo(width * 0.8, height * 0.8); // ด้านขวาของลำเรือ
    path.lineTo(width * 0.2, height * 0.8); // ด้านซ้ายของลำเรือ
    path.close(); // ปิดลำเรือ

    // วาดใบเรือ
    path.moveTo(width * 0.5, height * 0.3); // จุดเริ่มต้นของใบเรือ
    path.lineTo(width * 0.5, height * 0.0); // ยกขึ้นไปที่ด้านบน
    path.lineTo(width * 0.8, height * 0.3); // ด้านขวาของใบเรือ
    path.lineTo(width * 0.5, height * 0.3); // ย้อนกลับไปที่จุดเริ่มต้นของใบเรือ
    path.close(); // ปิดใบเรือ

    // วาดใบเรืออีกใบหนึ่ง (ถ้าต้องการ)
    path.moveTo(width * 0.5, height * 0.3); // จุดเริ่มต้น
    path.lineTo(width * 0.3, height * 0.0); // ใบเรือซ้าย
    path.lineTo(width * 0.5, height * 0.3); // กลับมาที่จุดเริ่มต้น
    path.close(); // ปิดใบเรือซ้าย

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
