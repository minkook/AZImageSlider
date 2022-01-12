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
        
        //---------------------------
        //---------------------------
        imageSlider.layer.borderWidth = 1.0
        imageSlider.layer.borderColor = UIColor.red.cgColor
        //---------------------------
        //---------------------------
        
        imageSlider.maxValue = 10
        
        setUpImageSliderDelegate()
        
        imageSlider.didChangeTrackingValueBlock = { value in
            print("block value: \(value)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButtonAction(_ sender: Any) {
        
//        imageSlider.value = 5
        
        imageSlider.customImage = UIImage(systemName: "tortoise")
        
//        imageSlider.imageContentMode = .scaleAspectFill
        
    }
    
}


extension ViewController: AZImageSliderDelegate {
    
    func setUpImageSliderDelegate() {
        imageSlider.delegate = self
    }
    
    func didChangeTrackingValue(_ imageSlider: AZImageSlider, value: Int) {
        print("delegate value: \(value)")
    }
    
}

