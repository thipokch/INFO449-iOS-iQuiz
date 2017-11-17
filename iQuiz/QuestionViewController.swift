//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/7/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageHeaderView: ImageHeaderView!
    @IBOutlet weak var answerSelectionTable: UITableView!
    
    var quiz:Quiz!
    var question:Question! {
        return quiz.questions[currentQuestionNum]
    }
    var headerImage:UIImage!
    var currentQuestionNum:Int!
    
    private(set) var answer:Int!
    var onAnswerSelected:(() -> ())! = {
        print("notSet")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Load data source & delegate to table
        answerSelectionTable.dataSource = self
        answerSelectionTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupHeaderView() {
        if let view = imageHeaderView {
            if question != nil {
                view.headerText.text = question.text
            }
            if headerImage != nil {
                view.image = headerImage
            }
            if currentQuestionNum != nil {
                view.largeNumText.isHidden = false
                view.largeNumText.text = String(currentQuestionNum + 1)
                view.smallNumText.isHidden = false
                view.smallNumText.text = "of " + String(quiz.questions.count)
            }
        }
    }
    
    // populate the answer table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerChoices", for: indexPath)
        cell.textLabel!.text = question.answers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if answer != nil {
            let previousCell = tableView.cellForRow(at: IndexPath(row: answer, section: 0))
            previousCell?.imageView?.image = UIImage(named: "selectIcon_unselected")
        }
    
        onAnswerSelected()
        answer = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.imageView?.image = UIImage(named: "selectIcon_selected")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
