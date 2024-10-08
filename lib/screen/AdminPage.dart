import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_aten/controller/product_controller.dart';
import 'package:flutter_aten/models/product_model.dart';
import 'package:flutter_aten/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../controller/auth_service.dart';
import '../page/EditProductPage.dart';
import '../widget/customCliper.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  List<Productmodel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .onLogout(); // เรียกฟังก์ชัน logout จาก controller

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final productList = await ProductController().getProducts(context);
      setState(() {
        products = productList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')));
    }
  }

  // ฟังก์ชันสำหรับการแก้ไขสินค้า
  void updateProduct(Productmodel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  Future<void> deleteProduct(Productmodel product) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // แสดงกล่องยืนยันก่อนทำการลบ
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // ปิดกล่องและส่งค่ากลับ false
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true); // ปิดกล่องและส่งค่ากลับ true
              },
            ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      try {
        final response =
            await ProductController().deleteProduct(context, product.id);

        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/admin');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
          // เรียกใช้งาน _fetchProducts เพื่อดึงข้อมูลสินค้าใหม่
          await _fetchProducts();
        } else if (response.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff3ABEFF), // สีฟ้าคราม
                          Color(0xff89D8E0), // สีฟ้าอ่อน
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'จัดการ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff1B83A9), // สีฟ้าครามเข้ม
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                              color: Color(0xff0288A0), // สีฟ้ากลาง
                              fontSize: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<UserProvider>(
                      builder: (context, UserProvider, _) {
                        return Column(
                          children: [
                            Text(
                              'Access Token : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${UserProvider.accessToken}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff1B83A9), // สีฟ้าครามเข้ม
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Refresh Token : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${UserProvider.refreshToken}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff3ABEFF), // สีฟ้าครามอ่อน
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                AuthService().refreshToken(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xff0288A0), // สีฟ้ากลาง
                              ),
                              child: Text(
                                'Update Token',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // Button to add new product
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/insertProduct');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0288A0), // สีฟ้ากลาง
                      ),
                      child: Text(
                        'เพิ่มสินค้าใหม่',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Products List or loading/error
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildProductList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 5, 0, 148), // สีฟ้ากลาง
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      children: List.generate(products.length, (index) {
        final product = products[index];
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xff89D8E0), // สีฟ้าอ่อน (ธีมทะเล)
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1B83A9), // สีฟ้าครามเข้ม
                      ),
                    ),
                    Text(
                      'ประเภท: ${product.productType}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff3ABEFF), // สีฟ้าครามอ่อน
                      ),
                    ),
                    Text(
                      'ราคา: \$${product.price}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff0288A0), // สีฟ้ากลาง
                      ),
                    ),
                    Text(
                      'หน่วย: ${product.unit}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff89D8E0), // สีฟ้าอ่อน
                      ),
                    ),
                  ],
                ),
              ),
              // ปุ่มแก้ไขและลบ
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 0, 0, 0), // สีฟ้าครามอ่อน
                ),
                onPressed: () {
                  updateProduct(product); // เรียกฟังก์ชันแก้ไข
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 186, 3, 3), // สีฟ้าครามเข้ม
                ),
                onPressed: () {
                  deleteProduct(product); // เรียกฟังก์ชันลบ
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
