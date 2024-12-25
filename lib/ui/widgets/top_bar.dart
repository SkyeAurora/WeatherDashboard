import 'package:flutter/material.dart';
import '../../constants.dart';
class TopBar extends StatelessWidget implements PreferredSizeWidget
{
  final TextEditingController _cityController = TextEditingController();

  final Function(String) onCitySearch;

  TopBar({required this.onCitySearch});

   @override
  Size get preferredSize => Size.fromHeight(80.0); // 设置高度

  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: Column(
                  children: [
                    TextField(
                      controller: _cityController, // 绑定 TextEditingController
                      cursorColor: Colors.white, // 设置光标颜色为白色
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.white), // 设置图标颜色为白色
                        hintText: "输入城市名称查询天气",
                        hintStyle: const TextStyle(color: Colors.white), // 设置提示文本颜色为白色
                        filled: false, // 启用填充背景
                        fillColor: Colors.white, // 设置背景颜色为白色
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // 设置边框颜色为白色
                          borderRadius: BorderRadius.circular(8.0), // 圆角边框
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0), // 未聚焦时的边框颜色
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 1.0), // 聚焦时的边框颜色
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        // 处理用户输入的城市名称
                        onCitySearch(value); // 调用搜索处理函数
                      },
                    ),
                  ],
                ),
              )
    );
  }
  
}