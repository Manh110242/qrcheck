import 'package:flutter/material.dart';
class DKSD extends StatefulWidget {
  @override
  _DKSDState createState() => _DKSDState();
}

class _DKSDState extends State<DKSD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Điều khản sử dụng',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nội dung dịch vụ', style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(height: 10,),
              Text('Cung cấp dịch vụ mạng xã hội cho phép người dùng internet được chia sẻ, trao đổi thông tin về hàng hóa, xuất xứ hàng hóa và đăng tải các thông tin về hàng hóa, xuất xứ hàng hóa lên Ứng dụng QR Check để cùng nhau tham gia bình luận và trao đổi. Cụ thể:'),
              SizedBox(height: 10,),
              Text('-  QR Check cung cấp cho người sử dụng dịch vụ mạng xã hội nhằm chia sẻ, trao đổi thông tin, hình ảnh về hàng hóa và các thông tin của hàng hóa trên Hệ thống Ứng dụng QR Check. '),
              SizedBox(height: 5,),
              Text('-  QR Check cung cấp cho người sử dụng dịch vụ mạng xã hội nhằm chia sẻ, trao đổi thông tin, hình ảnh về hàng hóa và các thông tin của hàng hóa trên Hệ thống Ứng dụng QR Check. '),
              SizedBox(height: 5,),
              Text('-  QR Check cung cấp dịch vụ cho Người Sử Dụng được thực hiện các chức năng thêm điểm bán và mua hàng hóa trên Hệ thống Ứng dụng QR Check.'),
              SizedBox(height: 5,),
              Text('-  QR Check cung cấp nền tảng để bên thứ 3 chủ động sản xuất nội dung cung cấp tới Người Sử Dụng. Bên thứ 3 phải tuân thủ các điều kiện, quy định trong Thỏa Thuận này và Thỏa Thuận Hợp Tác hai bên. '),
              SizedBox(height: 10,),
              Text('Điều khoản sử dụng', style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(height: 10,),
              Text('Để truy cập và thưởng thức Dịch vụ QR Check, Người Sử Dụng phải đồng ý và tuân theo các điều khoản được quy định tại Thỏa thuận này và quy định, quy chế mà QR Check liên kết, tích hợp bao gồm:'),
              SizedBox(height: 10,),
              Text('-   Khi truy cập, sử dụng QR Check bằng bất cứ phương tiện (máy tính, điện thoại, tivi thiết bị kết nối internet) hoặc sử dụng Ứng dụng QR Check thì Người Sử Dụng cũng phải tuân theo Quy chế này.'),
              SizedBox(height: 5,),
              Text('-   Để đáp ứng nhu cầu sử dụng của Người Sử Dụng, QR Check  không ngừng hoàn thiện và phát triển, Quy chế có thể được cập nhật, chỉnh sửa bất cứ lúc nào mà không cần phải thông báo trước tới Người Sử Dụng. Công ty Cổ phần QR Check sẽ công bố rõ trên website, diễn đàn về những thay đổi, bổ sung đó.   '),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
