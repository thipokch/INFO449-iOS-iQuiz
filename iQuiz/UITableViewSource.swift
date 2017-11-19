//
//  UITableViewSource.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/5/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation
import UIKit

class UITableViewSource {
    var quizzes = [Quiz("Mathematics"), Quiz("Marvel Super Heroes"), Quiz("Science")]
    
    init() {
        quizzes[0].descriptionText = "Numbers. Algebras. Shapes."
        quizzes[1].descriptionText = "From the world's leading super heroes studio"
        quizzes[2].descriptionText = "Chemistry. Biology. Physics."
        
        quizzes[0].image = UIImage(named: "Mathematics")
        quizzes[1].image = UIImage(named: "Marvel")
        quizzes[2].image = UIImage(named: "Science")
        
        let sample = Question(question: "Why is the world very very very complicated", answers: ["abc","bcd","xyz","zzz"], correctAnswerIndex: 1)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[0].addQuestion(question: sample)
        quizzes[1].addQuestion(question: sample)
        quizzes[2].addQuestion(question: sample)

    }
}
