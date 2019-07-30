//
//  ViewController.swift
//  XYYZWorldExample
//
//  Created by AG on 2019/7/30.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         let node = XYYZNode()
        node.URL = "https://www.baidu.com"
        XYYZWorldCenter.default.reuqest(node: node)
        XYYZWorldCenter.default.reuqest(node: node)
        XYYZWorldCenter.default.reuqest(node: node)
        XYYZWorldCenter.default.reuqest(node: node)
    }


}

