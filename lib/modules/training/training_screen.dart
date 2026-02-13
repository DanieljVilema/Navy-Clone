import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // ── HEADER BANNER ──
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOFFS Workout Library',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Naval Operational Fitness and Fueling Series - Select a workout category below to browse available routines.',
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),

          // ── WORKOUT CATEGORIES ──
          _WorkoutExpandableCategory(
            title: 'Command PT - Endurance',
            workoutCount: '15 workouts',
            exercises: [
              'Continuous Run 30 min',
              '400m Intervals x 8',
              'Fartlek Run 40 min',
              'Progressive Run',
              'Tempo Run 25 min',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'FEP - Upper Body Strength',
            workoutCount: '12 workouts',
            exercises: [
              'Progressive Push-ups',
              'Diamond Push-ups',
              'Military Plank',
              'Parallel Bar Dips',
              'Wide-arm Push-ups',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Core & Abdominals',
            workoutCount: '10 workouts',
            exercises: [
              'Standard Curl-ups',
              'Front Plank Hold',
              'Mountain Climbers',
              'Russian Twists',
              'Bicycle Crunches',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Swimming & Cardio',
            workoutCount: '8 workouts',
            exercises: [
              '450m Swim Technique',
              'Pool Intervals',
              'Aquatic Resistance',
              'Combined Cardio',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Flexibility & Mobility',
            workoutCount: '8 workouts',
            exercises: [
              'Dynamic Stretching',
              'Military Yoga',
              'Joint Mobility',
              'Complete Cool-down',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Cycling & Rowing',
            workoutCount: '6 workouts',
            exercises: [
              '12 min Bike Test',
              '2000m Row Preparation',
              'Bike Intervals',
              'Alt. Cardio Endurance',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Full Body Workouts',
            workoutCount: '10 workouts',
            exercises: [
              'Total Body Circuit',
              'Strength Endurance',
              'Combat Conditioning',
              'Functional Fitness',
            ],
          ),
          _WorkoutExpandableCategory(
            title: 'Pre-PRT Preparation',
            workoutCount: '6 workouts',
            exercises: [
              'PRT Simulation',
              'Event-specific Training',
              'Peak Week Protocol',
              'Recovery Routine',
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _WorkoutExpandableCategory extends StatefulWidget {
  final String title;
  final String workoutCount;
  final List<String> exercises;

  const _WorkoutExpandableCategory({
    required this.title,
    required this.workoutCount,
    required this.exercises,
  });

  @override
  State<_WorkoutExpandableCategory> createState() =>
      _WorkoutExpandableCategoryState();
}

class _WorkoutExpandableCategoryState
    extends State<_WorkoutExpandableCategory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.workoutCount,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            color: Colors.grey.shade50,
            padding: const EdgeInsets.fromLTRB(36, 4, 20, 12),
            child: Column(
              children: widget.exercises.map((exercise) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: NavyPFAApp.navyPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          exercise,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}