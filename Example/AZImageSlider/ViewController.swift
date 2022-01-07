//
//  ViewController.swift
//  AZImageSlider
//
//  Created by minkook on 01/07/2022.
//  Copyright (c) 2022 minkook. All rights reserved.
//

import UIKit
import AZImageSlider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 100)
        let imageSlider: AZImageSlider = AZImageSlider(frame: frame)
        self.view.addSubview(imageSlider)
        
        
        //---------------------------
        //---------------------------
        self.view.backgroundColor = UIColor.lightGray
        imageSlider.layer.borderWidth = 1.0
        imageSlider.layer.borderColor = UIColor.red.cgColor
        //---------------------------
        //---------------------------
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

