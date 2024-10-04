//
//  NotificationBadgeCountView.swift
 
import Foundation
import UIKit

class NotificationBadgeCountView: UIView {
    
    private let maxCount: Int = 99
    
    var count: Int = 0 {
        didSet {
            isHidden = count == 0  
            setNeedsLayout()
        }
    }
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = ThemeManager.shared.getCurrentThemeColors().red1
        clipsToBounds = true
        
        addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 8), // Adjust size as needed
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the corner radius to make the view a circle
        layer.cornerRadius = bounds.height / 2
        
        // Adjust the size of the circle view based on whether there are notifications or not
        let circleSize: CGFloat = count > 0 ? bounds.height * 0.3 : 0
        circleView.layer.cornerRadius = circleSize / 2
        circleView.widthAnchor.constraint(equalToConstant: circleSize).isActive = true
        circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor).isActive = true
    }
}

