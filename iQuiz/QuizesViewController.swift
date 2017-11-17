//
//  MasterViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/2/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

//extension UIImage {
//
//    func alpha(_ value:CGFloat) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//}

class QuizesViewController: UITableViewController {
    
    // Populate data from the UITableViewSource
    var quizes:[Quiz] = UITableViewSource().quizes
    // For Split View
    var quizViewController: QuizViewController? = nil
    
    // Settings button
    @objc
    func goToSettings(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Setup View Controller
    
    override func viewDidLoad() {
        // Sets transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        super.viewDidLoad()
        
        // Add background to navigation bar
        // navigationController?.navigationBar.barTintColor = UIColor(patternImage: image!)
        
        // Add edit and settings button
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettings(_:)))

        // Add to tableview
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        
        // Split View
        if let split = splitViewController {
            let controllers = split.viewControllers
            quizViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? QuizViewController
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let quiz = quizes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! QuizViewController
                controller.quiz = quiz
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizes.count
    }

    // Populate tableview with quizzes information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let quiz = quizes[indexPath.row]
        cell.textLabel!.text = quiz.title
        if quiz.description != nil {
            cell.detailTextLabel?.text = quiz.description
        }
        cell.imageView?.image = quiz.image
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            quizes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

