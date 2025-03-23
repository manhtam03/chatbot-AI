import 'package:flutter/material.dart';
import 'package:chatbot/screen/chat_page.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'You AI Assistant',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  'Using this software, you can ask you questions and receive articles using artificial intelligence assistant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54
                  ),
                )
              ],
            ),
            SizedBox(height: 32,),
            Image.asset('assets/onboarding.png'),
            SizedBox(height: 32,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatScreen()),
                          (route) => false
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded,size: 20, color: Theme.of(context).colorScheme.surface,)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}