import 'package:flutter/material.dart';
import 'package:odc_mobile_template/pages/article/ArticlePage.dart';
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
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Si on clique sur l'onglet actif, on revient à la racine
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    ArticlePage(),
    ForumPage(),
    Evenementpage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((page) {
          final index = _pages.indexOf(page);
          return Navigator(
            key: _navigatorKeys[index],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => page,
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
