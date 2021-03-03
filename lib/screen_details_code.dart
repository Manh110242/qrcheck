import 'package:flutter/material.dart';

class ScreenDetailsCode extends StatefulWidget {
  @override
  _ScreenDetailsCodeState createState() => _ScreenDetailsCodeState();
}

class _ScreenDetailsCodeState extends State<ScreenDetailsCode> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Nội dung mã"),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, value){
              return[
                SliverList(delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network('https://i.pinimg.com/originals/b7/3b/3f/b73b3ff7cf3373d7b30335558e9d6997.png', width: double.infinity,height: 200,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            child: Text("Tên dang được cạp nhật", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17,),)),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text("Giá đang được cập nhật", overflow: TextOverflow.ellipsis,),
                            SizedBox(width: 15,),
                            Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Flag_of_Vietnam.svg/300px-Flag_of_Vietnam.svg.png', width: 30,height: 20,),
                            SizedBox(width: 5,),
                            Text("Việt nam", overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-EIfqUJVfvLYk4dIEk4IBGCO6dE93KYTSTA&usqp=CAU', width: 30,height: 20,),
                            Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                child: Text(" 123456789123", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15,),)),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.blueAccent
                      ),
                        isScrollable: true,
                        tabs: [
                          Container(
                            height: 50,
                            child: Center(
                              child:
                              Text('Thông tin sản phẩm', style: TextStyle(fontSize: 17),),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Center(
                              child:
                              Text('Nhật ký truy xuất', style: TextStyle(fontSize: 17),),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Center(
                              child:
                                Text('Tìm kiếm/ So sánh', style: TextStyle(fontSize: 17),),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Center(
                              child:
                              Text('Thanh toán tại siêu thị', style: TextStyle(fontSize: 17),),
                            ),
                          ),
                        ]
                    ),
                  ),
                ])),
              ];
            },
            body: TabBarView(
              children: [
                Container(color: Colors.red,),
                Container(color: Colors.blue,),
                Container(color: Colors.indigo,),
                Container(color: Colors.purple,),
              ],
            ),
          ),
        )
    );
  }
}
