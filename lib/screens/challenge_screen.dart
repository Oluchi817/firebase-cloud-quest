
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/challenge_service.dart';
import '../services/reward_service.dart';
import '../services/coach_service.dart';

class ChallengeScreen extends StatefulWidget {
  final User user;

  const ChallengeScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChallengeScreen> createState() =>
      _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {

  final AuthService _authService = AuthService();
  final ChallengeService _challengeService = ChallengeService();
  final RewardService _rewardService = RewardService();
  final CoachService _coachService = CoachService();

  final TextEditingController _questionController =
      TextEditingController();

  Map<String, Object?>? _challenge;
  Map<String, dynamic>? _progress;

  String _coachReply = '';
  String _errorMessage = '';
  String _rewardMessage = '';

  bool _isLoading = true;
  bool _isCompleting = false;
  bool _isAskingCoach = false;

  bool get _isCompleted =>
      _progress?['completed'] == true;

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  // Load today's challenge and learner progress.
  Future<void> _loadChallenge() async {

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await _challengeService.loadToday();

      if (!mounted) return;

      setState(() {
        _challenge =
            data['challenge'] as Map<String, Object?>;

        final progress = data['progress'];

        _progress = progress == null
            ? null
            : Map<String, dynamic>.from(progress as Map);

        _isLoading = false;
      });

    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Unable to load your challenge. Please try again.';

        _isLoading = false;
      });
    }
  }

  // Ask the AI Quest Coach for a hint.
  Future<void> _askCoach() async {

    final question = _questionController.text.trim();

    if (question.isEmpty) {
      setState(() {
        _coachReply = 'Please enter a question first.';
      });
      return;
    }

    setState(() {
      _isAskingCoach = true;
      _coachReply = '';
    });

    try {
      final reply =
          await _coachService.getQuestHint(question);

      if (!mounted) return;

      setState(() {
        _coachReply = reply;
      });

    } catch (error) {
      if (!mounted) return;

      setState(() {
        _coachReply =
            'The Quest Coach is unavailable. Please try again.';
      });

    } finally {
      if (mounted) {
        setState(() {
          _isAskingCoach = false;
        });
      }
    }
  }

  // Request the trusted reward from Firebase.
  Future<void> _completeChallenge() async {

    if (_isCompleting || _isCompleted) return;

    setState(() {
      _isCompleting = true;
      _rewardMessage = '';
    });

    try {
      final result =
          await _rewardService.completeChallenge();

      if (!mounted) return;

      final points = result['points'];
      final badgeId = result['badgeId'];
      final alreadyCompleted =
          result['alreadyCompleted'] == true;

      setState(() {
        _progress = {
          'completed': true,
          'points': points,
          'badgeId': badgeId,
        };

        _rewardMessage = alreadyCompleted
            ? 'You already completed this quest. Your reward is saved.'
            : 'Quest completed! You earned $points points and the First Quest badge!';
      });

    } catch (error) {
      if (!mounted) return;

      setState(() {
        _rewardMessage =
            'Unable to complete your quest. Please try again.';
      });

    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await _authService.logOut();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cloud Quest'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadChallenge,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final title = _challenge?['title']?.toString()
        ?? "Today's Quest";

    final prompt = _challenge?['prompt']?.toString()
        ?? 'No challenge prompt is available.';

    return Scaffold(

      appBar: AppBar(
        title: const Text('Firebase Cloud Quest'),

        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          // Learner information.
          Text(
            'Welcome, ${widget.user.email ?? 'Learner'}!',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // Challenge information.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Today's Challenge",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(prompt),

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Current progress.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Status: ${_isCompleted ? 'Completed' : 'In Progress'}',
                  ),

                  Text(
                    'Points: ${_progress?['points'] ?? 0}',
                  ),

                  Text(
                    'Badge: ${_progress?['badgeId'] ?? 'Not earned yet'}',
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // AI Quest Coach.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.smart_toy,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AI Quest Coach',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Need help? Ask the Quest Coach for a hint.',
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: _questionController,
                    maxLength: 300,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Enter your question',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,

                    child: OutlinedButton(
                      onPressed: _isAskingCoach
                          ? null
                          : _askCoach,

                      child: _isAskingCoach
                          ? const CircularProgressIndicator()
                          : const Text('Get Hint'),
                    ),
                  ),

                  if (_coachReply.isNotEmpty) ...[
                    const SizedBox(height: 16),

                    const Text(
                      'AI-generated advice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(_coachReply),
                  ],

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Completion action.
          SizedBox(
            width: double.infinity,
            height: 52,

            child: FilledButton.icon(

              onPressed:
                  _isCompleting || _isCompleted
                      ? null
                      : _completeChallenge,

              icon: const Icon(Icons.check_circle),

              label: Text(
                _isCompleted
                    ? 'Challenge Completed'
                    : _isCompleting
                        ? 'Processing Reward...'
                        : 'Complete Challenge',
              ),
            ),
          ),

          if (_rewardMessage.isNotEmpty) ...[
            const SizedBox(height: 16),

            Card(
              color: Colors.green.shade50,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Text(
                  _rewardMessage,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

        ],
      ),
    );
  }
}