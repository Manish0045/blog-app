part of 'option_screen_imports.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  void moveToRegister(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUp()));
  }

  void moveToLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 30.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/bg2.jpg"),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45.0,
                  ),
                ),
              ),
            ),
            RoundedButton(
              buttonText: "Sign In",
              onPressed: () {
                moveToLogin(context);
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            RoundedButton(
              buttonText: "Sign Up",
              onPressed: () {
                moveToRegister(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
