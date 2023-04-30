//
//  NumQuestion.swift
//  Quiz
//
//  Created by Peiming Chen on 11/30/22.
//

import UIKit

class NumQuestion: Equatable, Codable{
    var question: String
    var useranswer: Float?
    var answer: Float
    let dateCreated: Date
    let imageKey: String
    
    static func ==(lhs: NumQuestion, rhs: NumQuestion) -> Bool {
        return lhs.question == rhs.question
            && lhs.dateCreated == rhs.dateCreated
//        && lhs.useranswer == rhs.useranswer
//        && lhs.answer == rhs.answer
    }
    
    init(question: String, answer: Float, useranswer: Float?) {
        self.question = question
        self.answer = answer
        self.useranswer = useranswer
        self.dateCreated = Date()
        self.imageKey = UUID().uuidString
    }
    
    convenience init() {
        self.init(question: "", answer: 0, useranswer: nil)
    }
}
