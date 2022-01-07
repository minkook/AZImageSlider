//
//  AZImageSlider.swift
//  AZImageSlider
//
//  Created by minkook yoo on 2022/01/07.
//

import Foundation

open class AZImageSlider: UIControl {
    
    
    public var value: Int {
        get { return _value }
        set {
            _value = newValue
            reload(_value)
        }
    }
    
    public var maxValue: Int {
        get { return _maxValue }
        set {
            _maxValue = newValue
            adjustItems()
        }
    }
    
    
    //
    public var customImage: UIImage?
    
    
    //
    public var sensitivity: CGFloat = 0.58
    
    
    //-----------------------------------------------------------------------------
    //-----------------------------------------------------------------------------
    //-----------------------------------------------------------------------------
    
    
    private var _value: Int = 0
    private var _maxValue: Int = 5
    
    private var items: Array<ItemImageView> = []
    
    private var defaultImage: UIImage {
        
        let bundle = Bundle(for: AZImageSlider.self)
        if let img = UIImage(named: "man", in: bundle, compatibleWith: nil) {
            return img
        }
        
        return UIImage()
        
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        maxValue = 5
    }
    
    private func adjustItems() {
        
        var image = defaultImage
        if let customImage = customImage {
            image = customImage
        }
        
        items.removeAll()
        
        let w = self.bounds.width / CGFloat(maxValue)
        let h = self.bounds.height
        
        for i in 0..<5 {
            
            let imageView = ItemImageView(image: image)
            let x = w * CGFloat(i)
            let frame = CGRect(x: x, y: 0, width: w, height: h)
            imageView.frame = frame
            imageView.originFrame = frame
            
            self.addSubview(imageView)
            items.append(imageView)
        }
        
    }
    
}



// MARK: reload
extension AZImageSlider {
    
    private func reload(_ index: Int) {
        let item = items[index]
        reload(CGPoint(x: item.originFrame.maxX, y: item.originFrame.minY))
    }
    
    private func reload(_ pt: CGPoint) {
        
        let index = indexOfTouchPoint(pt)
        if index != NSNotFound {
            
            for i in 0..<items.count {
                
                let item = items[i]
                
                var v = (pt.x - item.originFrame.minX) / item.originFrame.width
                
                v = max(v, 0.0)
                v = min(v, 1.0)
                
                item.transform = CGAffineTransform(scaleX: v, y: v)
                
            }
            
        }
        
    }
    
}



// MARK: touch
extension AZImageSlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        reload(pt)
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        reload(pt)
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        for i in 0..<items.count {
            let item = items[i]
            if item.autoTransform(sensitivity) {
                _value = i
            }
        }
    }
    
    private func indexOfTouchPoint(_ pt: CGPoint) -> Int {
        
        var index: Int = NSNotFound
        
        for i in 0..<items.count {
            let item = items[i]
            let point = CGPoint(x: pt.x, y: item.originFrame.midY)
            if item.originFrame.contains(point) {
                index = i
                break
            }
        }
        
        return index
    }
    
}



// MARK: ItemImageView
class ItemImageView: UIImageView {
    
    public var originFrame: CGRect = CGRect.zero
    
    private let standardScale: CGFloat = 0.58
    
    public func autoTransform(_ sensitivity: CGFloat) -> Bool {
        
        let v = self.transform.a
        
        if 0 < v && v < 1 {
            
            if v <= sensitivity {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                } completion: { isFinish in
                    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                }
            }
            else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
            
            return true
        }
        else {
            return false
        }
        
    }
    
    //---------------------------
    override init(image: UIImage?) {
        super.init(image: image)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.green.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //---------------------------
    
}
