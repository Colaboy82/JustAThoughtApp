//
//  NavigationController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 1/1/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    @IBOutlet weak var searchToolbar: UIToolbar!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        //stimer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(NavigationController.checkToolbar), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    @objc func checkToolbar(){
        if mainInstance.toolbarShow == true {
            toolbar.isHidden = false
        } else{
            toolbar.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
