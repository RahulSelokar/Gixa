import 'package:Gixa/Modules/cutoff/model/cutoff_model.dart';
import 'package:flutter/material.dart';

class CutoffCollegeCard extends StatelessWidget {
  final CutoffCollegeModel college;

  const CutoffCollegeCard({super.key, required this.college});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(college.name),
        subtitle: Text("${college.city}, ${college.state}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Rank ${college.cutoffRank}"),
            Text("${college.cutoffMarks} Marks",
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
