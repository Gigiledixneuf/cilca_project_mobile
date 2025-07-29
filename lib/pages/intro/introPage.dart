import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../utils/navigationUtils.dart';
import 'appCtrl.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);  // Point de départ plus haut

    // Première courbe plus prononcée
    var firstControlPoint = Offset(size.width * 0.25, size.height - 10);
    var firstEndPoint = Offset(size.width * 0.4, size.height - 50);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy,
    );

    // Seconde courbe plus dynamique
    var secondControlPoint = Offset(size.width * 0.65, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage> {
  var navigation = getIt<NavigationUtils>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var ctrl = ref.read(appCtrlProvider.notifier);
      ctrl.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // Top handle indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 16, bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Main content container
                Container(
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Image section avec arrondi en bas
                      _buildHeroImageSection(isTablet),

                      // Content section
                      _buildContentSection(context, isTablet),
                    ],
                  ),
                ),

                // Bottom spacing
                SizedBox(height: isTablet ? 40 : 32),

                // Bottom indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImageSection(bool isTablet) {
    final imageHeight = isTablet ? 320.0 : 280.0;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(100),
        bottomRight: Radius.circular(100),
      ),
      child: Container(
        height: imageHeight,
        width: double.infinity,
        child: Image.asset(
          "assets/communaute/proches.jpg",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback en cas d'erreur
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isTablet ? 40 : 24,
        isTablet ? 32 : 24,
        isTablet ? 40 : 24,
        isTablet ? 40 : 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre principal
          _buildTitleSection(isTablet),

          SizedBox(height: isTablet ? 24 : 20),

          // Description
          _buildDescriptionSection(isTablet),

          SizedBox(height: isTablet ? 40 : 32),

          // Boutons
          _buildButtonsSection(context, isTablet),
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isTablet) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isTablet ? 28 : 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: Colors.black87,
        ),
        children: [
          const TextSpan(text: "Ensemble, transformons "),
          TextSpan(
            text: "l'espoir",
            style: TextStyle(
              color: const Color(0xFF7B4397),
            ),
          ),
          const TextSpan(text: " en "),
          TextSpan(
            text: "force",
            style: TextStyle(
              color: const Color(0xFF7B4397),
            ),
          ),
          const TextSpan(text: " contre le cancer"),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(bool isTablet) {
    return Text(
      "Rejoignez une communauté bienveillante où patients, proches et experts partagent leurs expériences et ressources pour mieux avancer ensemble.",
      style: TextStyle(
        fontSize: isTablet ? 16 : 14,
        color: Colors.black54,
        height: 1.5,
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context, bool isTablet) {
    return Column(
      children: [
        // Bouton S'inscrire avec icône
        Container(
          width: double.infinity,
          height: isTablet ? 56 : 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B4397), Color(0xFF9C4D97)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B4397).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () {
                navigation.replace('/public/auth/registerPage');
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: isTablet ? 20 : 18,
                    ),
                    SizedBox(width: isTablet ? 12 : 10),
                    Text(
                      'S\'inscrire',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: isTablet ? 24 : 20),

        // Bouton Connexion avec icône
        Container(
          width: double.infinity,
          height: isTablet ? 56 : 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.black12,
              width: 1.5,
            ),
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () {
                navigation.replace('/public/auth/loginPage');
              },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.login,
                      color: Colors.black87,
                      size: isTablet ? 20 : 18,
                    ),
                    SizedBox(width: isTablet ? 12 : 10),
                    Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: isTablet ? 20 : 16),

        // Lien invité avec icône
        InkWell(
          onTap: () {
            navigation.replace('/public/ui/mainNavigation');
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility,
                  color: Colors.black45,
                  size: isTablet ? 18 : 16,
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Text(
                  'Continuer en tant qu\'invité',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}