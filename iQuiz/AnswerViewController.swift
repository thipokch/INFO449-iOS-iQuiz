//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/9/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var answer:Answer!
    var question:Question! {
        get {
            return answer.question
        }
    }
    var headerImage:UIImage!

    @IBOutlet weak var imageHeaderView: ImageHeaderView!
    @IBOutlet weak var answerSelectionTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Load data source & delegate to table
        answerSelectionTable.dataSource = self
        answerSelectionTable.delegate = self
        // Do any additional setup after loading the view.
        answerSelectionTable.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupHeaderView() {
        if let view = imageHeaderView {
            if answer != nil {
                view.headerText.text = answer.question.text
            }
            if headerImage != nil {
                view.image = headerImage
            }
            if answer.isCorrect {
                view.largeNumText.isHidden = false
                view.largeNumText.text = "✓"
            } else {
                view.largeNumText.isHidden = false
                view.largeNumText.text = "✗"
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
        if indexPath.row == answer.chosenAnswerIndex {
            cell.imageView?.image = UIImage(named: "selectIcon_incorrect")
        }
        if indexPath.row == answer.correctAnswerIndex {
            cell.imageView?.image = UIImage(named: "selectIcon_correct")
        }
        return cell
    }
}
