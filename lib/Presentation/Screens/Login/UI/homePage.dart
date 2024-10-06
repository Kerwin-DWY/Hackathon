import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // API Gateway endpoint for Bedrock
  final String apiUrl = 'https://cjz4ldve59.execute-api.us-west-2.amazonaws.com/Project/InvokeBedrock';

  // List to hold the conversation messages
  List<Map<String, String>> messages = [];

  // Controller for the input field
  final TextEditingController inputController = TextEditingController();

  // Variable to keep track of the conversation step
  int conversationStep = 0;

  Future<void> sendMessage(String userInput) async {
    setState(() {
      // Add patient's message to the conversation
      messages.add({'sender': 'patient', 'text': userInput});
    });

    // Prepare the prompt based on the conversation step
    if (conversationStep == 0) {
      // First step: Collect symptoms
      setState(() {
        messages.add({'sender': 'ai', 'text': 'Can you provide your medical history?'});
      });
    } else if (conversationStep == 1) {
      // Second step: Collect medical history
      setState(() {
        messages.add({'sender': 'ai', 'text': 'Is there anything else important for me to know?'});
      });
    } else if (conversationStep == 2) {
      // Third step: Final analysis
      String symptoms = messages[1]['text'] ?? '';
      String medicalHistory = messages[3]['text'] ?? '';
      String additionalInfo = userInput;
      String prompt = "Patient's symptoms: $symptoms.\nMedical history: $medicalHistory.\nAdditional information: $additionalInfo.\nBased on this information, what are the possible diagnoses?";

      try {
        // Send the POST request to the API Gateway for Bedrock
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'prompt': prompt,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          String aiResponse = responseData['filtered_output'] ?? 'No response from AI';

          setState(() {
            // Add AI's response to the conversation
            messages.add({'sender': 'ai', 'text': aiResponse});
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get AI response. Error code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    // Increment the conversation step
    conversationStep++;
  }

  // Reset the conversation
  void resetConversation() {
    setState(() {
      messages.clear();
      conversationStep = 0;
      messages.add({'sender': 'ai', 'text': 'What symptoms do you have?'});
    });
  }

  @override
  void initState() {
    super.initState();
    // Start the conversation with the AI's first question
    messages.add({'sender': 'ai', 'text': 'What symptoms do you have?'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Consultation"),
        backgroundColor: Colors.teal,
        actions: [
          // Add the reset button in the app bar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetConversation, // Call resetConversation when clicked
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isPatient = message['sender'] == 'patient';
                return Align(
                  alignment: isPatient ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isPatient ? Colors.teal[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(message['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (inputController.text.trim().isNotEmpty) {
                      sendMessage(inputController.text.trim());
                      inputController.clear();
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
