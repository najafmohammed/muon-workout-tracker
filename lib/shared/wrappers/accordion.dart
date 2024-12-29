import 'package:flutter/material.dart';
import 'package:muon_workout_tracker/constants/styles.dart';

class AccordionWrapper extends StatefulWidget {
  final String notificationTitle; // Title of the accordion with notification
  final Widget child; // The wrapped widget inside the accordion
  final bool isExpandedInitially; // Initial expanded/collapsed state
  final Icon icon;
  const AccordionWrapper({
    Key? key,
    required this.notificationTitle,
    required this.child,
    required this.icon,
    this.isExpandedInitially = false, // Default is collapsed
  }) : super(key: key);

  @override
  _AccordionWrapperState createState() => _AccordionWrapperState();
}

class _AccordionWrapperState extends State<AccordionWrapper> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpandedInitially; // Set initial state
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded; // Update expansion state
          });
        },
        title: Row(
          children: [
            Expanded(
              child: Text(widget.notificationTitle, style: AppTextStyle.large),
            ),
            // Show notification badge (if needed, customizable)
            if (!isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: widget.icon,
              ),
          ],
        ),
        trailing: Icon(
          isExpanded
              ? Icons.keyboard_arrow_up // Collapse indicator
              : Icons.keyboard_arrow_down, // Expand indicator
          size: 24.0,
        ),
        children: [
          widget.child,
        ],
      ),
    );
  }
}
