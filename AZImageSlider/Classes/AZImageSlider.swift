//
//  AZImageSlider.swift
//  AZImageSlider
//
//  Created by minkook yoo on 2022/01/07.
//

import Foundation
import UIKit

open class AZImageSlider: UIControl {
    
    
    //-----------------------------------------------------------------------------
    // MARK: Control
    
    // current value
    // default to 0
    public var value: Int {
        get { return _value }
        set {
            _value = newValue
            reload(_value)
        }
    }
    
    // maximum value
    // default to 5
    public var maxValue: Int {
        get { return _maxValue }
        set {
            _maxValue = newValue
            adjustItems()
        }
    }
    
    
    
    //-----------------------------------------------------------------------------
    // MARK: Design
    
    // default to nil
    public var customImage: UIImage? {
        get { return _customImage }
        set {
            _customImage = newValue
            adjustItems()
        }
    }
    
    // default to scaleAspectFit
    public var imageContentMode: UIView.ContentMode {
        get { return _imageContentMode }
        set {
            _imageContentMode = newValue
            adjustItems()
        }
    }
    
    
    
    //-----------------------------------------------------------------------------
    // MARK: Change Tracking Event
    
    // delegate type
    public weak var delegate: AZImageSliderDelegate?
    
    // block type
    public var didChangeTrackingValueBlock: ((Int)-> Void)?
    
    
    
    //-----------------------------------------------------------------------------
    // MARK: private
    
    private var _value: Int = 0
    private var _maxValue: Int = 5
    private var _customImage: UIImage? = nil
    private var _imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    private var items: Array<AZItemImageView> = []
    
    private lazy var defaultImage: UIImage = {
        let bundle = Bundle(for: AZImageSlider.self)
        if let url = bundle.url(forResource: "AZImageSlider", withExtension: "bundle") {
            if let img = UIImage(named: "man", in: Bundle(url: url), compatibleWith: nil) {
                return img
            }
        }
        return UIImage()
    }()
    
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
        
        let time = DispatchTime.now() + .microseconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.adjustItemsCore()
            self.reload(self.value)
        }
        
    }
    
    private func adjustItemsCore() {
        
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

            let imageView = AZItemImageView(image: image)
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
        var point: CGPoint = .zero
        if value > 0 {
            let item = items[value - 1]
            point = CGPoint(x: item.originFrame.maxX, y: item.originFrame.minY)
        }
        reload(point)
    }
    
    private func reload(_ pt: CGPoint) {
        
        let index = indexOfTouchPoint(pt)
        if index == NSNotFound { return }
        
        var currentValue = 0
        for i in 0..<items.count {
            
            let item = items[i]
            
            var v = (pt.x - item.originFrame.minX) / item.originFrame.width
            
            v = max(v, 0.0)
            v = min(v, 1.0)
            
            item.transform = CGAffineTransform(scaleX: v, y: v)
            
            if item.visible {
                currentValue = (i + 1)
            }
            
        }
        
        self.changeValue(currentValue)
        
    }
    
}



// MARK: tracking
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
                
                let currentValue = item.visible ? (i + 1) : i
                self.changeValue(currentValue)
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
    
    private func changeValue(_ currentValue: Int) {
        
        if currentValue == _value {
            return
        }
        
        // will
        //
        
        _value = currentValue
        
        // did
        if let delegate = self.delegate {
            delegate.didChangeTrackingValue(self, value: _value)
        }
        
        if let block = self.didChangeTrackingValueBlock {
            block(_value)
        }
        
    }
    
}
