//
//  NumViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 11/27/22.
//

import UIKit

class NumViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var nextQuestionBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var currentQuestionIndex: Int = 0
    var submitCount: Int = 0
    var showed: Bool = false
    
    // Next Questions button click to change questions and clear textfield
    @IBAction func showNextQuestion(_ sender: UIButton){
        currentQuestionIndex += 1
        let tabbar = tabBarController as! BaseTabBarController
        if currentQuestionIndex == tabbar.QuestionStore.allQuestions.count{
            currentQuestionIndex = 0
        }
        
        let question: String = tabbar.QuestionStore.allQuestions[currentQuestionIndex].question
        questionLabel.text = question
        let imageToDisplay = tabbar.imageStore.image(forKey: tabbar.QuestionStore.allQuestions[currentQuestionIndex].imageKey)
        imageView.image = imageToDisplay
        if let ans = tabbar.QuestionStore.allQuestions[currentQuestionIndex].useranswer {
            textField.text = String(ans)
            textField.isEnabled = false
            // display answer
            answerLabel.isHidden = false
            answerLabel.text = "Answer: \(String(tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer))"
            if ans == tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer {
                // display the correct or incorrect
                correctLabel.isHidden = false
                correctLabel.text = "CORRECT"
                correctLabel.textColor = UIColor.green
            } else {
                correctLabel.isHidden = false
                correctLabel.text = "INCORRECT"
                correctLabel.textColor = UIColor.red
            }
            
        } else {
            textField.text = ""
            textField.isEnabled = true
            answerLabel.isHidden = true
            correctLabel.isHidden = true
        }
    }
    
    //Click Submit button to submit answer and lock edit
    @IBAction func submitAnswer(_ sender: Any){
        let tabbar = tabBarController as! BaseTabBarController
        submitCount += 1
        textField.isEnabled = false // cannot change answer after submitted
        submitBtn.isEnabled = false // cannot re-submitted
        if let text = textField.text, let value = Float(text) {
            tabbar.QuestionStore.allQuestions[currentQuestionIndex].useranswer = value
            // display answer
            answerLabel.isHidden = false
            answerLabel.text = "Answer: \(String(tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer))"
            if value == tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer {
                Score.sharedInstance.correct += 1
                // display the correct or incorrect
                correctLabel.isHidden = false
                correctLabel.text = "CORRECT"
                correctLabel.textColor = UIColor.green
            } else {
                Score.sharedInstance.incorrect += 1
                correctLabel.isHidden = false
                correctLabel.text = "INCORRECT"
                correctLabel.textColor = UIColor.red
            }
        }
        
        if submitCount == tabbar.QuestionStore.allQuestions.count{
            nextQuestionBtn.isEnabled = false
        }
    }
    
    // textfield editing change event to show submit button
    @IBAction func answerFieldEditingChanged(_ textField: UITextField){
        if let text = textField.text, !text.isEmpty {
            submitBtn.isEnabled = true
        } else {
            submitBtn.isEnabled = false
        }
    }
    
    // click background to cancel keyboard
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    // the textfield can only input one "."
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        if existingTextHasDecimalSeparator != nil,
           replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbar = tabBarController as! BaseTabBarController
        questionLabel.text = tabbar.QuestionStore.allQuestions[currentQuestionIndex].question
        let imageToDisplay = tabbar.imageStore.image(forKey: tabbar.QuestionStore.allQuestions[currentQuestionIndex].imageKey)
        imageView.image = imageToDisplay
        showed = true
        if tabbar.QuestionStore.allQuestions[currentQuestionIndex].useranswer != nil {
            answerLabel.isHidden = false
            answerLabel.text = "Answer: \(String(tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer))"
            textField.isEnabled = false
            submitBtn.isEnabled = false
            textField.text = String(tabbar.QuestionStore.allQuestions[currentQuestionIndex].useranswer!)
            if tabbar.QuestionStore.allQuestions[currentQuestionIndex].useranswer! == tabbar.QuestionStore.allQuestions[currentQuestionIndex].answer {
                // display the correct or incorrect
                correctLabel.isHidden = false
                correctLabel.text = "CORRECT"
                correctLabel.textColor = UIColor.green
            } else {
                correctLabel.isHidden = false
                correctLabel.text = "INCORRECT"
                correctLabel.textColor = UIColor.red
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as! BaseTabBarController
        let imageToDisplay = tabbar.imageStore.image(forKey: tabbar.QuestionStore.allQuestions[currentQuestionIndex].imageKey)
        imageView.image = imageToDisplay
    }
    
    func updateview() {
        textField.text = ""
        textField.isEnabled = true
        answerLabel.isHidden = true
        correctLabel.isHidden = true
        submitCount = 0
        currentQuestionIndex = 0
        let tabbar = tabBarController as! BaseTabBarController
        questionLabel.text = tabbar.QuestionStore.allQuestions[currentQuestionIndex].question
        let imageToDisplay = tabbar.imageStore.image(forKey: tabbar.QuestionStore.allQuestions[currentQuestionIndex].imageKey)
        imageView.image = imageToDisplay
    }
}
