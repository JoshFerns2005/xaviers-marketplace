import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0;
  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        title: Text('Rating & Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rate our service:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 1 ? Color.fromARGB(255, 255, 153, 0) : Colors.grey,size: 30,),
                  onPressed: () => setState(() => _rating = 1),
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 2 ? Color.fromARGB(255, 255, 153, 0) : Colors.grey,size: 30),
                  onPressed: () => setState(() => _rating = 2),
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 3 ? Color.fromARGB(255, 255, 153, 0) : Colors.grey,size: 30),
                  onPressed: () => setState(() => _rating = 3),
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 4 ? Color.fromARGB(255, 255, 153, 0) : Colors.grey,size: 30),
                  onPressed: () => setState(() => _rating = 4),
                ),
                IconButton(
                  icon: Icon(Icons.star, color: _rating >= 5 ? Color.fromARGB(255, 255, 153, 0) : Colors.grey,size: 30),
                  onPressed: () => setState(() => _rating = 5),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _feedbackController,
              maxLines: null, // Allow multiple lines for feedback
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    // You can add your logic here to submit the feedback
    String feedback = _feedbackController.text;
    print('Rating: $_rating');
    print('Feedback: $feedback');
    // Add your code to submit the feedback to a database or server
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: RatingPage(),
  ));
}
