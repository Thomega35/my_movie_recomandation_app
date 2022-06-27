import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_movie_recomandation_app/Core/constants.dart';
import 'package:my_movie_recomandation_app/Core/widgets/primary_button.dart';
import 'package:my_movie_recomandation_app/Features/movie_flow/movie_flow_controller.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Let\'s find a movie!',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Image.asset('images/undraw_horror_movie.png'),
            const Spacer(),
            PrimaryButton(
              text: 'Get Started',
              onPressed: ref.read(movieFlowControllerProvider.notifier).nextPage,
            ),
            const SizedBox(height: kMediumSpacing),

          ],
        ),
      ),
    );
  }
}