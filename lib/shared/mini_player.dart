import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muon_workout_tracker/database/providers/routine_session_provider.dart';
import 'package:muon_workout_tracker/shared/expanded_mini_player.dart';

class MiniPlayer extends ConsumerStatefulWidget {
  const MiniPlayer({super.key});

  @override
  MiniPlayerState createState() => MiniPlayerState();
}

class MiniPlayerState extends ConsumerState<MiniPlayer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final routineSession = ref.watch(routineSessionProvider.notifier);
    final isRunning = ref.watch(routineSessionProvider)?.isRunning ?? false;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ExpandedMiniPlayer(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Define the animation: Slide transition from bottom
              const begin = Offset(0.0, 1.0); // Starts from the bottom
              const end = Offset.zero; // Ends at the center
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          const Hero(
            tag: "Progress",
            child: LinearProgressIndicator(value: .8),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton.filled(
                      onPressed: () {}, icon: const Icon(Icons.fitness_center)),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bench press'),
                      Text('10kg x 12'),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        routineSession.togglePause();
                      },
                      icon: Icon(isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded)),
                  IconButton(
                      onPressed: () {
                        routineSession.discard();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
