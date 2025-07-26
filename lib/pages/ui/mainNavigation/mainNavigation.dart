import 'package:flutter/material.dart';
import 'package:odc_mobile_template/pages/actualite/ArticlePage.dart';
import 'package:odc_mobile_template/pages/evenement/EvenementPage.dart';
import 'package:odc_mobile_template/pages/communaute/forum/ForumPage.dart';
import 'package:odc_mobile_template/pages/home/homePage.dart';
import 'package:odc_mobile_template/pages/ui/customNavigationBar/CustomNavigationBar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomePage(),
    ArticlePage(),
    ForumPage(),
    Evenementpage(),
    //MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
