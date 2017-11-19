//
//  Question.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/4/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation
import os.log

// Support one correct answer only
class Question: NSObject, NSCoding {
    // MARK: - Variables
    let text:String
    private(set) var correctAnswerIndex:Int
    private(set) var answers:[String]
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(Int32(correctAnswerIndex), forKey: "correctAnswerIndex")
        aCoder.encode(answers, forKey: "answers")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let text = aDecoder.decodeObject(forKey: "text") as? String ?? ""
        let correctAnswerIndex = aDecoder.decodeInteger(forKey: "correctAnswerIndex")
        guard let answers = aDecoder.decodeObject(forKey: "answers") as? [String]
            else {
                return nil
        }
        
        self.init(question:text, answers: answers, correctAnswerIndex:correctAnswerIndex)
    }
    
    // MARK: - Method
    init(question:String, answers:[String], correctAnswerIndex:Int) {
        self.text = question
        self.correctAnswerIndex = correctAnswerIndex
        self.answers = answers
    }
    
    convenience init?(JSONObject:Any) {
        guard let object = JSONObject as? [String : Any],
            let text = object["text"] as? String,
            let correctAnswerIndex = Int(object["answer"] as! String),
            let answers = object["answers"] as? [String]
            else {
                os_log("Unable to serialize Question from JSON", log: OSLog.default, type: .debug)
                return nil
        }
        
        self.init(question: text, answers: answers, correctAnswerIndex: correctAnswerIndex)
    }
}
