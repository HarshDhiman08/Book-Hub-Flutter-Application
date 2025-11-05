import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BookHubApp());
}

class BookHubApp extends StatelessWidget {
  const BookHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookHub',
      theme: ThemeData(
        primaryColor: const Color(0xFF2D2A5A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2D2A5A),
        ),
        fontFamily: 'Arial',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2A5A),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding:
            const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            side: const BorderSide(color: Color(0xFF2D2A5A)),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF2D2A5A)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

/// ---------------- AuthGate ----------------
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const OnboardingScreen();
        }
        return const OnboardingScreen();
      },
    );
  }
}

/// ---------------- Background ----------------
class AppBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const AppBackground({
    super.key,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.white),
          ),
        ),
        Container(color: Colors.white.withOpacity(0.0)),
        child,
      ],
    );
  }
}

/// ---------------- Onboarding Screen ----------------
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imagePath: "assets/splash_background.png",
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "All your books in one place on Readium.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2D2A5A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------- Login Screen ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imagePath: "assets/login_signup_background.png",
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Your next favorite books is waiting!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A),
                  ),
                ),
                const SizedBox(height: 160),
                const Text(
                  "BOOKHUB",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2A5A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                const Text("or"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("Google"),
                    const SizedBox(width: 16),
                    _socialButton("Facebook"),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: const Text(
                    "Create a new account? Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2D2A5A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Color(0xFF2D2A5A))),
    );
  }
}

/// ---------------- Signup Screen ----------------
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatController = TextEditingController();
  bool isLoading = false;

  Future<void> _signup() async {
    if (passwordController.text.trim() != repeatController.text.trim()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        imagePath: "assets/login_signup_background.png",
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Start reading your favorite books today!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A),
                  ),
                ),
                const SizedBox(height: 120),
                const Text(
                  "BOOKHUB",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: repeatController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Repeat Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2A5A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign up",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                const Text("or"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("Google"),
                    const SizedBox(width: 16),
                    _socialButton("Facebook"),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text(
                    "Already have an account? Log in",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2D2A5A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _socialButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Color(0xFF2D2A5A))),
    );
  }
}

/// ---------------- Pick Favorites Screen ----------------
class PickFavoritesScreen extends StatefulWidget {
  const PickFavoritesScreen({super.key});

  @override
  State<PickFavoritesScreen> createState() => _PickFavoritesScreenState();
}

class _PickFavoritesScreenState extends State<PickFavoritesScreen> {
  // Track selected books
  final Set<int> selectedBooks = {};

