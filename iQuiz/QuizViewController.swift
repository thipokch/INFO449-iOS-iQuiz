//
//  DetailViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/2/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit
class QuizViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet var questionTableView: UITableView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundOverlay: UIImageView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let quiz = quizItem {
            self.title = quiz.title
            
            if let description = quiz.description {
                if detailDescriptionLabel != nil {
                    detailDescriptionLabel.text = description
                }
            }
            if let image = quiz.image {
                background?.image = image
                backgroundOverlay?.image = image
            }
        }
    }

    override func viewDidLoad() {
    parent?.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.questionTableView.contentInsetAdjustmentBehavior = .never
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var quizItem: Quiz? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let frameRect = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: -tableView.contentOffset.y + 250)
        tableView.tableHeaderView?.frame = frameRect
    }
}

