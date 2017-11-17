//
//  Quiz.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

//  Assumes that the user answers in order

import Foundation
import UIKit

class Quiz {
    private(set) var title:String
    var description:String?
    var image:UIImage?
    private(set) var questions:[Question]
    private(set) var answers:[Answer]
    var numOfCorrectAnswers:Int {
        get {
            var count = 0
            for answer in answers {
                if answer.isCorrect {
                    count += 1
                }
            }
            return count
        }
    }
    //  Return complete even though there is no question
    var isCompleted:Bool {
        get {
            return questions.count == answers.count
        }
    }
    
    var answeredOnQuestionNum:Int {
        get {
            return answers.count
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
    
    func addQuestion(question:String, answers:[String], correctAnswerIndex:Int) {
        let newQuestion = Question(question: question, answers: answers, correctAnswerIndex: correctAnswerIndex)
        questions.append(newQuestion)
    }
    
    func addAnswer(answer:Answer) {
        answers.append(answer)
    }
    
    func addAnswer(question: Question, chosenAnswerIndex:Int, correctAnswerIndex:Int) {
        let newAnswer = Answer(question: question, chosenAnswerIndex: chosenAnswerIndex, correctAnswerIndex: correctAnswerIndex)
        answers.append(newAnswer)
    }
}
