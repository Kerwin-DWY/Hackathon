import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController symptomsController = TextEditingController();

  // Corrected API Gateway endpoint
  final String apiUrl = 'https://cjz4ldve59.execute-api.us-west-2.amazonaws.com/Project/InvokeBedrock';

  // Function to send the data to the API Gateway
  Future<void> submitSymptoms() async {
    final String symptoms = symptomsController.text;

    if (symptoms.isEmpty) {
      // If the input field is empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your symptoms')),
      );
      return;
    }

    try {
      // Send the POST request to the API Gateway
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': symptoms,  // Send the symptoms in the request body
        }),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Symptoms submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit symptoms. Error code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Symptom Entry"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your symptoms below:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: symptomsController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Symptoms',
                hintText: 'e.g., fever, cough, headache',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  // Call the submit function when the button is pressed
                  submitSymptoms();
                },
                child: const Text(
                  'Submit Symptoms',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
