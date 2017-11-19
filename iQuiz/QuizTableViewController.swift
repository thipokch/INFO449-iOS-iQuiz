//
//  MasterViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/2/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit
import os.log

class QuizTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Variables
    // Populate data from the UITableViewSource
    var quizzes:[Quiz]! = []
    // For Split View
    var quizViewController: QuizViewController? = nil
    var libraryDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let defaults = UserDefaults.standard
    
    // MARK: - Data Source
    private func setDefaults() {
        if !defaults.bool(forKey: "defaultsSet") {
            defaults.set(true, forKey: "defaultsSet")
            defaults.set(false, forKey: "quizStarted")
            defaults.set(URL(string: "https://tednewardsandbox.site44.com/questions.json"), forKey: "remoteSourceURL")
            defaults.set(true, forKey: "useSampleData")
        } else {
            print("default not set")
        }
        
    }
    
    private func saveQuiz() {
        DispatchQueue.global(qos: .utility).async {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.quizzes, toFile: Quiz.ArchiveURL.path)
            if isSuccessfulSave {
                os_log("Quizzes successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save quizzes...", log: OSLog.default, type: .error)
            }
        }
    }
    
    private func loadQuiz() -> [Quiz]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Quiz.ArchiveURL.path) as? [Quiz]
    }
    
    private func loadSample() {
        quizzes =  UITableViewSource().quizzes
    }
    
    private func loadDataMain(loadFromCache:Bool) {
        if defaults.bool(forKey: "useSampleData") && !defaults.bool(forKey: "quizStarted")
        {
            loadSample()
        } else if let loadedQuiz = loadQuiz(),
            loadedQuiz.count > 1 && !loadFromCache{
            quizzes = loadedQuiz
            os_log("Quizzes successfully loaded.", log: OSLog.default, type: .debug)
        } else if let cachedString = self.loadCachedString(),
            let quizzesData = try? JSONSerialization.jsonObject(with: cachedString.data(using: .utf8)!) as! [Any] {
            quizzes = []
            for quizData in quizzesData {
                let quiz = Quiz(JSONObject: quizData)
                quizzes.append(quiz!)
            }
        }
        defaults.set(true, forKey: "quizStarted")
    }
    
    // Load JSON From Remote
    private func loadRemoteString() -> String? {
        if let remoteUrl = defaults.url(forKey: "remoteSourceURL") {
            do {
                // Quickly fetch the string from the remote url. Used to increase the speed.
                let contents = try String(contentsOf: remoteUrl)
                print(contents)
                return contents
            } catch {
                os_log("Error loading string from remote url: Cannot load from remote", log: .default, type: .error)
            }
        } else {
            os_log("Error loading string from remote url: Bad URL", log: .default, type: .error)
        }
        return nil
    }
    
    // Store JSON to Local Storage
    private func cacheRemoteString() {
        if let RemoteString = loadRemoteString()
            {
            let cacheUrl = libraryDirectory.appendingPathComponent("remoteStringCache")
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(RemoteString, toFile: cacheUrl.path)
            if isSuccessfulSave {
                os_log("Remote Strings successfully cached", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to cache remote string...", log: OSLog.default, type: .error)
            }
        }
    }
    
    // Load JSON from cache
    private func loadCachedString() -> String? {
        let cacheUrl = libraryDirectory.appendingPathComponent("remoteStringCache")
        let loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: cacheUrl.path) as? String
        if loadedData != nil {
            os_log("Loaded Cached Strings successfully", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to load cached strings...", log: OSLog.default, type: .error)
        }
        return loadedData
    }
    
    private func updateData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.cacheRemoteString()
            self.loadDataMain(loadFromCache: true)
            DispatchQueue.global(qos: .utility).async {
                self.saveQuiz()
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
        }
    }
    
    // MARK: - Popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Objects
    // Settings button
    @objc
    func goToSettings(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc
    func refresh() {
        refreshControl?.beginRefreshing()
        self.updateData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - View Controller Events
    
    override func viewDidLoad() {
        
        // Sets transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInteractive).async {
            self.cacheRemoteString()
        }
        self.setDefaults()
        self.loadDataMain(loadFromCache: false)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(QuizTableViewController.refresh), for: .valueChanged)
        
        //        else {
        //            self.loadSample()
        //        }
        
        // Add background to navigation bar
        // navigationController?.navigationBar.barTintColor = UIColor(patternImage: image!)
        
        // Add edit and settings button
        navigationItem.leftBarButtonItem = editButtonItem
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettings(_:)))
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
        switch segue.identifier! {
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
                let quiz = quizzes[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! QuizViewController
                controller.quiz = quiz
                controller.saveProgress = saveQuiz
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        case "PopoverSettings":
            let popoverViewController = segue.destination as! SettingsViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.preferredContentSize = CGSize(width: view.bounds.width, height: CGFloat(300))
            popoverViewController.updateFunc = updateData
        default:
            os_log("Unrecognised Segue", log: OSLog.default, type: .error)
        }
    }
    
    
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    // Populate tableview with quizzes information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let quiz = quizzes[indexPath.row]
        cell.textLabel!.text = quiz.title
        if quiz.descriptionText != nil {
            cell.detailTextLabel?.text = quiz.descriptionText
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
            quizzes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

