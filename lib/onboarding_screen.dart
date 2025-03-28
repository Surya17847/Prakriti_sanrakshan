import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/login_signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/img8.jpg",
      "text": "Take care of the earth and she will take care of you.",
    },
    {
      "image": "assets/images/img7.jpg",
      "text": "Welcome! Let's build a better tomorrow.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background to white
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) => OnboardingContent(
              image: onboardingData[index]["image"]!,
              text: onboardingData[index]["text"]!,
            ),
          ),

          // Page Indicator
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          // Button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (currentPage == onboardingData.length - 1) {
                  // Navigate to login/signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginSignUpScreen()),
                  );
                } else {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.green,
              ),
              child: Text(
                currentPage == onboardingData.length - 1
                    ? "GET STARTED"
                    : "NEXT",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, text;
  OnboardingContent({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Ensuring background remains white
      child: Column(
        children: [
          SizedBox(height: 75),
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Rounded corners
            child: Image.asset(
              image,
              height: 250,
              width: 300, // Adjust width as needed
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 125),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
