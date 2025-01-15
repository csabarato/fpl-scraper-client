import 'package:flutter/material.dart';

class ManagerCaptainCard extends StatelessWidget {
  const ManagerCaptainCard(this.managerName, this.playerName, {super.key});

  final String managerName;
  final String playerName;

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
                  child: Text(managerName)),
              Text(playerName)
            ],
          ),
        ),
      ),
    );
  }
}
