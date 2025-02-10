import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import 'package:video_player/video_player.dart'; // Import video player package

void main() {
  runApp(LoveCalculatorApp());
}

class LoveCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Calculator',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoveCalculatorScreen(),
    );
  }
}

class LoveCalculatorScreen extends StatefulWidget {
  @override
  _LoveCalculatorScreenState createState() => _LoveCalculatorScreenState();
}

class _LoveCalculatorScreenState extends State<LoveCalculatorScreen> {
  TextEditingController _himController = TextEditingController();
  TextEditingController _herController = TextEditingController();
  String _lovePercentage = '';
  bool _isLoading = false;
  late VideoPlayerController _videoPlayerController;
  bool _videoFinished = false;

  @override
  void initState() {
    super.initState();
    // Initialize video player controller with a sample video
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/promise.mp4')
          ..initialize().then((_) {
            setState(() {});
          })
          ..addListener(() {
            // Check if the video has finished playing
            if (_videoPlayerController.value.position ==
                _videoPlayerController.value.duration) {
              setState(() {
                _videoFinished = true;
                _showMessagePopup(); // Show message after video finishes
              });
            }
          });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

void _calculateLove() {
  setState(() {
    _isLoading = true;
    _lovePercentage = ''; // Reset the result
    _videoFinished = false; // Reset video finished state
    // Stop the video if it's playing and reset it
    _videoPlayerController.seekTo(Duration.zero);
    _videoPlayerController.pause();
  });

  // Get the entered names
  String himName = _himController.text.trim().toLowerCase();
  String herName = _herController.text.trim().toLowerCase();

  // Simulate a delay for the "Ask Cupid" process
  Duration delayDuration = Duration(seconds: 2); // Default delay

  // If the names are "john" and "anjana", increase the delay time
  if (himName == 'john' && herName == 'anjana') {
    delayDuration = Duration(seconds: 18); // Longer delay for these names
  }

  // Simulate the delay with the set duration
  Future.delayed(delayDuration, () {
    setState(() {
      _isLoading = false;

      // If both names are "john" and "anjana", show error and play video
      if (himName == 'john' && herName == 'anjana') {
        _showErrorDialog();
      } else {
        // Generate a random love percentage
        _lovePercentage = '${Random().nextInt(101)}%';
      }
    });
  });
}


  // Show the error dialog with video
 // Show the error dialog with video
void _showErrorDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing when clicked outside
    builder: (context) {
      return AlertDialog(
        title: Text("Calculator Crashed 🚨"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Love Overload! The calculator has crashed."),
            SizedBox(height: 20),
            // Check if video is initialized before showing
            _videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                : Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    },
  );

  // Play the video when the error dialog is shown
  _videoPlayerController.play();
}



  // Show the message card in a popup after the video ends
  void _showMessagePopup() {
    // Close the video dialog if it's still open
    Navigator.of(context).pop();

    // Now show the message popup
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Happy Promise Day ❤️"),
          content: Container(
            width: double.maxFinite,
            child: Card(
              color: Colors.deepPurple, // Customize your card color
              margin: EdgeInsets.all(16), // Adjust margin as needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Optional: for rounded corners
              ),
              child: Center( // Centering the content within the Card
                child: Padding(
                  padding: EdgeInsets.all(16), // Add padding around the text
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To ensure Column shrinks to fit content
                    children: [
                      Text(
                        "You’re all I’ve ever wanted, and more than I ever imagined. Thank you for loving me in ways I never thought possible, for making me feel truly seen and cherished. I promise to always appreciate and love you with all that I am, because you’re everything to me.",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "- Happy Promise Day My Love 🐒❤️😘🥹😍🥰",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Love Calculator ❤️'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.pink.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // His Name input
            _buildTextField(_himController, 'His Name'),

            SizedBox(height: 15),

            // Her Name input
            _buildTextField(_herController, 'Her Name'),

            SizedBox(height: 30),

            // Ask Cupid button
            ElevatedButton(
              onPressed: _calculateLove,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                textStyle: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
              child: Text('Ask Cupid 👼🏹💖'),
            ),

            SizedBox(height: 30),

            // Display loading or love percentage result
            _isLoading
                ? SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  )
                : Text(
                    _lovePercentage,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the styled TextField
  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.pinkAccent),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
