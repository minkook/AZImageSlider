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

    @IBOutlet weak var imageSlider: AZImageSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageSlider.maxValue = 10
        
        //---------------------------
        //---------------------------
//        self.view.backgroundColor = UIColor.lightGray
        imageSlider.layer.borderWidth = 1.0
        imageSlider.layer.borderColor = UIColor.red.cgColor
        //---------------------------
        //---------------------------
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButtonAction(_ sender: Any) {
        
        imageSlider.customImage = UIImage(systemName: "tortoise")
        
        imageSlider.value = 5
        
    }
    
}

