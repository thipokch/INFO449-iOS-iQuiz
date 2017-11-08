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
        quizes[0].description = "Numbers. Algebras. Shapes."
        quizes[1].description = "From the world's leading super heroes studio"
        quizes[2].description = "Chemistry. Biology. Physics."
        
        quizes[0].image = UIImage(named: "Mathematics")
        quizes[1].image = UIImage(named: "Marvel")
        quizes[2].image = UIImage(named: "Science")
    }
    
}
