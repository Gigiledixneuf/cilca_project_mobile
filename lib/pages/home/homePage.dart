import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:odc_mobile_template/business/models/article/article.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/pages/article/ArticlePage.dart';
import 'package:odc_mobile_template/utils/navigationUtils.dart';
import 'homeCtrl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  var navigattion = getIt.get<NavigationUtils>();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Couleurs du thème
  static const Color primaryPurple = Color(0xFF7B4397);
  static const Color secondaryPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFF7B4397);
  static const Color lightPurple = Color(0xFFF3F4F6);
  static const Color darkPurple = Color(0xFF4C1D95);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningYellow = Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadData();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();
    _slideController.forward();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(HomeCtrlProvider.notifier).getFeaturedArticles();
      ref.read(HomeCtrlProvider.notifier).getLatestArticles();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(HomeCtrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildModernAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 32),
                if (state.isLoading && state.featuredArticles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.error != null && state.featuredArticles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  _buildFeaturedSliderSection(state.featuredArticles),
                const SizedBox(height: 40),
                if (state.isLoading && state.latestArticles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.error != null && state.latestArticles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  _buildLatestArticlesSection(state.latestArticles),
                const SizedBox(height: 32),
                _buildHealthTipsSection(),
                const SizedBox(height: 32),
                _buildTestimonialsSection(),
                const SizedBox(height: 32),
                _buildDailyHopeSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryPurple, primaryPurple],
          ),
        ),
      ),
      title: const Text(
        'CILCA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: _navigateToDonationPage,
            icon: const Icon(Icons.favorite, color: Colors.red, size: 18),
            label: const Text(
              'Faire un don',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  //section pour recuperer les 3 articles du slide
  Widget _buildFeaturedSliderSection(List<Article> articles) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryPurple, secondaryPurple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'À la une',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          itemCount: articles.length,
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 16/10,
            enlargeCenterPage: true,
            viewportFraction: 0.88,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayCurve: Curves.easeInOutCubic,
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildModernFeaturedCard(articles[index]);
          },
        ),
      ],
    );
  }

  //card pour recuperer les 3 articles du slide
  Widget _buildModernFeaturedCard(Article article) {
    final formattedDate = DateFormat('dd MMM yyyy').format(article.date);

    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/public/articles/${article.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  article.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            article.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //section pour recuperer les 5 derniers articles
  Widget _buildLatestArticlesSection(List<Article> articles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accentOrange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Derniers articles',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _navigateToAllArticles,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Voir tout'),
                style: TextButton.styleFrom(
                  foregroundColor: primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == articles.length - 1 ? 0 : 16,
                  ),
                  child: _buildModernLatestArticleCard(articles[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Carte pour afficher les derniers articles
  Widget _buildModernLatestArticleCard(Article article) {
    final formattedDate = DateFormat('dd MMM yyyy').format(article.date);

    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/public/articles/${article.id}'),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge de catégorie
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    article.image,
                    width: 350,
                    height: 140,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 350,
                        height: 140,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 350,
                        height: 140,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Contenu texte
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de l'article
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.3,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Date et bouton Lire la suite
                  Row(
                    children: [
                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_sharp,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Bouton Lire la suite
                      InkWell(
                        onTap: () => GoRouter.of(context).push('/public/articles/${article.id}'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Lire la suite',
                                style: TextStyle(
                                  color: primaryPurple,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: primaryPurple,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //conseil section
  Widget _buildHealthTipsSection() {
    final List<Map<String, dynamic>> _healthTips = [
      {
        'title': 'Hydratation',
        'description': 'Buvez au moins 1,5L d\'eau par jour',
        'icon': Icons.water_drop,
        'color': Colors.blue,
      },
      {
        'title': 'Activité physique',
        'description': '30 min de marche quotidienne',
        'icon': Icons.directions_walk,
        'color': successGreen,
      },
      {
        'title': 'Sommeil',
        'description': '7-8h de sommeil réparateur',
        'icon': Icons.bedtime,
        'color': primaryPurple,
      },
      {
        'title': 'Alimentation',
        'description': '5 fruits et légumes par jour',
        'icon': Icons.restaurant,
        'color': accentOrange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: warningYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Conseils santé du jour',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _healthTips.length,
            itemBuilder: (context, index) {
              return _buildHealthTipCard(_healthTips[index]);
            },
          ),
        ],
      ),
    );
  }

  //card conseil section
  Widget _buildHealthTipCard(Map<String, dynamic> tip) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: tip['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                tip['icon'],
                color: tip['color'],
                size: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tip['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              tip['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //temoignage section
  Widget _buildTestimonialsSection() {
    final List<Map<String, dynamic>> _testimonials = [
      {
        'id': 't1',
        'author': 'Marie, 42 ans',
        'text': 'Cette communauté m\'a donné la force de me battre quand j\'étais au plus bas. Merci à tous pour votre soutien.',
        'avatar': 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
        'rating': 5
      },
      {
        'id': 't2',
        'author': 'Alain, 35 ans',
        'text': 'Les conseils partagés ici m\'ont aidé à mieux comprendre les traitements et à moins les subir.',
        'avatar': 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg',
        'rating': 5
      },
      {
        'id': 't3',
        'author': 'Sonnic, 30 ans',
        'text': 'Les conseils partagés ici m\'ont aidé à mieux comprendre les traitements et à moins les subir.',
        'avatar': 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg',
        'rating': 3
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryPurple, secondaryPurple],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ils témoignent',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _testimonials.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildModernTestimonialCard(_testimonials[index]);
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: _navigateToAllTestimonials,
              icon: const Icon(Icons.forum_outlined),
              label: const Text('Lire plus de témoignages'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryPurple,
                side: const BorderSide(color: primaryPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //card temoignage section
  Widget _buildModernTestimonialCard(Map<String, dynamic> testimonial) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryPurple.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(testimonial['avatar']),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Gestion d'erreur pour l'avatar
                    },
                    child: testimonial['avatar'] == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testimonial['author'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: index < testimonial['rating']
                                ? Colors.amber
                                : Colors.grey[300],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"${testimonial['text']}"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //message d'espoir section
  Widget _buildDailyHopeSection() {
    final String _dailyHopeMessage = "Aujourd'hui, souvenez-vous que chaque petit progrès compte. La guérison est un chemin, pas une destination.";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryPurple.withOpacity(0.1),
            secondaryPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryPurple, secondaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Message d\'espoir',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dailyHopeMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- L\'équipe CILCA',
                      style: TextStyle(
                        color: primaryPurple,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _navigateToAllArticles() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ArticlePage()),
    );
  }

  void _navigateToAllTestimonials() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ArticlePage()),
    );
  }

  void _navigateToDonationPage() {
    print('Navigation vers la page de don');
  }
}