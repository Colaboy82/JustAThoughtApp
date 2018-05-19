//
//  TutorialPage.swift
//  JustAThought
//
//  Created by Grumpy1211 on 3/22/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit

class TutorialPage: UIViewController {

    @IBOutlet weak var howPostBtn: UIButton!
    @IBOutlet weak var howLikeBtn: UIButton!
    @IBOutlet weak var howNavBtn: UIButton!
    @IBOutlet weak var howResetPwBtn: UIButton!
    @IBOutlet weak var buttonFuncBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        howPostBtn.layer.shadowColor = UIColor.black.cgColor
        howPostBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        howPostBtn.layer.masksToBounds = false
        howPostBtn.layer.shadowRadius = 1.0
        howPostBtn.layer.shadowOpacity = 0.5
        howPostBtn.layer.cornerRadius = 7
        howPostBtn.showsTouchWhenHighlighted = true
        
        howLikeBtn.layer.shadowColor = UIColor.black.cgColor
        howLikeBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        howLikeBtn.layer.masksToBounds = false
        howLikeBtn.layer.shadowRadius = 1.0
        howLikeBtn.layer.shadowOpacity = 0.5
        howLikeBtn.layer.cornerRadius = 7
        howLikeBtn.showsTouchWhenHighlighted = true
        
        howNavBtn.layer.shadowColor = UIColor.black.cgColor
        howNavBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        howNavBtn.layer.masksToBounds = false
        howNavBtn.layer.shadowRadius = 1.0
        howNavBtn.layer.shadowOpacity = 0.5
        howNavBtn.layer.cornerRadius = 7
        howNavBtn.showsTouchWhenHighlighted = true
        
        howResetPwBtn.layer.shadowColor = UIColor.black.cgColor
        howResetPwBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        howResetPwBtn.layer.masksToBounds = false
        howResetPwBtn.layer.shadowRadius = 1.0
        howResetPwBtn.layer.shadowOpacity = 0.5
        howResetPwBtn.layer.cornerRadius = 7
        howResetPwBtn.showsTouchWhenHighlighted = true
        
        buttonFuncBtn.layer.shadowColor = UIColor.black.cgColor
        buttonFuncBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        buttonFuncBtn.layer.masksToBounds = false
        buttonFuncBtn.layer.shadowRadius = 1.0
        buttonFuncBtn.layer.shadowOpacity = 0.5
        buttonFuncBtn.layer.cornerRadius = 7
        buttonFuncBtn.showsTouchWhenHighlighted = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavigationBar() {
        self.navigationItem.title = "Tutorials"
    }
}
