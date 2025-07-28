import 'package:ffabious_space/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Brand Website',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: MyTheme.textTheme,
      ),
      home: PrimaryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrimaryPage extends StatefulWidget {
  const PrimaryPage({super.key});

  @override
  State<PrimaryPage> createState() => _PrimaryPageState();
}

class _PrimaryPageState extends State<PrimaryPage> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentIndex = 0;
  bool _isAnimating = false;
  double _scrollAccumulator = 0.0;
  static const double _scrollThreshold = 200.0; // Moderate threshold
  bool _cooldownActive = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('primaryPage'),
      backgroundColor: MyTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Listener(
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerScrollEvent) {
                  // Completely ignore scroll events during cooldown or animation
                  if (_isAnimating || _cooldownActive) {
                    return;
                  }

                  _scrollAccumulator += pointerSignal.scrollDelta.dy;

                  if (_scrollAccumulator > _scrollThreshold) {
                    // Scroll down - go to next page
                    if (_currentIndex < 2) {
                      _scrollAccumulator = 0.0;
                      _isAnimating = true;
                      _cooldownActive = true;
                      _pageController
                          .nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                          .then((_) {
                            _isAnimating = false;
                            // Reset accumulator and start cooldown
                            _scrollAccumulator = 0.0;
                            Future.delayed(Duration(milliseconds: 200)).then((
                              _,
                            ) {
                              _cooldownActive = false;
                            });
                          });
                    } else {
                      _scrollAccumulator = 0.0; // Reset if at last page
                    }
                  } else if (_scrollAccumulator < -_scrollThreshold) {
                    // Scroll up - go to previous page
                    if (_currentIndex > 0) {
                      _scrollAccumulator = 0.0;
                      _isAnimating = true;
                      _cooldownActive = true;
                      _pageController
                          .previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                          .then((_) {
                            _isAnimating = false;
                            // Reset accumulator and start cooldown
                            _scrollAccumulator = 0.0;
                            Future.delayed(Duration(milliseconds: 200)).then((
                              _,
                            ) {
                              _cooldownActive = false;
                            });
                          });
                    } else {
                      _scrollAccumulator = 0.0; // Reset if at first page
                    }
                  }
                }
              },
              child: Focus(
                autofocus: true,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      !_isAnimating &&
                      !_cooldownActive) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
                        event.logicalKey == LogicalKeyboardKey.space ||
                        event.logicalKey == LogicalKeyboardKey.pageDown) {
                      if (_currentIndex < 2) {
                        _isAnimating = true;
                        _cooldownActive = true;
                        _pageController
                            .nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                            .then((_) {
                              _isAnimating = false;
                              Future.delayed(Duration(milliseconds: 200)).then((
                                _,
                              ) {
                                _cooldownActive = false;
                              });
                            });
                        return KeyEventResult.handled;
                      }
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                        event.logicalKey == LogicalKeyboardKey.pageUp) {
                      if (_currentIndex > 0) {
                        _isAnimating = true;
                        _cooldownActive = true;
                        _pageController
                            .previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                            .then((_) {
                              _isAnimating = false;
                              Future.delayed(Duration(milliseconds: 200)).then((
                                _,
                              ) {
                                _cooldownActive = false;
                              });
                            });
                        return KeyEventResult.handled;
                      }
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    _buildHomeCard(),
                    _buildAboutCard(),
                    _buildBlogPostsCard(),
                  ],
                ),
              ),
            ),
            // Page indicators
            Positioned(
              right: 32,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == i
                            ? MyTheme.accentColor
                            : MyTheme.textColor.withValues(alpha: 0.3),
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

  Widget _buildHomeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Card(
          color: MyTheme.cardColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Hi! I'm ",
                            style: MyTheme.textTheme.displaySmall,
                          ),
                          Text("Kirill", style: MyTheme.textTheme.displayLarge),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'It\'s nice to see you on my personal website!',
                        style: MyTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: MyTheme.textColor.withValues(alpha: 0.6),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Scroll down to learn more',
                            style: MyTheme.textTheme.bodyMedium?.copyWith(
                              color: MyTheme.textColor.withValues(alpha: 0.6),
                              fontSize: 14,
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
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Card(
          color: MyTheme.cardColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Me', style: MyTheme.textTheme.displayMedium),
                  SizedBox(height: 40),
                  Text(
                    'I\'m a passionate developer who loves creating beautiful and functional applications. With expertise in Flutter, Dart, and modern web technologies, I enjoy turning ideas into reality.',
                    style: MyTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'My journey in software development started several years ago, and I\'ve been constantly learning and growing ever since. I believe in writing clean, maintainable code and creating user experiences that delight.',
                    style: MyTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 40),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _buildSkillChip('Flutter'),
                      _buildSkillChip('Dart'),
                      _buildSkillChip('JavaScript'),
                      _buildSkillChip('React'),
                      _buildSkillChip('Node.js'),
                      _buildSkillChip('Firebase'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlogPostsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Card(
          color: MyTheme.cardColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Blog Posts',
                    style: MyTheme.textTheme.displayMedium,
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildBlogPostItem(
                          'Getting Started with Flutter',
                          'A comprehensive guide to building your first Flutter application...',
                          '2 days ago',
                        ),
                        SizedBox(height: 24),
                        _buildBlogPostItem(
                          'Advanced Dart Features',
                          'Exploring powerful Dart language features that will make your code more elegant...',
                          '1 week ago',
                        ),
                        SizedBox(height: 24),
                        _buildBlogPostItem(
                          'State Management in Flutter',
                          'Understanding different approaches to state management and when to use each...',
                          '2 weeks ago',
                        ),
                        SizedBox(height: 24),
                        _buildBlogPostItem(
                          'Building Responsive UIs',
                          'Creating beautiful interfaces that work across all screen sizes...',
                          '3 weeks ago',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MyTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyTheme.accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        skill,
        style: MyTheme.textTheme.bodyMedium?.copyWith(
          color: MyTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBlogPostItem(String title, String excerpt, String date) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MyTheme.headerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyTheme.textColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: MyTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                date,
                style: MyTheme.textTheme.bodyMedium?.copyWith(
                  color: MyTheme.textColor.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            excerpt,
            style: MyTheme.textTheme.bodyMedium?.copyWith(
              color: MyTheme.textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
