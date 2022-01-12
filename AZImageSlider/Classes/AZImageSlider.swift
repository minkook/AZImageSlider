//
//  AZImageSlider.swift
//  AZImageSlider
//
//  Created by minkook yoo on 2022/01/07.
//

import Foundation

open class AZImageSlider: UIControl {
    
    
    //-----------------------------------------------------------------------------
    // MARK: Control
    
    // current value
    public var value: Int {
        get { return _value }
        set {
            _value = newValue
            reload(_value)
        }
    }
    
    
    // maximum value
    public var maxValue: Int {
        get { return _maxValue }
        set {
            _maxValue = newValue
            adjustItems()
        }
    }
    
    
    
    //-----------------------------------------------------------------------------
    // MARK: Design
    
    // cuctom image
    public var customImage: UIImage? {
        get { return _customImage }
        set {
            _customImage = newValue
            adjustItems()
        }
    }
    
    
    public var imageContentMode: UIView.ContentMode {
        get { return _imageContentMode }
        set {
            _imageContentMode = newValue
            adjustItems()
        }
    }
    
    
    
    //-----------------------------------------------------------------------------
    // MARK: private
    
    private var _value: Int = 0
    private var _maxValue: Int = 5
    private var _customImage: UIImage? = nil
    private var _imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    private var items: Array<ItemImageView> = []
    
    private var defaultImage: UIImage {
        
        let bundle = Bundle(for: AZImageSlider.self)
        if let img = UIImage(named: "man", in: bundle, compatibleWith: nil) {
            return img
        }
        
        return UIImage()
        
    }
    
    private var startPoint: CGPoint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.maxValue = 5
    }
    
    private func adjustItems() {
        
        var image = defaultImage
        if let customImage = _customImage {
            image = customImage
        }
        
        for item in items {
            item.removeFromSuperview()
        }
        items.removeAll()
        
        let w = self.bounds.width / CGFloat(_maxValue)
        let h = self.bounds.height
        
        for i in 0..<_maxValue {
            
            let imageView = ItemImageView(image: image)
            imageView.contentMode = self.imageContentMode
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
    
    private func reload(_ value: Int) {
        let item = items[value - 1]
        reload(CGPoint(x: item.originFrame.maxX, y: item.originFrame.minY))
    }
    
    private func reload(_ pt: CGPoint) {
        
        let index = indexOfTouchPoint(pt)
        if index == NSNotFound { return }
        
        for i in 0..<items.count {
            
            let item = items[i]
            
            var v = (pt.x - item.originFrame.minX) / item.originFrame.width
            
            v = max(v, 0.0)
            v = min(v, 1.0)
            
            item.transform = CGAffineTransform(scaleX: v, y: v)
            
            if item.visible {
                _value = (i + 1)
            }
            
        }
        
    }
    
}



// MARK: touch
extension AZImageSlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        reload(pt)
        startPoint = pt
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        reload(pt)
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        defer {
            startPoint = nil
        }
        
        guard let spt = startPoint else { return }
        
        guard let touch = touch else { return }
        
        let ept = touch.location(in: self)
        let vector = CGVector(dx: ept.x - spt.x, dy: ept.y - spt.y)
        
        for i in 0..<items.count {
            let item = items[i]
            item.autoTransform(vector) { [weak self] in
                guard let self = self else { return }
                self._value = item.visible ? (i + 1) : i
            }
        }
        
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        startPoint = nil
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
