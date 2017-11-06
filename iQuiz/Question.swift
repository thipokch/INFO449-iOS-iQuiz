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
    private let question:String
    private var correctAnswer:String
    private var answers:[String]
    
    init(question:String, answers:[String], correctAnswer:String) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.answers = answers
    }
}
