//
//  RoundImageView.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//
import UIKit

class RoundImageView: UIImageView {
     
    public var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    public var customCornerRadius: CGFloat? {
        didSet {
            setNeedsLayout()  
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = customCornerRadius ?? self.frame.size.width/2
        self.clipsToBounds = true
    }
}

