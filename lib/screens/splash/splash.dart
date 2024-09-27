part of 'splash_imports.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    autoRoute();
  }

  void autoRoute() async {
    await Future.delayed(const Duration(seconds: 3));
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Navigate based on whether the user is logged in or not
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OptionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.6,
              image: const AssetImage("assets/icons/blogLogo.png"),
            ),
            const SizedBox(height: 30),
            const Text(
              "MyBlog",
              style: TextStyle(
                fontSize: 37.0,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
