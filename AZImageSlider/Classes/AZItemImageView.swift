//
//  AZItemImageView.swift
//  AZImageSlider
//
//  Created by minkook yoo on 2022/01/12.
//

import Foundation

class AZItemImageView: UIImageView {
    
    public var originFrame: CGRect = CGRect.zero
    
    public var visible: Bool { get { return self.transform.a > 0 } }
    
    public func autoTransform(_ vector: CGVector, completion: (() -> Void)?) {
        
        let v = self.transform.a
        
        if v == 0 || v == 1 { return }
        
        let animateDuration: TimeInterval = 0.2
        
        if vector.dx < 0 {
            
            UIView.animate(withDuration: animateDuration) {
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            } completion: { finish in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                if let completion = completion {
                    completion()
                }
            }
            
        }
        else {
            
            UIView.animate(withDuration: animateDuration) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: { finish in
                if let completion = completion {
                    completion()
                }
            }
            
        }
        
    }
    
}
