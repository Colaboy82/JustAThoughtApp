//
//  InfoVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 1/29/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var aboutAppBtn: UIButton!
    @IBOutlet weak var aboutMuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
        tutorialBtn.layer.shadowColor = UIColor.black.cgColor
        tutorialBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tutorialBtn.layer.masksToBounds = false
        tutorialBtn.layer.shadowRadius = 1.0
        tutorialBtn.layer.shadowOpacity = 0.5
        tutorialBtn.layer.cornerRadius = 7
        tutorialBtn.showsTouchWhenHighlighted = true
        
        contactUsBtn.layer.shadowColor = UIColor.black.cgColor
        contactUsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        contactUsBtn.layer.masksToBounds = false
        contactUsBtn.layer.shadowRadius = 1.0
        contactUsBtn.layer.shadowOpacity = 0.5
        contactUsBtn.layer.cornerRadius = 7
        contactUsBtn.showsTouchWhenHighlighted = true
        
        aboutAppBtn.layer.shadowColor = UIColor.black.cgColor
        aboutAppBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        aboutAppBtn.layer.masksToBounds = false
        aboutAppBtn.layer.shadowRadius = 1.0
        aboutAppBtn.layer.shadowOpacity = 0.5
        aboutAppBtn.layer.cornerRadius = 7
        aboutAppBtn.showsTouchWhenHighlighted = true
        
        aboutMuBtn.layer.shadowColor = UIColor.black.cgColor
        aboutMuBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        aboutMuBtn.layer.masksToBounds = false
        aboutMuBtn.layer.shadowRadius = 1.0
        aboutMuBtn.layer.shadowOpacity = 0.5
        aboutMuBtn.layer.cornerRadius = 7
        aboutMuBtn.showsTouchWhenHighlighted = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "Info Page"
    }

}
