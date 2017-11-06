//
//  UITableViewSource.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/5/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import Foundation
import UIKit

class UITableViewSource {
    var quizes = [Quiz("Mathematics"), Quiz("Marvel Super Heroes"), Quiz("Science")]
    
    init() {
        quizes[0].description = "Some maths work to get your minds running."
        quizes[1].description = "Save the day."
        quizes[2].description = "For all the nerds out there."
        
        quizes[0].image = UIImage(named: "Mathematics")
        quizes[1].image = UIImage(named: "Marvel")
        quizes[2].image = UIImage(named: "Science")
    }
    
}
