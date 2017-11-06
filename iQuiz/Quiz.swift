//
//  Quiz.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation
import UIKit

class Quiz {
    private(set) var title:String
    var description:String?
    var image:UIImage?
    private var questions:[Question]
    private var answers:[Answer]
    //  Return complete even though there is no question
    var isCompleted:Bool {
        get {
            return questions.count == answers.count
        }
    }
    
    init(_ title:String) {
        self.title = title
        self.questions = []
        self.answers = []
    }
    
    func addQuestion(question:Question) {
        questions.append(question)
    }
    
    func addQuestion(question:String, answers:[String], correctAnswer:String) {
        let newQuestion = Question(question: question, answers: answers, correctAnswer: correctAnswer)
        questions.append(newQuestion)
    }
    
    func addAnswer(answer:Answer) {
        answers.append(answer)
    }
    
    func addAnswer(question: Question, chosenAnswer:String, correctAnswer:String) {
        let newAnswer = Answer(question: question, chosenAnswer: chosenAnswer, correctAnswer: correctAnswer)
        answers.append(newAnswer)
    }
}
