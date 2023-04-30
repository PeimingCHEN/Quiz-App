# Quiz App for iOS

A feature-rich iOS Quiz App built with Swift, Xcode, and UIKit, offering a seamless user experience with multiple-choice and numerical questions, editable question management, custom drawing capabilities, and persistent data storage.

![Quiz App Icon](demo/icon.png)

## Screenshots

<div align="center">

| <img src="demo/mcq.png" width="250" height="500"> | <img src="demo/mcq_correct.png" width="250" height="500"> | <img src="demo/mcq_incorrect.png" width="250" height="500"> |
|:------------------------------------------:|:--------------------------------------------:|:----------------------------------------------:|
|       Multiple-choice Questions            |      Correct MCQ Answer Selected             |     Incorrect MCQ Answer Selected              |

| <img src="demo/score_more_incorrect.png" width="250" height="500"> | <img src="demo/score_more_correct.png" width="250" height="500"> |
|:------------------------------------------------------:|:--------------------------------------------------:|
|        Score with Red Background (More Incorrect Answers)  |      Score with Green Background (More Correct Answers)  |

| <img src="demo/numerical_questions.png" width="250" height="500"> | <img src="demo/numerical_list.png" width="250" height="500"> | <img src="demo/detail_view.png" width="250" height="500"> |
|:----------------------------------------------------:|:---------------------------------------------------:|:------------------------------------:|
|       Numerical Fill-in-the-blank Questions          |        List of Numerical Questions                  |      Detail View for Editing        |

| <img src="demo/drawing_canvas.png" width="250" height="500"> | <img src="demo/detail_view_drawing.png" width="250" height="500"> |
|:------------------------------------------:|:-------------------------------------------------------:|
|         Drawing Canvas                     |          Detail View with Saved Drawing                |

</div>

## Features

- Multiple-choice and numerical fill-in-the-blank questions with real-time score display and background color indicators.
- Editable UITableView for managing numerical questions and UINavigationController for a drill-down interface.
- Custom drawing capabilities and question image attachments using UIImagePickerController.
- Data persistence ensure quiz and user progress is saved between app runs.
- Adaptive UIStackViews and responsive design for landscape and portrait orientations.
