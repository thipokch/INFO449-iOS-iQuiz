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
    var question:Question!
    var correctAnswerIndex:Int
    var chosenAnswerIndex:Int
    var isCorrect:Bool {
        get {
            return correctAnswerIndex == chosenAnswerIndex
        }
    }
    
    init(question: Question, chosenAnswerIndex:Int, correctAnswerIndex:Int) {
        self.question = question
        self.chosenAnswerIndex = chosenAnswerIndex
        self.correctAnswerIndex = correctAnswerIndex
    }
    
    func addQuestion(question:Question) {
        self.question = question
    }
}
