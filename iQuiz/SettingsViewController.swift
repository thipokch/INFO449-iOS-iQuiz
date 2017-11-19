//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/19/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

import UIKit
import os.log

class SettingsViewController: UIViewController {
    var updateFunc:(() -> ())! = {
        os_log("Settings could be updated: No function is assigned to updateFunc.", log: .default, type: .error)
    }
    @IBOutlet weak var sampleDataSwitch: UISwitch!
    @IBOutlet weak var RemoteUrlTextField: UITextField!
    
    @IBAction func performUpdate(_ sender: Any) {
        if let url = URL(string: RemoteUrlTextField.text!) {
            UserDefaults.standard.set(url, forKey: "remoteSourceURL")
            updateFunc()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleDataSwitch.isOn = UserDefaults.standard.bool(forKey: "useSampleData")
        RemoteUrlTextField.text = UserDefaults.standard.url(forKey: "remoteSourceURL")?.absoluteString
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchSampleData(_ sender: UISwitch) {
        UserDefaults.standard.set(false, forKey: "quizStarted")
        UserDefaults.standard.set(sender.isOn, forKey: "useSampleData")
        updateFunc()
    }
    
}

