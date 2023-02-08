import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  static const routeName = '/about';
  static final Uri _url =
      Uri.parse('https://github.com/malachibazar/Astro-Flow');
  static final Uri _zapierUrl =
      Uri.parse('https://zapier.com/blog/flowtime-technique/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'This app is a simple stopwatch based on the flowtime technique.\n',
            ),
            Text(
              'What is it?',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              width: 400,
              child: Text(
                'Flowtime is a time management technique that helps you focus on your work by not making you take constant breaks. The idea is that you work for as long as you can keep focus, and then take a break. You are awarded more break time for longer work sessions.\n',
              ),
            ),
            // an unordered list of each interval and the time awarded.
            Text(
              'These are the work intervals and the break time awarded for each:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Text(
              '\u2022 For 25 minutes of work or less, take a five-minute break.\n\u2022 For 25-50 minutes of work, take an eight-minute break.\n\u2022 For 50-90 minutes of work, take a 10-minute break. \n\u2022 For more than 90 minutes of work, take a 15-minute break.\n',
            ),
            const Text(
              'For more information on the technique, visit the website below.\n',
            ),
            TextButton(
              onPressed: () => launchUrl(_zapierUrl),
              child: const Text('Zapier - Flowtime Technique'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'The app is open source and the code is available on GitHub.',
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () => launchUrl(_url),
              child: const Text('View Source Code'),
            ),
          ],
        ),
      ),
    );
  }
}
