//
//  Answer.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

// Case sensitive
class Answer {
    var question:Question
    var correctAnswer:String
    var chosenAnswer:String
    var isCorrect:Bool {
        get {
            return correctAnswer == chosenAnswer
        }
    }
    
    init(question: Question, chosenAnswer:String, correctAnswer:String) {
        self.question = question
        self.chosenAnswer = chosenAnswer
        self.correctAnswer = correctAnswer
    }
    
    func addQuestion(question:Question) {
        self.question = question
    }
}
