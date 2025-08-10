import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final void Function(int)? onStepTapped; // <- tambahkan ini

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    this.onStepTapped, // <- dan ini
  });

  @override
  Widget build(BuildContext context) {
    final double circleDiameter = 40;
    final double connectorWidth = 30;
    final double totalWidth =
        circleDiameter * totalSteps + connectorWidth * (totalSteps - 1);

    return Center(
      child: SizedBox(
        width: totalWidth,
        height: 70,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: totalSteps,
          separatorBuilder: (_, __) => const DottedLineConnector(),
          itemBuilder: (context, index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return GestureDetector(
              onTap: () => onStepTapped?.call(index), // <- aksi klik
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isActive
                        ? AppColors.darkBlue  
                        : isCompleted
                            ? AppColors.darkBlue
                            : Colors.grey.shade300,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: (isActive || isCompleted)
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DottedLineConnector extends StatelessWidget {
  const DottedLineConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 40, // tinggi connector agar pas dengan lingkaran
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (_) => Container(
            width: 4,
            height: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
