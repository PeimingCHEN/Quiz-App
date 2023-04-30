//
//  ViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 11/22/22.
//

import UIKit

class MCQViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerField: UILabel!
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var nextQuestionBtn: UIButton!
    
    let questions:[String] = [
        "My full name?",
        "My school & major?",
        "Favorite NBA athlete?"
    ]
    let answers: [String] = [
        "Peiming Chen",
        "UCI MSWE 22fall",
        "Stephen Curry"
    ]
    let data: [[[String]]] = [
        [
            ["Bob", "Peiming", "Jackon", "Amy"],
            ["Chen", "Cai", "Huang", "Android"]
        ],
        [
            ["UCLA", "UCB", "UCSD", "UCI", "UCSB", "UCR"],
            ["MCS", "MSWE", "MDS", "MSSE", "other"],
            ["21fall", "22fall", "23fall"]
        ],
        [
            ["Kevin", "LeBron", "Stephen", "James"],
            ["James", "Curry", "Durant", "Harden"]
        ],
        
    ]
    var userAnswers: [String?] = [nil, nil, nil]
    var currentQuestionIndex: Int = 0
    var submitCount: Int = 0
    var temp: [String] = []
    
    // Next Questions button click to change questions and pickerview by explicitly calling viewDidload()
    @IBAction func showNextQuestion(_ sender: UIButton){
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count{
            currentQuestionIndex = 0
        }
        viewDidLoad()
        if let ans = userAnswers[currentQuestionIndex], !ans.isEmpty {
            answerField.text = ans
            answerField.isEnabled = false
            picker.isUserInteractionEnabled = false // cannot input
            // display answer
            answerLabel.isHidden = false
            answerLabel.text = "Answer: \(answers[currentQuestionIndex])"
            if ans == answers[currentQuestionIndex] {
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
            answerField.text = "???"
            answerField.isEnabled = true
            picker.isUserInteractionEnabled = true
            answerLabel.isHidden = true
            correctLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if questionLabel != nil {
            questionLabel.text = questions[currentQuestionIndex]
        }
        temp = Array(repeating: "", count: data[currentQuestionIndex].count)
        if picker != nil {
            picker.dataSource = self
            picker.delegate = self
        }
        if submitBtn != nil {
            submitBtn.isEnabled = false
        }
        
        // init the score according to the save data
        let tabbar = tabBarController as! BaseTabBarController
        for question in tabbar.QuestionStore.allQuestions {
            if question.useranswer != nil {
                if question.answer == question.useranswer {
                    Score.sharedInstance.correct += 1
                } else {
                    Score.sharedInstance.incorrect += 1
                }
            }
        }
    }
    
    
    //Click Submit button to submit answer and lock edit
    @IBAction func submitAnswer(_ sender: Any){
        submitCount += 1
        submitBtn.isEnabled = false // cannot re-submitted
        answerField.isEnabled = false
        picker.isUserInteractionEnabled = false // cannot input
        if let text = answerField.text {
            userAnswers[currentQuestionIndex] = text
            // display answer
            answerLabel.isHidden = false
            answerLabel.text = "Answer: \(answers[currentQuestionIndex])"
            if text == answers[currentQuestionIndex] {
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
        if submitCount == questions.count{
            nextQuestionBtn.isEnabled = false
        }
    }
    
    func updateview() {
        picker.isUserInteractionEnabled = true
        answerLabel.isHidden = true
        correctLabel.isHidden = true
        submitCount = 0
        userAnswers = [nil, nil, nil]
        currentQuestionIndex = 0
    }
}

extension MCQViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data[currentQuestionIndex].count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[currentQuestionIndex][component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[currentQuestionIndex][component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        temp[component] = data[currentQuestionIndex][component][row]
        submitBtn.isEnabled = true
        answerField.text = temp.joined(separator: " ")
    }
}
