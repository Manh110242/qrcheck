import 'package:flutter/material.dart';

class HuongDanSuDung extends StatefulWidget {
  @override
  _HuongDanSuDungState createState() => _HuongDanSuDungState();
}

class _HuongDanSuDungState extends State<HuongDanSuDung> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Hướng dẫn sữ dụng',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Để tra cứu thông tin sản phẩm, bạn thực hiện theo các bước như sau:', style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(height: 10,),
              Text('Bước 1: Mở ứng dụng QR Check, chọn menu Quét mã'),
              SizedBox(height: 5,),
              Text('Bước 2: Hướng camera vào mã vạch, mã QR trên bao bì sản phẩm'),
              SizedBox(height: 5,),
              Text('Bước 3: Trên app hiển thị màn hình chi tiết sản phẩm. Với tính năng này, ngoài việc kiểm tra thông tin sản phẩm và doanh nghiệp sở hữu, '
                  'bạn có thể tham khảo những đánh giá của cộng đồng về sản phẩm đó; đặt câu hỏi nếu như có bất kỳ thắc mắc nào về sản phẩm để nhận được câu trả lời sớm nhất.'),
            ],
          ),
        ),
      ),
    );
  }
}
