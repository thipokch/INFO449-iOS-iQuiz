//
//  Answer.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation

// Case sensitive
class Answer: NSObject, NSCoding  {
    
    // MARK: - Variables
    var question:Question!
    var chosenAnswerIndex:Int
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        let questionData = NSKeyedArchiver.archivedData(withRootObject: question)
        aCoder.encode(questionData, forKey: "question")
        aCoder.encode(chosenAnswerIndex, forKey: "chosenAnswerIndex")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let questionData = aDecoder.decodeObject(forKey: "question"),
            let question = NSKeyedUnarchiver.unarchiveObject(with: questionData as! Data) as? Question
            else {
                return nil
        }
        let chosenAnswerIndex = aDecoder.decodeInteger(forKey: "chosenAnswerIndex")
        self.init(question: question, chosenAnswerIndex: chosenAnswerIndex)
    }
    
    // MARK: - Computed Properties
    var isCorrect:Bool {
        get {
            return correctAnswerIndex == chosenAnswerIndex
        }
    }
    
    var correctAnswerIndex:Int {
        get {
            return question.correctAnswerIndex
        }
    }
    
    // MARK: - Methods
    init(question: Question, chosenAnswerIndex:Int) {
        self.question = question
        self.chosenAnswerIndex = chosenAnswerIndex
    }
    
    func addQuestion(question:Question) {
        self.question = question
    }
}
