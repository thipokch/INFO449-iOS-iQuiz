//
//  Question.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

// Support one correct answer only
class Question {
    let text:String
    private(set) var correctAnswerIndex:Int
    private(set) var answers:[String]
    
    init(question:String, answers:[String], correctAnswerIndex:Int) {
        self.text = question
        self.correctAnswerIndex = correctAnswerIndex
        self.answers = answers
    }
}
