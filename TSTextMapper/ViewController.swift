//
//  ViewController.swift
//  TSTextMapper
//
//  Created by Tomasz Szulc on 31/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "All of these words are able to be selected. Spaces too. You can specify ranges of text to be selected too if you want."
    }
    
    private var mapper: TSTextMapper?
    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        if self.mapper == nil {
            self.mapper = TSTextMapper(self.label)
            // 1. All words
            self.mapper!.mapTextAndMakeAllTappable(self.label.text!)
            
            // 2. Only "Spaces" word is tappable
//            let range = (self.label.text as NSString!).rangeOfString("Spaces")
//            self.mapper!.mapTextWithTappableRanges([range], text: self.label.text!)
        }
        
        let point = recognizer.locationInView(self.label)
        if let word = self.mapper!.textForPoint(point) {
            let alert = UIAlertView(title: nil, message: word.value, delegate: nil, cancelButtonTitle: nil)
            alert.show()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(0, animated: true)
            })
        }
    }
}

