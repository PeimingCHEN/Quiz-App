//
//  NumQuestionStore.swift
//  Quiz
//
//  Created by Peiming Chen on 11/30/22.
//

import UIKit

class NumQuestionStore {
    
    // Adding the URL that items will be saved to
    let questionArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("num_questions.plist")
    }()
    
    var allQuestions = [
        NumQuestion(question: "3+7?", answer: 10, useranswer: nil),
        NumQuestion(question: "2.2+3.3?", answer: 5.5, useranswer: nil),
        NumQuestion(question: "0.75-0.5?", answer: 0.25, useranswer: nil),
        NumQuestion(question: "6x7", answer: 42, useranswer: nil),
        NumQuestion(question: "3.14x2", answer: 6.28, useranswer: nil),
        NumQuestion(question: "100-50", answer: 50, useranswer: nil)
    ]
    
    func removeQuestion(_ question: NumQuestion){
        if let index = allQuestions.firstIndex(of: question) {
            allQuestions.remove(at: index)
        }
    }
    
    func moveQuestion(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let moveQuestion = allQuestions[fromIndex]
        
        // Remove item from array
        allQuestions.remove(at: fromIndex)
        
        // Insert item in array at new location
        allQuestions.insert(moveQuestion, at: toIndex)
    }
    
    @discardableResult func createQuestion() -> NumQuestion {
        let newQuestion = NumQuestion.init(question: "", answer: 0, useranswer: nil)
        
        allQuestions.append(newQuestion)
        
        return newQuestion
    }
    
    // persist items
    @objc func saveChanges() -> Bool {
        print("Saving questions to: \(questionArchiveURL)")
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allQuestions)
            try data.write(to: questionArchiveURL, options: [.atomic])
            print("Saved all of the questions")
            return true
        } catch let encodingError{
            print("Error encoding allQuestions: \(encodingError)")
            return false
        }
    }
    
    init() {
        // Deserializing archived items
        do {
            let data = try Data(contentsOf: questionArchiveURL)
            let unarchiver = PropertyListDecoder()
            let questions = try unarchiver.decode([NumQuestion].self, from: data)
            allQuestions = questions
        } catch {
            print("Error reading in saved items: \(error)")
        }
        
        // Adding a notification observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
}

