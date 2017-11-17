//
//  ImageHeaderView.swift
//  iQuiz
//
//  Created by Thipok Cholsaipant on 11/9/17.
//  Copyright © 2017 Thipok Cholsaipant. All rights reserved.
//

import UIKit

class ImageHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var backgroundOverlay: UIImageView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var largeNumText: UILabel!
    @IBOutlet weak var smallNumText: UILabel!
    
    var image:UIImage!{
        didSet {
            background.image = image
            backgroundOverlay.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "ImageHeaderView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
