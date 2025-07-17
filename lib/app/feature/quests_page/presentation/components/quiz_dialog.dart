import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quest.dart';
import 'package:valli_di_comacchio/app/feature/quests_page/domain/quiz_quest.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h2/h2.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class QuizDialog extends StatelessWidget {
  const QuizDialog({
    super.key,
    required this.quest,
    required this.onQuestCompleted,
  });

  final QuizQuest quest;
  final Function(BasicQuest) onQuestCompleted;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary_light,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.palette_primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        SvgPicture.asset(
                          AppIcons.quiz,
                          height: 40,
                          colorFilter: ColorFilter.mode(
                            AppColors.palette_tertiary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8),
                        H2(
                          'Quiz',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 8),
                        LabelText('Domanda'),
                        Text(
                          quest.quiz.question,
                          style: AppTextStyles.labelOnPaletteLight,
                        ),
                        SizedBox(height: 16),
                        LabelText('Risposte:'),
                        ...quest.quiz.answers.map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: InkWell(
                              onTap: () {
                                if (answer.correct) {
                                  onQuestCompleted(quest);
                                } else {
                                  final questFailed = quest.copyWith(
                                    userShouldReceiveReward: false,
                                  );
                                  onQuestCompleted(questFailed);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.palette_secondary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.palette_primary,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  answer.answer,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.palette_primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            // Close button positioned at top right
            Positioned(
              top: 4,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
