import 'package:flutter/material.dart';
import '../../constants.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onCitySearch;

  const TopBar({Key? key, required this.onCitySearch}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final TextEditingController _cityController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _handleSearch(String value) {
    if (value.trim().isEmpty) return; // 如果输入为空，直接返回
    if (_isSearching) return; // 如果正在搜索，直接返回

    setState(() {
      _isSearching = true;
    });

    // 调用搜索处理函数
    widget.onCitySearch(value);

    // 重置搜索状态
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              cursorColor: Colors.white,
              enabled: !_isSearching,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _isSearching 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white70,
                        ),
                      )
                    : null,
                hintText: _isSearching ? "搜索中..." : "输入城市名称查询天气",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: _handleSearch,
            ),
          ],
        ),
      ),
    );
  }
}