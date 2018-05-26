//
//  AboutUsPage.swift
//  JustAThought
//
//  Created by Grumpy1211 on 3/22/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit

class AboutPages: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        //toolbarView.isHidden = false
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavigationBar() {//"AboutUsPage" "AboutAppPage"
        if(self.title == "AboutAppPage"){
            self.navigationItem.title = "About MuSquared"
        }else{
            self.navigationItem.title = "About Just A Thought"
        }
    }
}
