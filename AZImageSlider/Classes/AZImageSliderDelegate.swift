//
//  AZImageSliderDelegate.swift
//  AZImageSlider
//
//  Created by minkook yoo on 2022/01/12.
//

import Foundation

public protocol AZImageSliderDelegate: AnyObject {
    
    func didChangeTrackingValue(_ imageSlider: AZImageSlider, value: Int)
    
}
