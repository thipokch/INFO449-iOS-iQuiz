//
//  DetailViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/2/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit
class QuestionsTableViewController: UITableViewController {
    
    var quiz:Quiz!
    var defaultTableViewHeight:CGFloat!
    @IBOutlet weak var imageHeaderView: ImageHeaderView!
    
    override func viewDidLoad() {
        self.tableView.contentInsetAdjustmentBehavior = .never
        defaultTableViewHeight = tableView.frame.height / 2
        let frameRect = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: defaultTableViewHeight)
        tableView.tableHeaderView?.frame = frameRect
        super.viewDidLoad()
        setupHeaderView()
        tableView.allowsSelection = false
        // Do any additional setup after loading the view, typically from a nib.
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let frameRect = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: -tableView.contentOffset.y + defaultTableViewHeight)
//        tableView.tableHeaderView?.frame = frameRect
//    }
//
    func setupHeaderView() {
        if let view = imageHeaderView {
            if quiz.questions.count == quiz.numOfCorrectAnswers {
                view.headerText.text = "Well Done"
            } else if quiz.questions.count == 0 {
                view.headerText.text = "No question to be answered."
            } else if Double(quiz.numOfCorrectAnswers / quiz.questions.count) > 0.75 {
                view.headerText.text = "Almost"
            } else {
                view.headerText.text = "Try Harder"
            }
            if quiz != nil {
                view.largeNumText.isHidden = false
                view.largeNumText.text = String(quiz.numOfCorrectAnswers)
                view.smallNumText.isHidden = false
                view.smallNumText.text = "of " + String(quiz.questions.count)
            }
            view.image = quiz.image
        }
    }
    
    // populate the answer table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
        cell.textLabel!.text = quiz.questions[indexPath.row].text
        if indexPath.row < quiz.answers.count {
            let answer = quiz.answers[indexPath.row]
            if answer.isCorrect {
                cell.imageView?.image = UIImage(named: "selectIcon_correct")
            } else {
                cell.imageView?.image = UIImage(named: "selectIcon_incorrect")
            }
        }
        return cell
    }
}

