
import 'package:flutter/material.dart';

class PlayerPickCard extends StatelessWidget {
  const PlayerPickCard(this.participantName, this.multiplier, {super.key});

  final String participantName;
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 200.0,
                  child: Text(participantName)),

              Text(getPlayerRoleText(multiplier))
            ],
          ),
        ),
      ),
    );
  }

  String getPlayerRoleText(int multiplier) {
    switch (multiplier) {
      case 0: return 'Bench';
      case 1: return 'Starting 11';
      case 2: return 'Captain';
      case 3: return 'Triple captain';
      default: return '';
    }
  }
}
