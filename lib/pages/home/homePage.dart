import 'package:flutter/material.dart';
import 'package:odc_mobile_template/pages/actualite/ActualitePage.dart';
import 'package:odc_mobile_template/pages/community/CommunityPage.dart';
import 'package:odc_mobile_template/pages/evenement/EvenementPage.dart';
import 'package:odc_mobile_template/pages/media/MediaPage.dart';
import 'package:odc_mobile_template/pages/ui/customNavigationBar/CustomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    ActualitePage(),
    CommunityPage(),
    MediaPage(),
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
