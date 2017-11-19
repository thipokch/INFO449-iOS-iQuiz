//
//  QuizViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/9/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Variables
    fileprivate var currentViewController:UIViewController!
    fileprivate var nextViewController:UIViewController!
    // Store quiz data
    var quiz:Quiz!{
        didSet {
            // Update the view.
            navigationItem.title = quiz.title
        }
    }
    var saveProgress:(() -> ())! = {
        print("saved nothing")
    }
    private var isAnswering:Bool = false
    
    // MARK: - Properties
    var currentQuestionNum:Int {
        get {
            return quiz.answers.count
        }
    }
    var currentQuestion:Question {
        get {
            return quiz.questions[quiz.answers.count]
        }
    }
    
    // MARK: - View Controller Events
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        if quiz != nil {
            goToNextViewController()
        }
        // Hide the translucent on large title
        parent?.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("swipe right")
                if currentViewController is QuestionViewController && !(self.navigationItem.rightBarButtonItem?.isEnabled)!{
                    break
                } else if currentViewController is QuestionViewController {
                    selectedAnswer()
                } else {
                    goToNextViewController()
                }
            case UISwipeGestureRecognizerDirection.left:
                performSegue(withIdentifier: "GoBack", sender: self)
                print("swipe left")
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Objects
    // Sets up the next view controller and go to the next
    @objc
    func goToNextViewController() {
        
        nextViewController = initNextViewController()
        
        if nextViewController != nil {
            setupNextViewController()
            UIView.beginAnimations("View Flip", context: nil)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationTransition(.curlUp, for: view, cache: true)
            nextViewController.view.frame = view.frame
            switchViewController(currentViewController, to: nextViewController)
            currentViewController = nextViewController
            UIView.commitAnimations()
            nextViewController = nil
        }
    }
    
    @objc
    func selectedAnswer() {
        let questionVC = self.currentViewController as! QuestionViewController
        self.quiz.addAnswer(question: self.currentQuestion, chosenAnswerIndex: questionVC.answer, correctAnswerIndex: self.currentQuestion.correctAnswerIndex)
        DispatchQueue.global(qos: .userInitiated).async {
            self.saveProgress()
        }
        self.currentViewController.navigationItem.rightBarButtonItem?.isEnabled = true
        self.goToNextViewController()
    }
    
    // MARK: - Child View Controller Manager
    // Init the next view controller
    func initNextViewController() -> (UIViewController?) {
        // If the user WAS in the middle of answering the question
        if isAnswering {
            isAnswering = false
            return storyboard?
                .instantiateViewController(withIdentifier: "AnswerViewController") as! AnswerViewController
            // If the quiz is not complete and the user WAS NOT in the middle of answering the question
        } else if !isAnswering && !quiz.isCompleted {
            isAnswering = true
            return storyboard?
                .instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        }
        // If the quiz is completed or has no question.
        return storyboard?
            .instantiateViewController(withIdentifier: "QuestionsTableViewController") as! QuestionsTableViewController
    }
    
    // Setup the next view controller
    func setupNextViewController() {
        switch nextViewController {
        case let viewController as QuestionViewController:
            // Sets up next question
            let submitButton = UIBarButtonItem.init(
                title: "Submit",
                style: .done,
                target: self,
                action: #selector(selectedAnswer) // Need to send the answer back
            )
            submitButton.isEnabled = false
            navigationItem.rightBarButtonItem = submitButton
            viewController.quiz = quiz
            viewController.headerImage = quiz.image
            viewController.onAnswerSelected = {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.prompt = "Answer selected, submit to continue."
            }
            viewController.currentQuestionNum = currentQuestionNum
        case let viewController as QuestionsTableViewController:
            // Sets up questions table
            viewController.quiz = quiz
            navigationItem.rightBarButtonItem = nil
        case let viewController as AnswerViewController:
            // Sets up the answer
            self.navigationItem.prompt = nil
            viewController.answer = quiz.answers[quiz.answers.count - 1 ]
            viewController.headerImage = quiz.image
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                title: "Next",
                style: .plain,
                target: self,
                action: #selector(goToNextViewController)
            )
        default:
            break
        }
    }
    
    // Switch the given view controller to another view controller
    fileprivate func switchViewController(_ from: UIViewController?, to: UIViewController?) {
        if from != nil {
            from!.willMove(toParentViewController: nil)
            from!.view.removeFromSuperview()
            from!.removeFromParentViewController()
        }
        if to != nil {
            self.addChildViewController(to!)
            self.view.insertSubview(to!.view, at: 2)
            to!.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - [Unused] Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "ShowQuestionTable":
            print("ShowQuestionTable")
            let destination = segue.destination as! QuestionsTableViewController
            destination.quiz = quiz
            navigationItem.rightBarButtonItem = nil
        case "ShowQuestion":
            print("ShowQuestion")
            let destination = segue.destination as! QuestionViewController
            let submitButton = UIBarButtonItem.init(
                title: "Submit",
                style: .done,
                target: self,
                action: #selector(selectedAnswer) // Need to send the answer back
            )
            submitButton.isEnabled = false
            navigationItem.rightBarButtonItem = submitButton
            destination.quiz = quiz
            destination.headerImage = quiz.image
            destination.onAnswerSelected = {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.navigationItem.prompt = "Answer selected, submit to continue."
            }
            destination.currentQuestionNum = currentQuestionNum
        case "ShowAnswer":
            print("ShowAnswer")
            self.navigationItem.prompt = nil
            let destination = segue.destination as! AnswerViewController
            destination.answer = quiz.answers[quiz.answers.count - 1 ]
            destination.headerImage = quiz.image
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(
                title: "Next",
                style: .plain,
                target: self,
                action: #selector(goToNextViewController)
            )
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
}

