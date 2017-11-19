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
import os.log

class Quiz: NSObject, NSCoding  {
    // MARK: - Variables
    private(set) var title:String
    var descriptionText:String?
    var image:UIImage?
    private(set) var questions:[Question]
    private(set) var answers:[Answer]
    // Archiving
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("quizzes")
    
    // MARK: - Properties
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
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(descriptionText, forKey: "descriptionText")
        aCoder.encode(image, forKey: "image")
        let questionsData = NSKeyedArchiver.archivedData(withRootObject: questions)
        aCoder.encode(questionsData, forKey: "questions")
        let answersData = NSKeyedArchiver.archivedData(withRootObject: answers)
        aCoder.encode(answersData, forKey: "answers")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as? String ?? ""
        
        let image = aDecoder.decodeObject(forKey: "image") as? UIImage
        guard let questionsData = aDecoder.decodeObject(forKey: "questions"),
            let questions = NSKeyedUnarchiver.unarchiveObject(with: questionsData as! Data) as? [Question],
            let answersData = aDecoder.decodeObject(forKey: "answers"),
            let answers = NSKeyedUnarchiver.unarchiveObject(with: answersData as! Data) as? [Answer]
            else {
                return nil
        }
        
        self.init(title: title, descriptionText: descriptionText, image: image, questions: questions, answers: answers)
    }
    
    // MARK: - Methods
    init(_ title:String) {
        self.title = title
        self.questions = []
        self.answers = []
    }
    
    init(title:String, descriptionText:String?, image:UIImage?, questions:[Question], answers:[Answer]) {
        self.title = title
        self.descriptionText = descriptionText
        self.image = image
        self.questions = questions
        self.answers = answers
    }
    
    convenience init?(JSONObject:Any) {
        guard let object = JSONObject as? [String : Any],
            let title = object["title"] as? String,
            let descriptionText = object["desc"] as? String,
            let questionObjects = object["questions"] as? [Any]
            else {
                os_log("Unable to serialize Quiz from JSON", log: OSLog.default, type: .debug)
                return nil
        }
        
        var questions:[Question] = []
        for questionObject in questionObjects {
            if let question = Question(JSONObject: questionObject) {
                questions.append(question)
            }
        }
        
        self.init(title: title, descriptionText: descriptionText, image: nil, questions: questions, answers: [])
        
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
        let newAnswer = Answer(question: question, chosenAnswerIndex: chosenAnswerIndex)
        answers.append(newAnswer)
    }
}