  // Example books list (local images you manage manually)
  final List<Map<String, String>> books = [
    {"title": "The Great Gatsby", "image": "assets/book1.jpg"},
    {"title": "1984", "image": "assets/book2.jpg"},
    {"title": "To Kill a Mockingbird", "image": "assets/book3.jpg"},
    {"title": "Pride & Prejudice", "image": "assets/book4.jpg"},
    {"title": "Moby Dick", "image": "assets/book6.jpg"},
    {"title": "The Powerfull Youth", "image": "assets/book5.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Readium",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2A5A))),
              const SizedBox(height: 20),
              const Text(
                "Pick your favorites",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A5A)),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  itemCount: books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    final isSelected = selectedBooks.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedBooks.remove(index);
                          } else {
                            selectedBooks.add(index);
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade200,
                              image: DecorationImage(
                                image: AssetImage(book["image"]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Text(
                              book["title"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? const Color(0xFF2D2A5A) : Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text("Skip"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text("Continue"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- Crossref API service & models ----------------

class CrossrefService {
  // The user provided API
  static const String _baseUrl =
      'https://api.crossref.org/works?filter=has-full-text:true&mailto=GroovyBib@example.org';

  Future<List<CrossrefItem>> fetchWorks({int rows = 20}) async {
    final uri = Uri.parse('$_baseUrl&rows=$rows');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load works (status: ${response.statusCode})');
    }
    final jsonBody = json.decode(response.body);
    final message = jsonBody['message'];
    final items = message != null ? message['items'] as List<dynamic> : [];
    return items.map((e) => CrossrefItem.fromJson(e)).toList();
  }
}

class CrossrefItem {
  final String title;
  final List<String> authors;
  final String doi;
  final String publisher;
  final String publishedDate;
  final String type;
  final String url;

  CrossrefItem({
    required this.title,
    required this.authors,
    required this.doi,
    required this.publisher,
    required this.publishedDate,
    required this.type,
    required this.url,
  });

  factory CrossrefItem.fromJson(Map<String, dynamic> json) {
    final titleList = (json['title'] as List<dynamic>?)?.cast<String>() ?? ['No title'];
    final authorList = (json['author'] as List<dynamic>?)?.map<String>((a) {
      final given = a['given'] as String? ?? '';
      final family = a['family'] as String? ?? '';
      final name = ('$given $family').trim();
      return name.isEmpty ? 'Unknown' : name;
    }).toList() ??
        ['Unknown'];

    String published = '';
    if (json['published-print'] != null && json['published-print']['date-parts'] != null) {
      final parts = (json['published-print']['date-parts'][0] as List<dynamic>).map((e) => e.toString()).toList();
      published = parts.join('-');
    } else if (json['published-online'] != null && json['published-online']['date-parts'] != null) {
      final parts = (json['published-online']['date-parts'][0] as List<dynamic>).map((e) => e.toString()).toList();
      published = parts.join('-');
    } else {
      published = 'Unknown date';
    }

    return CrossrefItem(
      title: titleList.first,
      authors: authorList,
      doi: json['DOI'] as String? ?? 'N/A',
      publisher: json['publisher'] as String? ?? 'Unknown',
      publishedDate: published,
      type: json['type'] as String? ?? 'work',
      url: (json['URL'] as String?) ?? '',
    );
  }
}

/// ---------------- Home / Bottom Navigation ----------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const CurrentlyReadingScreen(),
    const LibraryScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF2D2A5A),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Library"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/// ---------------- Currently Reading (uses Crossref for recommendations) ----------------
class CurrentlyReadingScreen extends StatefulWidget {
  const CurrentlyReadingScreen({super.key});

  @override
  State<CurrentlyReadingScreen> createState() => _CurrentlyReadingScreenState();
}

class _CurrentlyReadingScreenState extends State<CurrentlyReadingScreen> {
  final CrossrefService service = CrossrefService();
  late Future<List<CrossrefItem>> _futureWorks;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _futureWorks = service.fetchWorks(rows: 8);
  }

  /// Pick a random image from assets/book1.jpg → book9.jpg
  String getRandomBookImage() {
    int index = _random.nextInt(9) + 1; // 1 to 9 inclusive
    return 'assets/book$index.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Readium",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2A5A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Recommended from Crossref",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<CrossrefItem>>(
                future: _futureWorks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Failed to load: ${snapshot.error}'));
                  }

                  final list = snapshot.data ?? [];
                  if (list.isEmpty) return const Center(child: Text('No works found'));

                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final randomImage = getRandomBookImage();

                      return GestureDetector(
                        onTap: () async {
                          if (item.url.isNotEmpty) {
                            final uri = Uri.parse(item.url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No link available')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  randomImage,
                                  height: 88,
                                  width: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.authors.join(', '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(item.publisher, style: const TextStyle(fontSize: 12)),
                                        const SizedBox(width: 12),
                                        Text(item.publishedDate, style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () async {
                                  final doiUri = Uri.parse('https://doi.org/${item.doi}');
                                  if (await canLaunchUrl(doiUri)) {
                                    await launchUrl(doiUri);
                                  }
                                },
                                icon: const Icon(Icons.open_in_new, size: 20),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// ---------------- Library Screen ----------------
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final CrossrefService _service = CrossrefService();
  late Future<List<CrossrefItem>> _futureItems;
  String _query = '';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _futureItems = _service.fetchWorks(rows: 40);
  }

  void _search(String q) {
    setState(() => _query = q.trim().toLowerCase());
  }

  List<CrossrefItem> _filter(List<CrossrefItem> items) {
    if (_query.isEmpty) return items;
    return items
        .where((it) => (it.title + " " + it.authors.join(' '))
        .toLowerCase()
        .contains(_query))
        .toList();
  }

  /// Pick a random image from assets/book1.jpg → book9.jpg
  String getRandomBookImage() {
    int index = _random.nextInt(9) + 1; // 1 to 9 inclusive
    return 'assets/book$index.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Library',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2A5A)),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search title or author',
                  border: OutlineInputBorder()),
              onChanged: _search,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<CrossrefItem>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  final items = _filter(snapshot.data ?? []);
                  if (items.isEmpty) return const Center(child: Text('No results'));

                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final it = items[index];
                      final randomImage = getRandomBookImage();

                      return GestureDetector(
                        onTap: () async {
                          if (it.url.isNotEmpty) {
                            final uri = Uri.parse(it.url);
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          }
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.asset(
                                  randomImage,
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(it.authors.join(', '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(it.publishedDate,
                                            style:
                                            const TextStyle(fontSize: 12)),
                                        IconButton(
                                          onPressed: () async {
                                            final doiUri =
                                            Uri.parse('https://doi.org/${it.doi}');
                                            if (await canLaunchUrl(doiUri))
                                              await launchUrl(doiUri);
                                          },
                                          icon: const Icon(Icons.open_in_new,
                                              size: 18),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Profile Screen ----------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D2A5A))),
                PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'logout') {
                      // logout -> back to splash/onboarding
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()), (route) => false);
                    } else if (v == 'version') {
                      showAboutDialog(context: context, applicationName: 'BookHub', applicationVersion: '1.2.0', children: const [Text('Crossref-powered demo')]);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'version', child: Text('App version')),
                    const PopupMenuItem(value: 'logout', child: Text('Logout')),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset('assets/profile.jpg', height: 88, width: 88, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Harsh Dhiman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('harshdhiman7400@gmail.com'),
                          SizedBox(height: 6),
                          Text('Chandigarh University'),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('My Library'),
                    subtitle: const Text('Saved & purchased works'),
                    onTap: () {
                      // optionally navigate to Library tab
                      // find ancestor HomeScreen and set index if needed
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    subtitle: const Text('Manage preferences'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

